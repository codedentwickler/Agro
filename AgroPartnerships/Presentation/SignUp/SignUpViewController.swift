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
        
        presenter  = SignUpPresenter(apiService: ApiServiceImplementation.shared,
                                    view: self)
        setup()
    }
    
    private func setup() {
        titleTextField.dropDownData = StringLiterals.SAMPLE
        dailingCodeTextField.dropDownData = StringLiterals.SAMPLE

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
    }
    
    @IBAction func userPressedTermsAndConditionsButton(_ sender: Any) {
        push(viewController: TermsAndConditionsViewController.self)
    }
    
    func validate() -> Bool {
        var faulted = false
        
        return !faulted
    }
}

extension SignUpViewController: SignUpView {
    func showDashBoard() {
        
    }
}
