
import SwiftyJSON
import FirebaseMessaging

protocol SignUpView: BaseView {
    func showDashBoard(dashboardInformation: DashboardResponse)

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
                            
            guard let response = responseJSON else {
                self.view?.dismissLoading()
                self.view?.showAlertDialog(message: StringLiterals.GENERIC_NETWORK_ERROR)
                return
            }
            
            if response[ApiConstants.Status].string == ApiConstants.Success {
                LoginSession.shared.isUserInSession = true
                let token = response[ApiConstants.Token].string
                LocalStorage.shared.persistString(string: token, key: PersistenceIDs.AccessToken)
                self.loadCards()
                self.loadDashboardInformation()
                self.registerToken()
            } else if response[ApiConstants.Status].string == ApiConstants.Error {
                self.view?.dismissLoading()
                let status = response[ApiConstants.Data][ApiConstants.ErrorType].string
                
                if status == ApiConstants.Validation {
                    self.handleValidationErrors(response)
                } else {
                    self.view?.showAlertDialog(message: StringLiterals.GENERIC_NETWORK_ERROR)
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
        
        if let referralMessage = response[ApiConstants.Referral].string {
            self.view?.showValidationError(validation: .referral(message: referralMessage))
        }
        
        if let phoneMessage = response[ApiConstants.Phone].string {
            self.view?.showValidationError(validation: .phone(message: phoneMessage))
        }
        
        if let nameMessage = response[ApiConstants.FullName].string {
            self.view?.showValidationError(validation: .fullname(message: nameMessage))
        }
    }
    
    private func loadDashboardInformation() {
        
        apiService.getDashboardInformation { (dashboardResponse) in
            
            self.view?.dismissLoading()
            
            guard let response = dashboardResponse else {
                self.view?.showAlertDialog(message: StringLiterals.GENERIC_NETWORK_ERROR)
                return
            }
            
            guard response.isSuccessful() else {
                self.view?.showAlertDialog(message: StringLiterals.GENERIC_NETWORK_ERROR)
                return
            }
            self.view?.showDashBoard(dashboardInformation: response)
        }
    }
    
    private func loadCards() {
        ApiServiceImplementation.shared.getAllCards { (cardResponse) in
            guard let response = cardResponse else { return }
            
            if let cards = response.cards {
                LoginSession.shared.cards = cards
            }
        }
    }
    
    private func registerToken() {
        if let token =  Messaging.messaging().fcmToken {
            // token is current fcmToken
            AgroLogger.log("registerToken Firebase  token: \(token)")
            
            apiService.registerAppToken(token: token, completion: { response in
                
                AgroLogger.log("RegisterAppToken \(response)")
            })
        }
    }
}

enum FormValidation {
    case email(message: String)
    case password(message: String)
    case title(message: String)
    case referral(message: String)
    case phone(message: String)
    case fullname(message: String)
}
