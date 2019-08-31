//
//  ProvideInvestmentDetailsModalViewController.swift
//  AgroPartnerships
//
//  Created by Kanyinsola on 28/08/2019.
//  Copyright © 2019 AgroPartnerships. All rights reserved.
//

import UIKit

class ProvideInvestmentDetailsModalStepOneViewController: UIViewController {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var totalCostAmountLabel: UILabel!
    @IBOutlet weak var expectedReturnsAmountLabel: UILabel!
    @IBOutlet weak var walletFundsAmountLabel: UILabel!
    @IBOutlet weak var quantityStepper: UIStepper!
    
    var investment: Investment!
    var delegate: ProvideInvestmentDetailsDelegate?

    var quantity: Int = 0 {
        didSet {
            quantityLabel.text = "Qty  \(quantity) \(quantity <= 1 ? "unit" : "units")"
            let totalCost = quantity * (investment.price ?? 0)
            let profit = totalCost * (investment.yield ?? 0) / 100
            totalCostAmountLabel.text = totalCost.commaSeparatedNairaValue
            expectedReturnsAmountLabel.text = (totalCost + profit).commaSeparatedNairaValue
        } 
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupView()
    }
    
    private func setupView() {
    
        productNameLabel.text = investment.title
        descriptionLabel.text = """
        \(investment.price!.commaSeparatedNairaValue)
        \(investment.yield!)% in \(investment.duration!) months
        """
        // MARK - TODO : ASK QUESTION ABOUT UNITS AND TOTAL UNITS
        quantityStepper.maximumValue = Double(investment.units ?? 0)
        
        let profile = LoginSession.shared.getDashboardInformation()?.profile
        let withdrawable = profile?.wallet?.funds ?? 0
        let nonWithdrawable = profile?.wallet?.bonus?.balance ?? 0
        let balance = withdrawable + nonWithdrawable
        
        walletFundsAmountLabel.text = balance.commaSeparatedNairaValue
    }
    
    @IBAction func userChangedStepperValue(_ sender: UIStepper) {
        quantity = sender.value.intValue
    }
    
    @IBAction func userPressedCancel(_ sender: Any) {
        sheetViewController?.dismiss(animated: true)
    }
    
    @IBAction func userPressedNext(_ sender: Any) {
        let vc = viewController(type: ProvideInvestmentDetailsModalStepTwoViewController.self,
                                from: StoryBoardIdentifiers.Invest)
        vc.investment = investment
        vc.totalUnitSelected = quantity
        vc.delegate = delegate
        navigationController?.pushViewController(vc, animated: true)
    }
}
