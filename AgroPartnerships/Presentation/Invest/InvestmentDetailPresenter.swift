//
//  InvestmentDetailPresenter.swift
//  AgroPartnerships
//
//  Created by Kanyinsola Fapohunda on 30/08/2019.
//  Copyright © 2019 AgroPartnerships. All rights reserved.
//

import Paystack

protocol InvestmentDetailView: BaseView {
    func showInvestmentSuccessfulDialog(units: Int, amountPaid: Int)
}

class InvestmentDetailPresenter: BasePresenter {
    
    private let apiService: ApiService
    private weak var view: InvestmentDetailView?
    
    required init(apiService: ApiService, view: InvestmentDetailView) {
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
                if response.investment?.payment?.status == "paid" {
                    self.refreshDashboardInformation {
                        self.view?.dismissLoading()
                        self.view?.showInvestmentSuccessfulDialog(units: response.investment!.units ?? 0,
                                                                  amountPaid: response.investment!.amount ?? 0)
                    }
                } else {
                    self.view?.dismissLoading()
                    let message = response.message ?? "An error occurred while trying to process your payment. Please try again later"
                    self.view?.showAlertDialog(message: message)
                }
            } else {
                self.view?.dismissLoading()
                let message = "An error occurred while trying to process your payment. Please try again later"
                self.view?.showAlertDialog(message: message)
            }
        }
    }
}
