
import UIKit

class LoginViewController: BaseViewController {

    @IBOutlet weak var emailTextField: AgroTextField!
    @IBOutlet weak var passwordTextField: AgroTextField!
    
    private var presenter: LoginPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        presenter  = LoginPresenter(apiService: ApiServiceImplementation.shared,
                                    view: self)
    }
    
    @IBAction func userPressedForgotPassword() {
        push(viewController: TermsAndConditionsViewController.self)
    }

    @IBAction func signInWasPressed(_ sender: Any) {
                
        // Only allowing in DEBUG mode
        #if DEBUG
        emailTextField.text = "test@gmail.com"
        passwordTextField.text = "@Test123"
        #endif
//
//        if !validate() {
//            return
//        }

        presenter.login(username: emailTextField.text!, password: passwordTextField.text!)
    }
    
    func validate() -> Bool {
        var faulted = false
        for inputTextField in [emailTextField!, passwordTextField!] {
            inputTextField.resignFirstResponder()
            if (inputTextField.text?.isEmpty)! {
//                inputTextField.errorColor = UIColor.red
//                inputTextField.errorMessage = StringLiterals.FIELD_IS_REQUIRED
                faulted = true
            }
        }
        return !faulted
    }
}

extension LoginViewController: LoginView {
    
}

public typealias Closure = () -> Void
