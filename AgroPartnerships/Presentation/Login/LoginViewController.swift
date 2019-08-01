
import UIKit

class LoginViewController: BaseViewController {

    @IBOutlet weak var usernameTextField: AgroTextField!
    @IBOutlet weak var passwordTextField: AgroTextField!
    @IBOutlet weak var forgotPasswordLabel: UILabel!
    
    private var presenter: LoginPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(userPressedForgotPassword))
        forgotPasswordLabel.isUserInteractionEnabled = true
        forgotPasswordLabel.addGestureRecognizer(tap)
        
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
        presenter  = LoginPresenter(apiService: ApiServiceImplementation.shared,
                                    view: self)
    }
    
    @objc func userPressedForgotPassword() {
                showError(message: "Testing that this dialog shit works")

//        let vc = viewController(type: ResetPasswordViewController.self)
//        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func signInWasPressed(_ sender: Any) {
                
        // Only allowing in DEBUG mode
        #if DEBUG
        usernameTextField.text = "test@gmail.com"
        passwordTextField.text = "@Test123"
        #endif
//
        if !validate() {
            return
        }

        presenter.login(username: usernameTextField.text!, password: passwordTextField.text!)
    }
    
    @IBAction func signUpWasPressed(_ sender: Any) {
        let signUpVc = viewController(type: SignUpViewController.self,
                                      from: StoryBoardIdentifiers.MAIN)
        navigationController?.pushViewController(signUpVc, animated: true)
    }
    
    func validate() -> Bool {
        var faulted = false
        for inputTextField in [usernameTextField!, passwordTextField!] {
            inputTextField.resignFirstResponder()
            if (inputTextField.text?.isEmpty)! {
                inputTextField.errorColor = UIColor.red
                inputTextField.errorMessage = StringLiterals.FIELD_IS_REQUIRED
                faulted = true
            }
        }
        return !faulted
    }
}

extension LoginViewController: LoginView {
    
}

public typealias Closure = () -> Void
