
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
            
            guard let response = loginResponse else {
                self.view?.dismissLoading()
                self.view?.showAlertDialog(message: StringLiterals.GENERIC_NETWORK_ERROR)
                return
            }
            
            guard response.isSuccessful() else {
                self.view?.dismissLoading()
                self.view?.showAlertDialog(message: StringLiterals.GENERIC_NETWORK_ERROR)
                return
            }
            
            LoginSession.shared.isUserInSession = true
            LocalStorage.shared.persistString(string: response.token, key: PersistenceIDs.AccessToken)
            self.loadCards()
            self.loadDashboardInformation()
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
}
