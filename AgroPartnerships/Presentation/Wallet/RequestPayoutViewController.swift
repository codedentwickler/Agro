//
//  RequestPayoutViewController.swift
//  AgroPartnerships
//
//  Created by Kanyinsola Fapohunda on 24/08/2019.
//  Copyright © 2019 AgroPartnerships. All rights reserved.
//

import UIKit

class RequestPayoutViewController: UIViewController {

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
        let profile = LoginSession.shared.getDashboardInformation()?.profile
        
        walletBalanceLabel.text = profile?.wallet?.funds?.commaSeparatedValue
        nameLabel.text = profile?.fullname
        bankNameLabel.text = profile?.bank?.accountName
        accountNumberLabel.text = profile?.bank?.accountNumber
    }

    @IBAction func userPressedPayout(_ sender: Any) {
        
    }
}
