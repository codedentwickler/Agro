//
//  PaystackViewController.swift
//  AgroPartnerships
//
//  Created by Kanyinsola Fapohunda on 08/09/2019.
//  Copyright © 2019 AgroPartnerships. All rights reserved.
//

import UIKit
import Paystack

class PaymentViewController: UIViewController, PSTCKPaymentCardTextFieldDelegate {
    
    var delegate: ProvideCardInformationDelegate?
    let paymentTextField = PSTCKPaymentCardTextField()
    
    override func viewDidLoad() {
        super.viewDidLoad();
        view.backgroundColor = UIColor.white
        
        let titleLabel = UILabel()
        titleLabel.text = "Enter your card details below"
        
        view.addSubview(titleLabel)
        view.addSubview(paymentTextField)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 14.0)
        
        paymentTextField.translatesAutoresizingMaskIntoConstraints = false
        paymentTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        paymentTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        paymentTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        paymentTextField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        paymentTextField.delegate = self
    }
    
    func paymentCardTextFieldDidChange(_ textField: PSTCKPaymentCardTextField) {
        AgroLogger.log("IS CARD VALID ?? \(textField.isValid)")
        if textField.isValid {
            delegate?.userProvidedValidCardInfo(cardParams: textField.cardParams)
            sheetViewController?.dismiss(animated: true)
        }
    }
}

protocol ProvideCardInformationDelegate {
    func userProvidedValidCardInfo(cardParams: PSTCKCardParams)
}
