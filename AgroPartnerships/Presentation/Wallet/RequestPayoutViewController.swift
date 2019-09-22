//
//  RequestPayoutViewController.swift
//  AgroPartnerships
//
//  Created by Kanyinsola Fapohunda on 24/08/2019.
//  Copyright © 2019 AgroPartnerships. All rights reserved.
//

import UIKit

class RequestPayoutViewController: BaseViewController {

    @IBOutlet weak var walletBalanceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var accountNumberLabel: UILabel!
    @IBOutlet weak var bankNameLabel: UILabel!
    @IBOutlet weak var amountView: AmountInputView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
    }
    
    private func setupView() {
        let profile = LoginSession.shared.dashboardInformation?.profile
        
        walletBalanceLabel.text = profile?.wallet?.funds?.commaSeparatedNairaValue
        nameLabel.text = profile?.bank?.accountName
        bankNameLabel.text = profile?.bank?.bankName
        accountNumberLabel.text = profile?.bank?.accountNumber
    }

    @IBAction func userPressedPayout(_ sender: Any) {
        let amount = amountView.amountInputTextField.getAmount(asMinor: false)
        AgroLogger.log("AMOUNT ENTERED \(amount)")
        
        if amount < 100 {
            showAlertDialog(title: "Amount to Small", message: "Minimum allowed amount is ₦100")
            return
        }
        
        self.showLoading(withMessage: "Requesting payout . . .")
        ApiServiceImplementation.shared.requestPayout(amount: amount) { (response) in
            self.dismissLoading()
            guard let response = response else {
                self.showAlertDialog(message: StringLiterals.GENERIC_NETWORK_ERROR)
                return
            }
            
            if response.status == "success" {
                LoginSession.shared.dashboardInformation?.profile?.wallet = response.wallet
                self.walletBalanceLabel.text = response.wallet?.funds?.commaSeparatedNairaValue
                self.showAlertDialog(title: "Payout Request Received",
                                     message: "Your payout request for \(amount.commaSeparatedNairaValue) is being processed. ")
            } else {
                self.showAlertDialog(message: response.message ?? StringLiterals.GENERIC_NETWORK_ERROR)
            }
        }
    }
}
