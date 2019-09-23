//
//  BankTransferViewController.swift
//  AgroPartnerships
//
//  Created by Kanyinsola Fapohunda on 22/09/2019.
//  Copyright © 2019 AgroPartnerships. All rights reserved.
//

import UIKit

class BankTransferViewController: UIViewController {
    
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var unitsLabel: UILabel!
    @IBOutlet weak var pagerControl: UISegmentedControl!
    @IBOutlet weak var cashView: UIView!
    @IBOutlet weak var monnifyView: UIView!
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var reservedAccountNameLabel: UILabel!
    @IBOutlet weak var reservedAccountNumberLabel: UILabel!
    @IBOutlet weak var reservedAccountBankNameLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    private func setupView() {
        
    }
    
    @IBAction func userChangedPager(_ sender: Any) {
        
    }
    
    private func showCashView() {
        
    }
    
    private func showMonnifyView() {
        
    }
}
