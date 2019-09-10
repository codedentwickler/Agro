import UIKit
import Foundation

class BaseViewController: UIViewController {
    
    // MARK: Properties
        
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func userTapCloseIcon() {
        self.tabBarController?.dismiss(animated: true, completion: nil)
    }
}

extension BaseViewController: UITextFieldDelegate {
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func resignIfFirstResponder(_ textField: UITextField) {
        if textField.isFirstResponder {
            textField.resignFirstResponder()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        (textField as? AgroTextField)?.setError()
        return true
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false;
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
}

// Common Functionalities Used in various View Controllers
extension BaseViewController {
    
    func gotoDashboard() {
        self.tabBarController?.dismiss(animated: true, completion: nil)
    }
    
    func shareOnlyText(_ text: String) {
        let textShare = [text]
        let activityViewController = UIActivityViewController(activityItems: textShare , applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [.saveToCameraRoll]
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func setBackButtonTitleToBack() {
        navigationItem.title = nil
        navigationItem.title = StringLiterals.BACK
    }

    func push<T: UIViewController>(viewController: T.Type,
                                   from storyBoardName: String = StoryBoardIdentifiers.Main) {
        let vc = self.viewController(type: viewController,
                                     from: storyBoardName)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func getSubviewsOf<T: UIView>(view: UIView) -> [T] {
        var subviews = [T]()
        
        for subview in view.subviews {
            subviews += getSubviewsOf(view: subview) as [T]
            
            if let subview = subview as? T {
                subviews.append(subview)
            }
        }
        
        return subviews
    }
    
    func popBackStack(numberOfViewControllersToPop count: Int = 2) {
        if let viewControllers = self.navigationController?.viewControllers as [UIViewController]? {
            self.navigationController?.popToViewController(viewControllers[viewControllers.count - count - 1], animated: true)
        }
    }
}

public typealias TitleKeyMap = (String , String)
