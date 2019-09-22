import Foundation

protocol BaseView: NSObjectProtocol {
    
    func showLoading()
    
    func showLoading(withMessage text: String)
    
    func dismissLoading()
    
    func showToast(withMessage message: String)
    
    func showToast(withMessage message: String, showTimeInSeconds: Float)
    
    func showAlertDialog(message text: String)

    func showAlertDialog(title: String, message text: String)
    
    func isNetworkConnected()

    func showDashboard()
}

protocol BasePresenter {}

extension BasePresenter {
    
    func refreshDashboardInformation( completion: @escaping () -> Void) {
        
        ApiServiceImplementation.shared.getDashboardInformation { (dashboardResponse) in
            completion()
            guard dashboardResponse?.isSuccessful() == true else {
                return
            }
            
            LoginSession.shared.dashboardInformation = dashboardResponse
        }
    }
}
