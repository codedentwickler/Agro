//
//  ChangePasswordViewController.swift
//  AgroPartnerships
//
//  Created by Kanyinsola on 01/09/2019.
//  Copyright © 2019 AgroPartnerships. All rights reserved.
//

import UIKit
import SwiftyJSON

class ChangePasswordViewController: BaseViewController {

    @IBOutlet weak var currentPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextfield: UITextField!
    @IBOutlet weak var verifyNewPasswordTextfield: UITextField!
    @IBOutlet weak var currentPasswordVisibilityToggle: UIImageView!
    @IBOutlet weak var newPasswordVisibilityToggle: UIImageView!
    @IBOutlet weak var confirmNewPasswordVisibilityToggle: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupClickEventListeners()
    }
    
    private func setupClickEventListeners() {
        
        for view in [currentPasswordVisibilityToggle,
                          newPasswordVisibilityToggle, confirmNewPasswordVisibilityToggle] {
            let gesture = UITapGestureRecognizer(target: self, action: #selector(togglePasswordVisibility))
            view?.isUserInteractionEnabled = true
            view?.addGestureRecognizer(gesture)
        }
    }
    
    @objc private func togglePasswordVisibility(sender: UITapGestureRecognizer) {
        
        if sender.view == currentPasswordVisibilityToggle {
            toggleVisibility(textfield: currentPasswordTextField,
                             sender: currentPasswordVisibilityToggle)
        } else if sender.view == newPasswordVisibilityToggle {
            toggleVisibility(textfield: newPasswordTextfield,
                             sender: newPasswordVisibilityToggle)
        } else if sender.view == confirmNewPasswordVisibilityToggle {
            toggleVisibility(textfield: verifyNewPasswordTextfield,
                             sender: confirmNewPasswordVisibilityToggle)
        }
    }
    
    private func toggleVisibility(textfield: UITextField,
                                  sender: UIImageView) {
        
        if textfield.isSecureTextEntry {
            textfield.isSecureTextEntry = false
            sender.image = UIImage(named: "round_visibility_off")
        } else {
            textfield.isSecureTextEntry = true
            sender.image = UIImage(named: "round_visibility")
        }
    }
    
    @IBAction func userClickedChangePassword() {
        
        if !validate(textFields: currentPasswordTextField, newPasswordTextfield, verifyNewPasswordTextfield) {
            showAlertDialog(message: StringLiterals.ALL_FIELDS_REQUIRED)
            return
        }
        
        if newPasswordTextfield.text! != verifyNewPasswordTextfield.text! {
            showAlertDialog(message: "New password does not match the confirm password.")
            return
        }
        
        if currentPasswordTextField.text!.count < 6 || !currentPasswordTextField.text!.isAlphanumeric {
            showAlertDialog(message: "Current Password must be alphanumeric and not less than 6 characters")
            return
        }
        
        if newPasswordTextfield.text!.count < 6 || !newPasswordTextfield.text!.isAlphanumeric {
            showAlertDialog(message: "New Password must be alphanumeric and not less than 6 characters")
            return
        }
        
        showLoading(withMessage: "Changing your password . . .")
        let parameters = [ "password" : currentPasswordTextField.text ?? "",
                           "newPassword" : newPasswordTextfield.text ?? "",
                           "confirmPassword" : verifyNewPasswordTextfield.text ?? ""]
        
        Network.shared.request(ApiEndPoints.changePassword(),
                               method: .post, parameters: parameters ) { (response) in
            self.dismissLoading()
            if let response = response {
                if response[ApiConstants.Status].stringValue == ApiConstants.Success {
                    self.showSuccessDialogAndMoveToLogin(title: "Password Change Successful",
                                                         message: "Please log in with your new password")

                } else {
                    if response["password"].stringValue == "Authentication Failed" {
                        self.showAlertDialog(title: "Incorrect password", message: "Please enter your current password correctly.")
                    } else {
                        self.showAlertDialog(message: StringLiterals.GENERIC_NETWORK_ERROR)
                    }
                }
            }
        }
    }
    
    
    func showSuccessDialogAndMoveToLogin(title: String, message: String ) {
        
        let okAction: UIAlertAction = self.creatAlertAction(StringLiterals.OK, style: .default, clicked: {[unowned self] (action) in
            let vc = self.viewController(type: LoginLandingViewController.self,
                                    from: StoryBoardIdentifiers.Main)
           
            self.present(vc, animated: true, completion: nil)
            UIApplication.shared.keyWindow?.rootViewController = vc
        })
        
        self.createAlertDialog(title: title, message: message, ltrActions: [okAction])
        
    }
}
