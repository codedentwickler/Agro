
import UIKit

class LoginViewController: BaseViewController {

    @IBOutlet weak var emailTextField: AgroTextField!
    @IBOutlet weak var passwordTextField: AgroTextField!
    
    private var presenter: LoginPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //         Only allowing in DEBUG mode
        #if DEBUG
        emailTextField.text = "opeyemi@check-dc.com"
        passwordTextField.text = "eee123"
        #endif

        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        presenter  = LoginPresenter(apiService: ApiServiceImplementation.shared,
                                    view: self)
    }
    
    @IBAction func userPressedForgotPassword() {
        push(viewController: TermsAndConditionsViewController.self)
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
