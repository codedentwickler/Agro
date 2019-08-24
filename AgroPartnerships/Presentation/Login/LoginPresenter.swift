
import Foundation

protocol LoginView: BaseView {
    func showDashBoard(dashboardInformation: DashboardResponse)
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
    
    func login(email: String, password: String) {
        self.view?.showLoading(withMessage: StringLiterals.AUTHENTICATING_USER)

        apiService.login(email: email , password: password) { (loginResponse) in
            AgroLogger.log("RESPONSE \(loginResponse)")

            guard let response = loginResponse else {
                self.view?.dismissLoading()
                self.view?.showError(message: StringLiterals.GENERIC_NETWORK_ERROR)
                return
            }
            
            guard response.isSuccessful() else {
                self.view?.dismissLoading()
                self.view?.showError(message: StringLiterals.GENERIC_NETWORK_ERROR)
                return
            }
            
            LocalStorage.shared.persistString(string: response.token, key: PersistenceIDs.AccessToken)
            self.loadDashboardInformation()
        }
    }
    
    func loadDashboardInformation() {
        
        apiService.getDashboardInformation { (dashboardResponse) in
            
            self.view?.dismissLoading()
        
            AgroLogger.log("RESPONSE \(dashboardResponse)")

            guard let response = dashboardResponse else {
                self.view?.showError(message: StringLiterals.GENERIC_NETWORK_ERROR)
                return
            }
            
            guard response.isSuccessful() else {
                self.view?.showError(message: StringLiterals.GENERIC_NETWORK_ERROR)
                return
            }
            
//            LocalStorage.shared.persistObject(object: response, key: PersistenceIDs.DashboardInformation)
            self.view?.showDashBoard(dashboardInformation: response)
        }
        
    }
}
