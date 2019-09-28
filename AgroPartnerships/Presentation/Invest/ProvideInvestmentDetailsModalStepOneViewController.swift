//
//  ProvideInvestmentDetailsModalViewController.swift
//  AgroPartnerships
//
//  Created by Kanyinsola on 28/08/2019.
//  Copyright © 2019 AgroPartnerships. All rights reserved.
//

import Kingfisher
import UIKit

class ProvideInvestmentDetailsModalStepOneViewController: BaseViewController {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var totalCostAmountLabel: UILabel!
    @IBOutlet weak var expectedReturnsAmountLabel: UILabel!
    @IBOutlet weak var walletFundsAmountLabel: UILabel!
    @IBOutlet weak var quantityStepper: UIStepper!
    @IBOutlet weak var quantityInputView: UITextField!
    
    var investment: Investment!
    var delegate: ProvideInvestmentDetailsDelegate?

    var quantity: Int = 0 {
        didSet {
            quantityInputView.text = quantity.string
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
        loadImage()
    }
    
    private func loadImage() {
        let url = URL(string: investment.picture!)
        let processor = DownsamplingImageProcessor(size: iconImageView.frame.size) >> RoundCornerImageProcessor(cornerRadius: 10)

        iconImageView.kf.indicatorType = .activity
        iconImageView.kf.setImage(
            with: url,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
        ]){
            result in
            switch result {
            case .success(let value):
                self.iconImageView.backgroundColor = UIColor.clear
                print("Task done for: \(value.source.url?.absoluteString ?? "")")
            case .failure(let error):
                print("Job failed: \(error.localizedDescription)")
            }
        }
    }
    
    private func setupView() {
    
        productNameLabel.text = investment.title
        descriptionLabel.text = """
        \(investment.price!.commaSeparatedNairaValue)
        \(investment.yield!)% in \(investment.duration!) months
        """
        // MARK - TODO : ASK QUESTION ABOUT UNITS AND TOTAL UNITS
        quantityStepper.maximumValue = Double(investment.units ?? 0)
        
        let profile = LoginSession.shared.dashboardInformation?.profile
        let withdrawable = profile?.wallet?.funds ?? 0
        let nonWithdrawable = profile?.wallet?.bonus?.balance ?? 0
        let balance = withdrawable + nonWithdrawable
        
        walletFundsAmountLabel.text = balance.commaSeparatedNairaValue
    }
    @IBAction func userChangedQuantity(_ sender: UITextField) {
        if let quantity = quantityInputView.text?.intValue {
            let maximumUnits = investment.units ?? 0
            if quantity <= maximumUnits {
                self.quantity = quantity
            } else {
                validateUnitInput()
                self.quantity = maximumUnits
            }
        } else {
            showAlertDialog(message: "Invalid Entry for Input")
            quantityInputView.text = "0"
            quantity = 0
        }
        quantityStepper.value = self.quantity.doubleValue
    }
    
    private func validateUnitInput() {
        let maximumUnits = investment.units ?? 0
        if quantity > maximumUnits {
            showAlertDialog(message: "The maximum available unit you can purchase is \(maximumUnits)")
        }
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
