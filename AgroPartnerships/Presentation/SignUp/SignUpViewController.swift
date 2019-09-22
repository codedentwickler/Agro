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
    
    private var titles: [TitleKeyMap]!
    private var selectedDialingCode: TitleKeyMap?

    private var presenter: SignUpPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setup()

        //         Only allowing in DEBUG mode
        #if DEBUG
        fullnameTextField.text = "Kanyinsola Fapohunda"
        titleTextField.text = "Mr."
        emailTextField.text = "ios@check-dc.com"
        passwordTextField.text = "eee123"
        dailingCodeTextField.text = "+234"
        dailingCodeTextField.doSelection(index: 0)
        phoneTextField.text = "8072914184"
        dobTextField.text = "1970-07-07"
        dobTextField.selectedDate = "1970-07-07"
        #endif
        
        presenter  = SignUpPresenter(apiService: ApiServiceImplementation.shared,
                                     view: self)
    }
    
    private func setup() {
        setDelegateOfTextfields(views:fullnameTextField,titleTextField,emailTextField,
                                passwordTextField,dailingCodeTextField,phoneTextField,
                                dobTextField,referralCodeTextField)
        
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
        
        LocalStorage.shared.loadCountryCodesJSON { (jsonArray, error) in
            
            guard error == nil else { return }
            
            guard let countries = jsonArray else { return }
            
            self.titles = countries.map ({ (json) -> TitleKeyMap in
                
                let code = json["text"].stringValue
                let title = json["description"].stringValue
                
                return (code, title)
            })
            
            self.dailingCodeTextField.dropDownData = self.titles.map({ (titleKeyMap) -> String in
                return "\(titleKeyMap.0) - \(titleKeyMap.1)"
            })
            
            self.dailingCodeTextField.selectionAction = { (index, string) in
                AgroLogger.log("Index\(index) and String \(string) was selected")
                self.selectedDialingCode = self.titles[index]
            }
        }
    }
    
    @IBAction func createAccountWasPressed(_ sender: Any) {
        
        if !validate() {
            return
        }
        
        if selectedDialingCode == nil {
            showAlertDialog(title: "", message: "Please select a valid country code")
            return
        }
        
        var phone = phoneTextField.text!
        
        if phone.starts(with: "0") {
            phone.removeFirst()
        }
        
        let fullPhone = "\(selectedDialingCode!.0)\(phoneTextField.text!)"
        
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
    func showDashBoard(dashboardInformation: DashboardResponse) {
        let vc = viewController(type: LandingViewController.self,
                                from: StoryBoardIdentifiers.Dashboard)
        LoginSession.shared.dashboardInformation = dashboardInformation
        self.present(vc, animated: true, completion: nil)
    }
    
    func showValidationError(validation: FormValidation) {
        
        switch validation {
        case .email(let message):
            emailTextField.setError(message, show: true)
        case .password(let message):
            passwordTextField.setError(message, show: true)
        case .title(let message):
            titleTextField.setError(message, show: true)
        case .phone(let message):
            phoneTextField.setError(message, show: true)
        case .fullname(let message):
            fullnameTextField.setError(message, show: true)
        case .referral(let message):
            referralCodeTextField.setError(message, show: true)
        }
    }
    
    func showDashBoard() {
        let vc = viewController(type: LandingViewController.self,
                                from: StoryBoardIdentifiers.Dashboard)
        self.present(vc, animated: true, completion: nil)
    }
}
