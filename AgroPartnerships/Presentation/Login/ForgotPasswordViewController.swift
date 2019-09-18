//
//  ForgotPasswordViewController.swift
//  AgroPartnerships
//
//  Created by Kanyinsola Fapohunda on 10/09/2019.
//  Copyright © 2019 AgroPartnerships. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: BaseViewController {

    @IBOutlet weak var emailTextField: AgroTextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func userPressedForgotPassword(_ sender: Any) {
        
        let email = emailTextField.text!
        if email.isEmpty {
            self.showAlertDialog(title: "",
                                 message: "Please, enter the email you have registered.")
            return
        }
        
        forgotPassword(email: email)
    }
    
    private func forgotPassword(email: String) {
        
        showLoading()
        
        ApiServiceImplementation.shared.forgotPassword(email: email) { (json) in
            
            self.dismissLoading()
            
            guard let response = json else {
                self.showAlertDialog(message: StringLiterals.GENERIC_NETWORK_ERROR)
                return
            }
            if response[ApiConstants.Status].string == ApiConstants.Success {
               self.showAlertDialog(title: "Password Reset Email Sent",
                                    message: "An email has been sent. Please, check your email now.")
            } else {
                self.showAlertDialog(title: "Unidentified Email Address",
                                     message: "Please, enter the email you have registered with.")
            }
        }
    }
    
}
