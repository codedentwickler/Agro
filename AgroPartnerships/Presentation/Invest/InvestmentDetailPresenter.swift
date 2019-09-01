//
//  InvestmentDetailPresenter.swift
//  AgroPartnerships
//
//  Created by Kanyinsola Fapohunda on 30/08/2019.
//  Copyright © 2019 AgroPartnerships. All rights reserved.
//

import Foundation

protocol InvestmentDetailView: BaseView {
    func showTransactionSuccessfulDialog()
    
    func showPayForInvestmentPage(cards: [CreditCard])
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
        
        apiService.initializeInvestment(item: request.item!,
                                        units: request.units!,
                                        price: request.price!,
                                        paymentMethod: request.paymentMethod!,
                                        credit: request.credit,
                                        authCode: request.authCode) { (response) in
                                            
            self.view?.dismissLoading()
            guard let response = response else {
                self.view?.showAlertDialog(message: StringLiterals.GENERIC_NETWORK_ERROR)
                return
            }
            
            self.view?.showTransactionSuccessfulDialog()
        }
    }
    
    func getAllCards() {
        
        self.view?.showLoading()
        apiService.getAllCards { (cardResponse) in
            self.view?.dismissLoading()
            
            guard let response = cardResponse else {
                self.view?.showAlertDialog(message: StringLiterals.GENERIC_NETWORK_ERROR)
                return
            }
            
            self.view?.showPayForInvestmentPage(cards: response.cards!)
        }
    }
}
