
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
    
    func signUp(firstname: String,
                lastname: String,
                email: String,
                phone: String,
                password: String) {
        
//        self.view?.showLoading(withMessage: StringLiterals.CREATING_NEW_CUSTOMER_ACCOUNT)
//        ApiServiceImplementation.shared.createAccount(firstname: firstname,
//                                        lastname: lastname,
//                                        email: email,
//                                        phone: phone,
//                                        password: password,
//                                        completion: { (signUpResponse) in
//                self.view?.dismissLoading()
//                
//                guard let response = signUpResponse else {
//                    self.view?.showError(message: StringLiterals.GENERIC_NETWORK_ERROR)
//                    return
//                }
//                
//                guard response.status else {
//                    self.view?.showError(message: response.message)
//                    return
//                }
//                
//                if let user = response.data {
//                    let currentUser = CurrentUser(firstName: user.first_name,
//                                                  lastName: user.last_name,
//                                                  email: user.Email,
//                                                  phone: user.Phone,
//                                                  id: user.Id,
//                                                  timeStamp: Date().timeIntervalSince1970,
//                                                  token: response.token,
//                                                  photoName: nil,
//                                                  address: nil,
//                                                  gender: nil)
//                    let jsonEncoder = JSONEncoder()
//                    let encodedData = try! jsonEncoder.encode(currentUser)
//                    
//                    LocalStorage.shared.persistData(encodedData: encodedData, key: PersistenceIDs.CURRENT_USER_INFORMATION)
//                    LocalStorage.shared.persistString(string: response.token, key: PersistenceIDs.ACCESS_TOKEN)
//                    LocalStorage.shared.persistDouble(value: Date().timeIntervalSince1970, key: PersistenceIDs.LOGIN_TIME)
//                    
//                    self.view?.showDashBoard()
//                } else {
//                    self.view?.showError(message: StringLiterals.GENERIC_NETWORK_ERROR)
//                }
//        })
    }
}
