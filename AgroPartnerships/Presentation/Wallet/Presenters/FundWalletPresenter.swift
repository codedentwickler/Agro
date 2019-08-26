//
//  FundWalletPresenter.swift
//  AgroPartnerships
//
//  Created by Kanyinsola on 25/08/2019.
//  Copyright © 2019 AgroPartnerships. All rights reserved.
//

import Foundation

protocol FundWalletView: BaseView {
    func showFundYourWalletPage(cards: [CreditCard])
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
    
    func getAllCards() {
        
        self.view?.showLoading()
        apiService.getAllCards { (cardResponse) in
            self.view?.dismissLoading()
            
            guard let response = cardResponse else {
                self.view?.showError(message: StringLiterals.GENERIC_NETWORK_ERROR)
                return
            }
            
            self.view?.showFundYourWalletPage(cards: response.cards!)
        }
    }
}
