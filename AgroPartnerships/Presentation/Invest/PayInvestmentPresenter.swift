//
//  PayInvestmentPresenter.swift
//  AgroPartnerships
//
//  Created by Kanyinsola Fapohunda on 08/09/2019.
//  Copyright © 2019 AgroPartnerships. All rights reserved.
//

import Foundation
import Paystack

protocol PayInvestmentView: BaseView {
    func showInvestmentSuccessfulDialog(units: Int, amountPaid: Int, authorization: Authorization?)
    
    func showCardAddedDialog()
}

class PayInvestmentPresenter: BasePresenter {
    
    private let apiService: ApiService
    private weak var view: PayInvestmentView?
    
    required init(apiService: ApiService, view: PayInvestmentView) {
        self.apiService = apiService
        self.view = view
    }
    
    func detachView() {
        self.view = nil
    }
    
    func initializeInvestment(_ request: InitializeInvestmentRequest) {
        
        self.view?.showLoading(withMessage: "Initializing Investment . . .")
        
        apiService.initializeInvestment(item: request.item,
                                        units: request.units,
                                        price: request.price,
                                        paymentMethod: request.paymentMethod,
                                        credit: request.credit,
                                        authCode: request.authCode) { (response) in
                                            
                guard let response = response else {
                    self.view?.dismissLoading()
                    self.view?.showAlertDialog(message: StringLiterals.GENERIC_NETWORK_ERROR)
                    return
                }
                
                if response.status == ApiConstants.Success {
                    
                    self.refreshDashboardInformation {
                        self.view?.dismissLoading()

                        if response.investment?.payment?.status == "paid" {
                            
                            self.view?.showInvestmentSuccessfulDialog(units: response.investment!.units ?? 0,
                                                                      amountPaid: response.investment!.amount ?? 0,
                                                                      authorization: nil)
                        } else {
                            let message = response.message ?? "An error occurred while trying to process your payment. Please try again later"
                            self.view?.showAlertDialog(message: message)
                        }
                    }
                } else {
                    self.view?.dismissLoading()
                    let message = "An error occurred while trying to process your payment. Please try again later"
                    self.view?.showAlertDialog(message: message)
                }
        }
    }
    
    func initializeInvestmentWithNewCard(_ request: InitializeInvestmentRequest,
                                         cardParams: PSTCKCardParams,
                                         viewcontroller: UIViewController) {
        
        self.view?.showLoading(withMessage: "Initializing Investment . . .")
        apiService.initializeInvestment(item: request.item,
                                        units: request.units,
                                        price: request.price,
                                        paymentMethod: request.paymentMethod,
                                        credit: request.credit,
                                        authCode: nil) { (response) in
                                            
                guard let response = response else {
                    self.view?.showAlertDialog(message: StringLiterals.GENERIC_NETWORK_ERROR)
                    return
                }
                
                if response.status == ApiConstants.Success {
                    
                    if response.investment?.payment?.status == "pending" {
                        
                        if let paystackKey = response.investment?.payment?.key {
                            Paystack.setDefaultPublicKey(paystackKey)
                        }
                        self.chargeCardWithPaystack(investment: response.investment!, cardParams: cardParams, viewcontroller )
                        
                    }
                } else {
                    self.view?.dismissLoading()
                    let message = "An error occurred while trying to process your payment. Please try again later"
                    self.view?.showAlertDialog(message: message)
                }
        }
    }
    
    private func chargeCardWithPaystack(investment: Investment, cardParams: PSTCKCardParams,_ viewcontroller: UIViewController) {
        
        let email = LoginSession.shared.dashboardInformation?.profile?.email ?? ""
        let transactionParams = PSTCKTransactionParams()
        transactionParams.reference = investment.Id!
        transactionParams.amount = UInt(investment.payment?.amount ?? 0) * 100
        transactionParams.email = email
        
        PSTCKAPIClient.shared().chargeCard(cardParams,
                                           forTransaction: transactionParams,
                                           on: viewcontroller, didEndWithError: { (error, reference) in
                                            
            // HANDLE ERROR
            self.view?.dismissLoading()
            AgroLogger.log(" PAYSTACK ERROR OCCURED WHILE TRYING TO CHARGE CARD \(error)")
            
            //            if error._code == PSTCKErrorCode.PSTCKCardError.rawValue {
            //                let message = "An error occurred while trying to debit your card. Please confirm you have sufficient available funds."
            //                self.view?.showAlertDialog(message: message)
            //            } else
            if error._code == PSTCKErrorCode.PSTCKExpiredAccessCodeError.rawValue {
                let message = "An error occurred while trying to process your payment. Please try again later"
                self.view?.showAlertDialog(message: message)
            } else if error._code == PSTCKErrorCode.PSTCKConflictError.rawValue {
                let message = "An error occurred while trying to process your payment. Please try again later"
                self.view?.showAlertDialog(message: message)
            } else {
                if let errorDict = (error._userInfo as! NSDictionary?){
                    if let errorString = errorDict.value(forKeyPath: "com.paystack.lib:ErrorMessageKey") as! String? {
                        AgroLogger.log("PAYSTACK ERROR OCCURED WHILE TRYING TO CHARGE CARD WITH DESCRIPTION \(errorString)")
                        if let reference=reference {
                            self.view?.showAlertDialog(title: "Error Occurred",
                                                       message: "An error occurred while trying to process your payment.\n \(errorString)")
                            self.verifyInvestmentPayment(reference: reference, investment: investment)
                        } else {
                            self.view?.showAlertDialog(title: "Error Occurred",
                                                       message: "An error occurred while trying to process your payment.\n \(errorString)")
                        }
                    }
                }
            }
                                            
        }, didRequestValidation: { (reference) in
            // an OTP was requested, transaction has not yet succeeded
            AgroLogger.log("PAYSTACK OTP was requested, transaction has not yet succeeded")
            
        }, willPresentDialog: {
            self.view?.dismissLoading()
        }, dismissedDialog: {
            self.view?.showLoading(withMessage: "Processing payment . . .")
        }, didTransactionSuccess: { (reference) in
            // transaction may have succeeded, please verify on backend
            AgroLogger.log("PAYSTACK transaction may have succeeded, please verify on backend")
            self.verifyInvestmentPayment(reference: reference, investment: investment)
        })
    }
    
    private func verifyInvestmentPayment(reference: String, investment: Investment) {
        
        apiService.verifyInvestmentTransaction(investmentReference: reference) { (response) in
            
            guard let response = response else {
                self.view?.dismissLoading()
                self.view?.showAlertDialog(message: StringLiterals.GENERIC_NETWORK_ERROR)
                return
            }
            
            if response.status == ApiConstants.Success {
                self.refreshDashboardInformation {
                    self.view?.dismissLoading()
                    self.view?.showInvestmentSuccessfulDialog(units: investment.units ?? 0,
                                                              amountPaid: investment.amount ?? 0,
                                                              authorization: response.data?.authorization)
                }
               
            } else {
                self.view?.dismissLoading()
                let message = "An error occurred while trying to process your payment. Please try again later"
                self.view?.showAlertDialog(message: message)
            }
        }
    }
    
    func addCard(authorization: Authorization) {
        
        self.view?.showLoading(withMessage: "Adding card . . .")
        apiService.addCard(cardRequest: authorization) { (card) in
            self.view?.dismissLoading()
            
            guard let card = card else {
                self.view?.showAlertDialog(message: StringLiterals.GENERIC_NETWORK_ERROR)
                return
            }
            
            if card.status == ApiConstants.Success {
                LoginSession.shared.cards.append(card)
                self.view?.showCardAddedDialog()
            } else {
                self.view?.showAlertDialog(title: "Error occured", message: card.message ?? "Couldn't save card details.")
            }
        }
    }
}
