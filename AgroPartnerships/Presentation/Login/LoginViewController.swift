
import UIKit
import LocalAuthentication
import KeychainAccess

class LoginViewController: BaseViewController {

    @IBOutlet weak var emailTextField: AgroTextField!
    @IBOutlet weak var passwordTextField: AgroTextField!
    @IBOutlet weak var loginWithTouchIDLabel: UILabel!
    
    private var presenter: LoginPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       setupView()
    }
    
    private func setupView() {
        //         Only allowing in DEBUG mode
        #if DEBUG
        emailTextField.text = "ios@check-dc.com"
        passwordTextField.text = "eee123"
        #else
        let keychain = Keychain(service: "com.agropartnerships.AgroPartnerships")
        let email = keychain[PersistenceIDs.Email]
        emailTextField.text = email
        #endif
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        presenter  = LoginPresenter(apiService: ApiServiceImplementation.shared,
                                    view: self)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(userPressedTouchID))
        loginWithTouchIDLabel.isUserInteractionEnabled = true
        loginWithTouchIDLabel.addGestureRecognizer(tap)
        
        if LocalStorage.shared.getBoolean(key: PersistenceIDs.BiometricsEnabled) == true {
            promptUserForTouchIDAuth()
        }
    }
    
    @objc private func userPressedTouchID() {
        if LocalStorage.shared.getBoolean(key: PersistenceIDs.BiometricsEnabled) == true {
            promptUserForTouchIDAuth()
        } else {
            showAlertDialog(title: "Touch ID Not Activated",
                            message: "Please activate touch id via settings when you're logged in")
        }
    }
    
    @objc private func promptUserForTouchIDAuth() {
        
        let context = LAContext()
        var error: NSError?
        
        // check if Touch ID is available
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            
            let reason = "Authenticate with Touch ID"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                                   localizedReason: reason, reply: {(success, error) in
                    
                DispatchQueue.main.async {
                    if success {
                        context.invalidate()
                        self.retrieveFingerprintKeyAndLogin()
                    } else {
                        
                    }
                }
            })
        }
        else {
            DispatchQueue.main.async {
                self.showAlertDialog(title: "", message: "Touch ID not available")
            }
        }
    }
    
    private func retrieveFingerprintKeyAndLogin() {
        
        let keychain = Keychain(service: "com.agropartnerships.AgroPartnerships")
        let encodedKey = keychain[PersistenceIDs.BiometricsKey]
        let email = keychain[PersistenceIDs.Email]
        
        let decodedKey = encodedKey?.fromBase64() ?? encodedKey

        AgroLogger.log("LOGIN WITH \(decodedKey!)")
        presenter.loginWithFingerprint(email: email!, key: decodedKey!)
    }
    
    @IBAction func userPressedForgotPassword() {
        push(viewController: ForgotPasswordViewController.self)
    }

    @IBAction func signInWasPressed(_ sender: Any) {
        
        if !validate() {
            return
        }

        presenter.login(email: emailTextField.text!, password: passwordTextField.text!)
    }
    
    func validate() -> Bool {
        var faulted = false
        for inputTextField in [emailTextField!, passwordTextField!] {
            inputTextField.resignFirstResponder()
            if (inputTextField.text?.isEmpty)! {
                inputTextField.showError(message: StringLiterals.FIELD_IS_REQUIRED)
                faulted = true
            }
        }
        return !faulted
    }
}

extension LoginViewController: LoginView {
    
    func showDashBoard(dashboardInformation: DashboardResponse) {
        let vc = viewController(type: LandingViewController.self,
                                from: StoryBoardIdentifiers.Dashboard)
        vc.dashboardInformation = dashboardInformation
        self.present(vc, animated: true, completion: nil)
    }
}

public typealias Closure = () -> Void
