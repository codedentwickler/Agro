import UIKit
import MBProgressHUD
import Toast_Swift

// Mark - Generic View Setup 
extension BaseViewController: BaseView {
    
    func showToast(withMessage message: String, showTimeInSeconds: Float) {
        self.view.makeToast(message, duration: TimeInterval(showTimeInSeconds), completion: nil)
    }
    
    func showToast(withMessage message: String) {
        self.view.makeToast(message, duration: 1.5, completion: nil)
    }
    
    func showLoading() {
        showProgressIndicator(withMessage: StringLiterals.PLEASE_WAIT)
    }
    
    func showLoading(withMessage text: String) {
        showProgressIndicator(withMessage: text)
    }
    
    func dismissLoading() {
        dismissProgressIndicator()
    }
    
    func showSuccessMsg(title: String = "", message text: String) {
        createAlertDialog(title: title, message: text)
    }
    
    func showAlertDialog(title: String, message text: String) {
        createAlertDialog(title: title, message: text)
    }
    
    func showAlertDialog(message text: String) {
        debugPrint("showError was called")
        createAlertDialog(message: text)
    }
    
    func isNetworkConnected() {}
    
    func showDashboard() {
        gotoDashboard()
    }
}

// Mark - Common View Actions

extension UIViewController {
    
    class var storyboardID : String {
        return "\(self)"
    }
    
    func performSegue(identifier: String) {
        OperationQueue.main.addOperation { [weak self] in
            self?.performSegue(withIdentifier: identifier, sender: self);
        }
    }
    
    func viewController<T: UIViewController>(type: T.Type,
                                             from storyBoardName: String = StoryBoardIdentifiers.Main) -> T {
        let storyboard = UIStoryboard (name: storyBoardName, bundle: nil)
        let storyBoardID = (type as UIViewController.Type).storyboardID
        
        return storyboard.instantiateViewController(withIdentifier: storyBoardID) as! T
    }
    
    func setNormalTitle(_ title: String!){
        let navBar = self.navigationController?.navigationBar
        navBar?.isTranslucent = false
        self.title = title;
    }
    
    func createAlertDialog(title: String! = "Oops!",
                           message: String! = StringLiterals.GENERIC_NETWORK_ERROR,
                           ltrActions: [UIAlertAction]! = []) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert);
        
        if(ltrActions.count == 0){
            let defaultAction = UIAlertAction(title: StringLiterals.OK,
                                              style: .default,
                                              handler: nil)
            alertController.addAction(defaultAction )
        }else{
            for x in ltrActions {
                alertController.addAction(x as UIAlertAction);
            }
        }
        
        self.present(alertController, animated: true, completion: nil);
    }
    
    func createActionSheet(title: String! = nil, message: String! = nil,
                           ltrActions: [UIAlertAction]! = [] ,
                           preferredActionPosition: Int = 0, sender: UIView? = nil ){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.actionSheet);
        
        alertController.view.tintColor = UIColor.appGreen1
        
        if(ltrActions.count == 0){
            let defaultAction = UIAlertAction(title: StringLiterals.OK, style: .default, handler: nil);
            alertController.addAction(defaultAction);
        } else {
            for (index , x) in ltrActions.enumerated() {
                alertController.addAction(x as UIAlertAction);
                if index == preferredActionPosition {
                    alertController.preferredAction = x as UIAlertAction
                }
            }
        }
        
        if let popoverController = alertController.popoverPresentationController, let sender = sender {
            popoverController.sourceView = sender
            popoverController.sourceRect = sender.bounds
        }
        
        self.present(alertController, animated: true, completion: nil);
    }
    
    func creatAlertAction(_ title: String = StringLiterals.OK,
                          style: UIAlertAction.Style = .default,
                          clicked: ((_ action: UIAlertAction) -> Void)?) -> UIAlertAction {
        return UIAlertAction(title: title, style: style, handler: clicked)
    }
}

// MARK - Progress Loading Indicator

extension UIViewController {
    
    func showProgressIndicator(withMessage message: String) {
        self.view.endEditing(true)
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.text = message
        hud.label.numberOfLines = 0
        hud.mode = MBProgressHUDMode.indeterminate
        hud.isUserInteractionEnabled = false
        showNetworkIndicator(status: true)
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    func dismissProgressIndicator() {
        MBProgressHUD.hide(for: self.view, animated: true)
        showNetworkIndicator(status: false)
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    func showNetworkIndicator(status: Bool = true) {
        OperationQueue.main.addOperation {
            [weak self] in
            _ = self.debugDescription
            UIApplication.shared.isNetworkActivityIndicatorVisible = status;
        }
    }
}

extension UIViewController {
    
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
