
import Foundation

protocol SignUpView: BaseView {
    func showDashBoard()
}

class SignUpPresenter: BasePresenter {
    
    private let apiService: ApiService
    private weak var view: SignUpView?
    
    required init(apiService: ApiService, view: SignUpView) {
        self.apiService = apiService
        self.view = view
    }
    
    func detachView() {
        self.view = nil
    }
    
    @IBOutlet weak var fullnameTextField: AgroTextField!
    @IBOutlet weak var titleTextField: DropDownTextField!
    @IBOutlet weak var emailTextField: AgroTextField!
    @IBOutlet weak var passwordTextField: AgroTextField!
    @IBOutlet weak var phoneTextField: AgroTextField!
    @IBOutlet weak var dailingCodeTextField: DropDownTextField!
    @IBOutlet weak var referralCodeTextField: AgroTextField!
    @IBOutlet weak var dobTextField: DateDropDownTextField!
    
    
    func signUp(fullname: String,
                title: String,
                email: String,
                phone: String,
                password: String,
                dialingCode: String,
                dob: String,
                referralCode: String) {
        
        self.view?.showLoading(withMessage: StringLiterals.CREATING_NEW_CUSTOMER_ACCOUNT)

        apiService.signUp(title: title,
                          fullname: fullname,
                          email: email,
                          phone: phone,
                          password: password,
                          referral: referralCode,
                          dob: dob) { (responseJSON) in
                            
            self.view?.dismissLoading()
                
            guard let response = responseJSON else {
                self.view?.showError(message: StringLiterals.GENERIC_NETWORK_ERROR)
                return
            }
    
            AgroLogger.log("SIGN UP RESPONSE \(response)")
            let token = response[ApiConstants.Token].string
            let status = response[ApiConstants.Status].string
            LocalStorage.shared.persistString(string: token, key: PersistenceIDs.AccessToken)
        }
    }
}
