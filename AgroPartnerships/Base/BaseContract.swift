import Foundation

protocol BaseView: NSObjectProtocol {
    
    func showLoading()
    
    func showLoading(withMessage text: String)
    
    func dismissLoading()
    
    func showToast(withMessage message: String)
    
    func showToast(withMessage message: String, showTimeInSeconds: Float)
    
    func showError(message text: String)

    func showError(title: String, message text: String)
    
    func isNetworkConnected()
}

protocol BasePresenter {}
