//
//  ProfileViewController.swift
//  AgroPartnerships
//
//  Created by Kanyinsola on 01/09/2019.
//  Copyright © 2019 AgroPartnerships. All rights reserved.
//

import UIKit
import LocalAuthentication
import KeychainAccess

class ProfileViewController: BaseViewController {

    @IBOutlet weak var closeIconImageView: UIImageView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var fullnameTextField: AgroTextField!
    @IBOutlet weak var titleTextField: DropDownTextField!
    @IBOutlet weak var emailTextField: AgroTextField!
    @IBOutlet weak var phoneTextField: AgroTextField!
    @IBOutlet weak var dobTextField: DateDropDownTextField!
    @IBOutlet weak var bankAccountNameTextField: AgroTextField!
    @IBOutlet weak var bankAccountNumberTextField: AgroTextField!
    @IBOutlet weak var bankNameTextField: AgroTextField!
    @IBOutlet var changePasswordGroup: [UIView]!
    @IBOutlet var manageSavedCardsGroup: [UIView]!
    @IBOutlet weak var noOfCardsLabel: UILabel!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var settingsView: UIView!
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    @IBOutlet var enableTouchIDGroup: [UIView]!
    @IBOutlet weak var enableTouchIdSwitch: UISwitch!
    
    private var shouldShowSettings: Bool = false
    
    private var cards : [CreditCard] = [CreditCard]() {
        didSet {
            let count = cards.count
            let text = count <= 1 ? "Card" : "Cards"
            noOfCardsLabel.text = "\(count) \(text)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shouldShowSettings = (tabBarController as! DashboardTabBarController).showSettings
        
        setupView()
        setupEventListeners()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if LoginSession.shared.cards.isEmpty {
            loadCards()
        } else {
            cards = LoginSession.shared.cards
        }
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    private func setupView() {
   
        if shouldShowSettings {
            segmentedControl.selectedSegmentIndex = 1
            userChangedControls(segmentedControl)
        }
        
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.appGreen1], for: .selected)
        
        let profile = LoginSession.shared.dashboardInformation?.profile
        // Set existing values.
        titleTextField.text = profile?.title
        fullnameTextField.text = profile?.fullname
        emailTextField.text = profile?.email
        emailTextField.isEnabled = false
        emailTextField.textColor = UIColor.lightGray
        phoneTextField.text = profile?.phone
        dobTextField.text = profile?.dob?.dobFromDateString?.asDayFullMonthString ?? ""
        dobTextField.selectedDate = profile?.dob
        bankAccountNameTextField.text = profile?.bank?.accountName
        bankAccountNumberTextField.text = profile?.bank?.accountNumber
        bankNameTextField.text = profile?.bank?.bankName
    }
    
    private func setupEventListeners() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(userTapCloseIcon))
        closeIconImageView.isUserInteractionEnabled = true
        closeIconImageView.addGestureRecognizer(tap)
    
        for view in changePasswordGroup {
            let tap1 = UITapGestureRecognizer(target: self,
                                              action: #selector(userPressedChangePassword))
            view.isUserInteractionEnabled = true
            view.addGestureRecognizer(tap1)
        }
        
        for view in manageSavedCardsGroup {
            let tap1 = UITapGestureRecognizer(target: self,
                                              action: #selector(userPressedManageCards))
            view.isUserInteractionEnabled = true
            view.addGestureRecognizer(tap1)
        }
    }
    
    @IBAction func userChangedTouchIDToggle(_ sender: UISwitch) {
        if sender.isOn {
            setupTouchID()
        } else {
            showRemoveTouchIDLoginDialog()
        }
    }
    
    private func showRemoveTouchIDLoginDialog() {
        
        createAlertDialog(title: "Remove Touch ID Login",
                          message: "Are you sure you want to disable touch id login? You will not be able to login with touch id",
                          ltrActions: [
                            
                creatAlertAction("Cancel", style: .cancel, clicked: { _ in
                    self.enableTouchIdSwitch.isOn = true
                }),
                creatAlertAction("Disable Touch ID", style: .destructive, clicked: { _ in
                    self.removeTouchIDLogin()
                })
            ])
    }
    
    private func removeTouchIDLogin() {
        
        showLoading(withMessage: "Removing touch id . . .")
        
        ApiServiceImplementation.shared.deleteFingerprint(completion: { (responseJSON) in
            self.dismissLoading()

            guard let response = responseJSON else {
                self.showAlertDialog(message: StringLiterals.GENERIC_NETWORK_ERROR)
                return
            }
            
            if response[ApiConstants.Status].string == ApiConstants.Success {
                LocalStorage.shared.persistBool(value: false , key: PersistenceIDs.BiometricsEnabled)
                let keychain = Keychain(service: "com.agropartnerships.AgroPartnerships")
                
                try? keychain.remove(PersistenceIDs.BiometricsKey)
                try? keychain.remove(PersistenceIDs.Email)
            } else {
                self.showAlertDialog(title: "", message: response["message"].string ??
                    "An error occurred while setting up touch id auth. please try again later")
            }
        })
    }
    
    @objc private func setupTouchID() {
        
        let context = LAContext()
        var error: NSError?
        
        // check if Touch ID is available
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            
            let reason = "Authenticate with Touch ID"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason, reply:
                {(success, error) in
                    
                    DispatchQueue.main.async {
                        if success {
                            context.invalidate()
                            self.generateFingerprintKeyAndSavedInKeychain()
                        } else {
                            self.enableTouchIdSwitch.isOn = false
                            self.createAlertDialog(title: "", message: "Touch ID Authentication Failed")
                        }
                    }
            })
        }
        else {
            DispatchQueue.main.async {
                self.enableTouchIdSwitch.isOn = false
                self.createAlertDialog(title: "", message: "Touch ID not available")
            }
        }
    }
    
    private func generateFingerprintKeyAndSavedInKeychain() {
        
        let key = String.random(length: 256)
        enableTouchID(key: key)
    }
    
    private func enableTouchID(key: String) {
        
        showLoading(withMessage: "Setting up Touch ID Auth . . .")
        // Send email and key to server
        ApiServiceImplementation.shared.saveFingerprint(key: key) { (responseJSON) in
            self.dismissLoading()
            AgroLogger.log("enableTouchID WITH \(key)")

            guard let response = responseJSON else {
                self.enableTouchIdSwitch.isOn = false
                self.showAlertDialog(message: StringLiterals.GENERIC_NETWORK_ERROR)
                return
            }
            
            if response[ApiConstants.Status].string == ApiConstants.Success {
                LocalStorage.shared.persistBool(value: true , key: PersistenceIDs.BiometricsEnabled)
                let keychain = Keychain(service: "com.agropartnerships.AgroPartnerships")
                let email = LoginSession.shared.dashboardInformation?.profile?.email
                let encoded = key.toBase64() ?? key
                
                keychain[PersistenceIDs.BiometricsKey] = encoded
                keychain[PersistenceIDs.Email] = email
            } else {
                self.enableTouchIdSwitch.isOn = false
                self.showAlertDialog(title: "", message: response["message"].string ?? "An error occurred while setting up touch id auth. please try again later")
            }
        }
    }
    
    @objc private func userPressedChangePassword() {
        push(viewController: ChangePasswordViewController.self,
             from: StoryBoardIdentifiers.Dashboard)
    }
    
    @objc private func userPressedManageCards() {
        let vc = viewController(type: ManageSavedCardsViewController.self,
                                from: StoryBoardIdentifiers.Wallet)
        vc.cards = cards
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func setup() {
        
        titleTextField.dropDownData = StringLiterals.Titles
        titleTextField.selectionAction = { (index, string) in
            AgroLogger.log("Index\(index) and String \(string) was selected")
        }
        
        let minimumDate =  Calendar.current.date(byAdding: .year,
                                                 value: -100,
                                                 to: Date())
        
        let maximumDate =  Calendar.current.date(byAdding: .year,
                                                 value: -16,
                                                 to: Date())
        
        dobTextField.setupDatePicker(withMinimumDate: minimumDate ?? Date(),
                                     withMaximumDate: maximumDate ?? Date(),
                                     withDefaultDate: maximumDate ?? Date() )
    }
    
    @IBAction func userPressedUpdateBankInformation() {
        
        if !validate(textFields: bankNameTextField, bankAccountNumberTextField, bankAccountNameTextField) {
            showAlertDialog(message: "Please complete the required bank information section to update your bank information.")
            return
        }
        
        let bankName = bankNameTextField.text ?? ""
        let bankAccountNumber = bankAccountNumberTextField.text ?? ""
        let bankAccountName = bankAccountNameTextField.text ?? ""
        
        let parameters = [ "accountName": bankAccountName,
                           "accountNumber": bankAccountNumber,
                           "bankName": bankName]
        
        showLoading(withMessage: "Updating Bank Information . . .")
        
        Network.shared.request(ApiEndPoints.updateUserBank(),
                               method: .post, parameters: parameters ) {[unowned self]  (response) in
            self.dismissLoading()
            if let response = response {
                if response[ApiConstants.Status].stringValue == ApiConstants.Success {
                    self.showSuccessAlert(title: "Account Update Received",
                                          message: "You bank details are being reviewed.")
                } else {
                    self.showAlertDialog(message: "An Error occured. Please check your bank details and try again.")
                }
            } else {
                self.showAlertDialog(message: StringLiterals.GENERIC_NETWORK_ERROR)
            }
        }
    }
    
    @IBAction func userChangedControls(_ sender: UISegmentedControl) {
        if (sender.selectedSegmentIndex == 0) {
            showProfile()
        } else {
            showSettings()
        }
    }
    
    private func showProfile(){
        profileView.isHidden = false
        settingsView.isHidden = true
        contentViewHeight.constant = CGFloat(1700.0)
    }
    
    private func showSettings(){
        if LocalStorage.shared.getBoolean(key: PersistenceIDs.BiometricsEnabled) == true {
            enableTouchIdSwitch.isOn = true
        }
        
        profileView.isHidden = true
        settingsView.isHidden = false
        contentViewHeight.constant = CGFloat(500.0)
    }
    
    @IBAction func userPressedSaveBasicInformation() {
        // Validate input.
        let title = titleTextField.text ?? ""
        let fullname = fullnameTextField.text ?? ""
        let phone = phoneTextField.text ?? ""
        let dob = dobTextField.selectedDate ?? ""
        
        let parameters = [ "dob": dob,
                           "fullname": fullname,
                           "phone": phone,
                           "title": title]
        
        showLoading(withMessage: "Updating your profile . . .")
        
        Network.shared.request(ApiEndPoints.updateProfile(),
                               method: .post, parameters: parameters ) {[unowned self]  (response) in
            self.dismissLoading()
            if let response = response {
                if response[ApiConstants.Status].stringValue == ApiConstants.Success {
                    self.showSuccessAlert(title: "Update Successful",
                                          message: "You profile has been updated.")
                    self.refreshDashboardInformation()
                } else {
                    self.showAlertDialog(message: "An Error occured. Please check your profile information and try again.")
                }
            } else {
                self.showAlertDialog(message: StringLiterals.GENERIC_NETWORK_ERROR)
            }
        }
    }
    
    @IBAction func userPressedLogout() {
        AppDelegate.applicationDidLogout(with: .none)
        LoginSession.shared.logout()
    }

    private func showSuccessAlert(title: String, message: String) {
        let okAction: UIAlertAction = self.creatAlertAction(StringLiterals.DONE, style: .default, clicked: {[unowned self] (action) in
            self.navigationController?.popViewController(animated: true)
        })
        
        self.createAlertDialog(title: title, message: message, ltrActions: [okAction])
    }
    
    private func loadCards() {
        ApiServiceImplementation.shared.getAllCards { (cardResponse) in
            guard let response = cardResponse else { return }
            
            if let cards = response.cards {
                LoginSession.shared.cards = cards
                self.cards = cards
            }
        }
    }
}
