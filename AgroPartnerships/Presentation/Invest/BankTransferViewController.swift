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
    
    public var investment: Investment!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }

    private func setupView() {
        
        let invoice = investment.invoice
        
        reservedAccountNameLabel.text = invoice?.accountName
        reservedAccountNumberLabel.text = invoice?.accountNumber
        reservedAccountBankNameLabel.text = invoice?.bankName
        
        let units = investment.units
        let amountString = invoice?.amount?.commaSeparatedNairaValue ?? ""
        amountLabel.text = amountString
        unitsLabel.text = units?.string ?? ""
    }
    
    @IBAction func userChangedPager(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            showMonnifyView()
        } else {
            showCashView()
        }
    }
    
    private func showCashView() {
        monnifyView.isHidden = true
        cashView.isHidden = false
    }
    
    private func showMonnifyView() {
        cashView.isHidden = true
        monnifyView.isHidden = false
    }
}
