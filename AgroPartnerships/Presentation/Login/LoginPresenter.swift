
import Foundation

protocol LoginView: BaseView {
}

class LoginPresenter: BasePresenter {
    
    private let apiService: ApiService
    private weak var view: LoginView?
    
    required init(apiService: ApiService, view: LoginView) {
        self.apiService = apiService
        self.view = view
    }
    
    func detachView() {
        self.view = nil
    }
    
    func login(username: String, password: String) {
        self.view?.showLoading(withMessage: StringLiterals.AUTHENTICATING_USER)
        
//        apiService.login(email: username, password: password) { (loginResponse) in
//            self.view?.dismissLoading()
//            guard let response = loginResponse else {
//                self.view?.showError(message: StringLiterals.GENERIC_NETWORK_ERROR)
//                return
//            }
//            
//            guard response.status else {
//                self.view?.showError(message: response.message)
//                return
//            }
//            
//            if let user = response.data {
//                let currentUser = CurrentUser(firstName: user.first_name,
//                                              lastName: user.last_name,
//                                              email: user.Email,
//                                              phone: user.Phone,
//                                              id: user.Id,
//                                              timeStamp: Date().timeIntervalSince1970,
//                                              token: response.token,
//                                              photoName: user.profile_photo,
//                                              address: user.Address,
//                                              gender: user.gender)
//                let jsonEncoder = JSONEncoder()
//                let encodedData = try! jsonEncoder.encode(currentUser)
//                
//                LocalStorage.shared.persistData(encodedData: encodedData, key: PersistenceIDs.CURRENT_USER_INFORMATION)
//                LocalStorage.shared.persistString(string: response.token, key: PersistenceIDs.ACCESS_TOKEN)
//                LocalStorage.shared.persistDouble(value: Date().timeIntervalSince1970, key: PersistenceIDs.LOGIN_TIME)
//                
//                self.loadPlans(id: currentUser.id)
//            } else {
//                self.view?.showError(message: StringLiterals.GENERIC_NETWORK_ERROR)
//            }
//        }
    }
}
