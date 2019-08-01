import UIKit

class SignUpViewController: BaseViewController {
    
    @IBOutlet weak var firstnameTextField: AgroTextField!
    @IBOutlet weak var lastnameTextField: AgroTextField!
    @IBOutlet weak var emailTextField: AgroTextField!
    @IBOutlet weak var passwordTextField: AgroTextField!
    @IBOutlet weak var phoneTextField: AgroTextField!
    @IBOutlet weak var termsAndConditionLabel: UILabel!
    
    private var presenter: SignUpPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        firstnameTextField.delegate = self
        lastnameTextField.delegate = self
        emailTextField.delegate = self
        phoneTextField.delegate = self
        passwordTextField.delegate = self
        
        presenter  = SignUpPresenter(apiService: ApiServiceImplementation.shared,
                                    view: self)
        termsAndConditionLabel.setHTMLFromString(htmlText: StringLiterals.TERMS_N_CONDITION_TEXT)
    }
    
    @IBAction func getStartedWasPressed(_ sender: Any) {
    
        if !validate() {
            return
        }
        
        let firstname = firstnameTextField.text!
        let lastname = lastnameTextField.text!
        let email = emailTextField.text!
        let password = passwordTextField.text!
        let phone = phoneTextField.text!
        
        presenter.signUp(firstname: firstname, lastname: lastname, email: email, phone: phone, password: password)
    }
    
    func validate() -> Bool {
        var faulted = false
        for inputTextField in [firstnameTextField!, lastnameTextField!, emailTextField!,passwordTextField!,phoneTextField!] {
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

extension SignUpViewController: SignUpView {
    func showDashBoard() {
        
    }
}
