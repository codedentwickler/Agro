
import SwiftyJSON

protocol SignUpView: BaseView {
    func showDashBoard()
    
    func showValidationError(validation: FormValidation)
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
    
    func signUp(fullname: String,
                title: String,
                email: String,
                phone: String,
                password: String,
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
                self.view?.showAlertDialog(message: StringLiterals.GENERIC_NETWORK_ERROR)
                return
            }
            
            if response[ApiConstants.Status].string == ApiConstants.Success {
                let token = response[ApiConstants.Token].string
                LocalStorage.shared.persistString(string: token, key: PersistenceIDs.AccessToken)
                self.view?.showAlertDialog(message: "Signup Successful")
            } else if response[ApiConstants.Status].string == ApiConstants.Error {
               
                let status = response[ApiConstants.Data][ApiConstants.ErrorType].string
                
                if status == ApiConstants.Validation {
                    self.handleValidationErrors(response)
                }
            }
        }
    }
    
    private func handleValidationErrors(_ response: JSON) {
        
        if let emailMessage = response[ApiConstants.Email].string {
            self.view?.showValidationError(validation: .email(message: emailMessage))
        }
        
        if let passwordMessage = response[ApiConstants.Password].string {
            self.view?.showValidationError(validation: .password(message: passwordMessage))
        }
        
        if let titleMessage = response[ApiConstants.Title].string {
            self.view?.showValidationError(validation: .title(message: titleMessage))
        }
    }
}

enum FormValidation {
    case email(message: String)
    case password(message: String)
    case title(message: String)
}
