//
//  InvestPresenter.swift
//  AgroPartnerships
//
//  Created by Kanyinsola Fapohunda on 26/08/2019.
//  Copyright © 2019 AgroPartnerships. All rights reserved.
//

import Foundation

protocol InvestView: BaseView {
    func showInvestmentsInformation(viewModel: InvestViewModel)
}

class InvestPresenter: BasePresenter {
    
    private let apiService: ApiService
    private weak var view: InvestView?
    
    required init(apiService: ApiService, view: InvestView) {
        self.apiService = apiService
        self.view = view
    }
    
    func detachView() {
        self.view = nil
    }
    
    func getInvestmentsInformation() {
        
        self.view?.showLoading(withMessage: "Loading Investment Information . . .")
        
        apiService.getAvailableCommodities(limitToNumber: 50) { (response) in
            self.view?.dismissLoading()
            guard let response = response else {
                self.view?.showAlertDialog(message: StringLiterals.GENERIC_NETWORK_ERROR)
                return
            }
            
            var soldInvestments = [Investment]()
            var availableInvestments = [Investment]()

            for investment in response.investments! {
                if investment.status == "sold out" {
                    soldInvestments.append(investment)
                } else if investment.status == "available" {
                    availableInvestments.append(investment)
                }
            }
            
            self.view?.showInvestmentsInformation(viewModel: InvestViewModel(soldInvestments: soldInvestments,
                                                                             availableInvestments: availableInvestments))
        }
    }
}

struct InvestViewModel {
    let soldInvestments: [Investment]
    let availableInvestments: [Investment]
}
