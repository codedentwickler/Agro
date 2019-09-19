//
//  FundWalletPresenter.swift
//  AgroPartnerships
//
//  Created by Kanyinsola on 25/08/2019.
//  Copyright © 2019 AgroPartnerships. All rights reserved.
//

import Foundation
import Paystack
import SwiftyJSON

protocol FundWalletView: BaseView {    
    func walletFundingSuccessful(wallet: Wallet?, authorization: Authorization?)
    
    func showCardAddedDialog()
}

class FundWalletPresenter: BasePresenter {
    
    private let apiService: ApiService
    private weak var view: FundWalletView?
    
    required init(apiService: ApiService, view: FundWalletView) {
        self.apiService = apiService
        self.view = view
    }
    
    func detachView() {
        self.view = nil
    }
    
    func fundWalletSavedCard(amount: Double, authCode: String) {
        self.view?.showLoading(withMessage: "Processing payment . . .")

        apiService.fundWalletSavedCard(amount: amount, authCode: authCode) { (response) in
            self.view?.dismissLoading()
            guard let response = response else {
                self.view?.showAlertDialog(message: StringLiterals.GENERIC_NETWORK_ERROR)
                return
            }
            
            if response.status == "success" {
                LoginSession.shared.dashboardInformation?.profile?.wallet = response.wallet
                AgroLogger.log("DashboardInformation was set \(LoginSession.shared.dashboardInformation)")

                self.view?.walletFundingSuccessful(wallet: response.wallet, authorization: nil)
            } else {
                self.view?.showAlertDialog(message: "Card Charge failure. Please ensure you have enough funds to fund your wallet")
            }
        }
    }
    
    func chargeCardWithPaystack(amount: Int, cardParams: PSTCKCardParams,_ viewcontroller: UIViewController) {
        
        let user = LoginSession.shared.dashboardInformation?.profile
        
        let transactionParams = PSTCKTransactionParams()
        transactionParams.amount = UInt(amount) * 100
        transactionParams.email = user?.email ?? ""
        
        let params = [ "display_name":"Transaction Type",
                       "variable_name":"transaction_type",
                       "value":"fund-wallet"]
        
        try? transactionParams.setMetadataValueArray([params], forKey: "custom_fields")
        
        self.view?.showLoading(withMessage: "Processing payment . . .")
        
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
                            self.verifyWalletPayment(reference: reference)
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
            self.verifyWalletPayment(reference: reference)
        })
    }
    
    private func verifyWalletPayment(reference: String) {
        
        apiService.verifyWalletPayment(reference: reference) { (response) in
            self.view?.dismissLoading()
            
            guard let response = response else {
                self.view?.showAlertDialog(message: StringLiterals.GENERIC_NETWORK_ERROR)
                return
            }
            
            AgroLogger.log("AGRO LOGGER \(response)")
            if response.status == ApiConstants.Success {
                self.view?.walletFundingSuccessful(wallet: response.wallet, authorization: response.payment?.data?.authorization)
                LoginSession.shared.dashboardInformation?.profile?.wallet = response.wallet
            } else {
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
                self.view?.showDashboard()
                self.view?.showAlertDialog(message: StringLiterals.GENERIC_NETWORK_ERROR)
                return
            }
            
            if card.status == ApiConstants.Success {
                LoginSession.shared.cards.append(card)
                self.view?.showCardAddedDialog()
            } else {
                self.view?.showDashboard()
                self.view?.showAlertDialog(title: "Error occured", message: card.message ?? "Couldn't save card details. try again later")
            }
        }
    }
}
