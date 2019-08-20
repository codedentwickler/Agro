import UIKit

class SignUpViewController: BaseViewController {
    
    @IBOutlet weak var fullnameTextField: AgroTextField!
    @IBOutlet weak var titleTextField: DropDownTextField!
    @IBOutlet weak var emailTextField: AgroTextField!
    @IBOutlet weak var passwordTextField: AgroTextField!
    @IBOutlet weak var phoneTextField: AgroTextField!
    @IBOutlet weak var dailingCodeTextField: DropDownTextField!
    @IBOutlet weak var referralCodeTextField: AgroTextField!
    @IBOutlet weak var dobTextField: DateDropDownTextField!
    
    private var presenter: SignUpPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //         Only allowing in DEBUG mode
        #if DEBUG
        fullnameTextField.text = "Kanyinsola Fapohunda"
        titleTextField.text = "Mr"
        emailTextField.text = "opeyemi@check-dc.com"
        passwordTextField.text = "password"
        dailingCodeTextField.text = "+234"
        phoneTextField.text = "8072914184"
        dobTextField.text = "1970-07-07"
        dobTextField.selectedDate = "1970-07-07"
        #endif
        
        presenter  = SignUpPresenter(apiService: ApiServiceImplementation.shared,
                                     view: self)
        setup()
    }
    
    private func setup() {
        setDelegateOfTextfields(views:fullnameTextField,titleTextField,emailTextField,
                                passwordTextField,dailingCodeTextField,phoneTextField,
                                dobTextField,referralCodeTextField)
        
        titleTextField.dropDownData = StringLiterals.Titles
        dailingCodeTextField.dropDownData = StringLiterals.DialingCodes
        
        titleTextField.selectionAction = { (index, string) in
            AgroLogger.log("Index\(index) and String \(string) was selected")
        }
        
        dailingCodeTextField.selectionAction = { (index, string) in
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
    
    @IBAction func createAccountWasPressed(_ sender: Any) {
        
        if !validate() {
            return
        }
        
        var phone = phoneTextField.text!
        
        if phone.starts(with: "0") {
            phone.removeFirst()
        }
        
        let fullPhone = "\(dailingCodeTextField.text!) \(phoneTextField.text!)"
        
        presenter.signUp(fullname: fullnameTextField.text!,
                         title: titleTextField.text!,
                         email: emailTextField.text!,
                         phone: fullPhone,
                         password: passwordTextField.text!,
                         dob: dobTextField.selectedDate!,
                         referralCode: referralCodeTextField.text!)
    }
    
    @IBAction func userPressedTermsAndConditionsButton(_ sender: Any) {
        push(viewController: TermsAndConditionsViewController.self)
    }
    
    func validate() -> Bool {
        var faulted = false
        
        for inputTextField in [fullnameTextField, titleTextField, emailTextField,
                               passwordTextField, phoneTextField, dailingCodeTextField,
                               dobTextField] {
            inputTextField?.resignFirstResponder()
            if inputTextField?.text?.isEmpty == true {
                inputTextField?.setError(StringLiterals.FIELD_IS_REQUIRED, show: true)
                faulted = true
            }
}
        
        return !faulted
    }
}

extension SignUpViewController: SignUpView {
    func showValidationError(validation: FormValidation) {
        
        switch validation {
        case .email(let message):
            emailTextField.setError(message, show: true)
        case .password(let message):
            passwordTextField.setError(message, show: true)
        case .title(let message):
            titleTextField.setError(message, show: true)
        default:
            break
        }
    }
    
    func showDashBoard() {
        let vc = viewController(type: LandingViewController.self,
                                from: StoryBoardIdentifiers.Dashboard)
        self.present(vc, animated: true, completion: nil)
    }
}
