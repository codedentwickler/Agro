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
    
    func walletFundingSuccessful(wallet: Wallet?)
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
                self.view?.showAlertDialog(message: StringLiterals.GENERIC_NETWORK_ERROR)
                return
            }
            
            self.view?.showFundYourWalletPage(cards: response.cards!)
        }
    }
    
    func fundWalletSavedCard(amount: Double, authCode: String) {
        self.view?.showLoading(withMessage: "Adding funds to your wallet . . .")
        
        apiService.fundWalletSavedCard(amount: amount, authCode: authCode) { (response) in
            self.view?.dismissLoading()
            guard let response = response else {
                self.view?.showAlertDialog(message: StringLiterals.GENERIC_NETWORK_ERROR)
                return
            }
            
            if response.status == "success" {
                self.view?.walletFundingSuccessful(wallet: response.wallet)
            } else {
                self.view?.showAlertDialog(message: "Card Charge failure. Please ensure you have enough funds to fund your wallet")
            }
        }
    
    }
}
