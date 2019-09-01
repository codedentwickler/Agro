import SkyFloatingLabelTextField

extension UIViewController {
    
    func validate( textFields: UITextField...) -> Bool {
        var faulted = false
        for textField in textFields {
            textField.resignFirstResponder()
            if (textField.text!.isEmpty) {
                faulted = true
            }
        }
        return !faulted
    }
    
    func validateInputFields( views: UITextField...) -> Bool {
        
        var faulted = false
        for inputTextField in views {
            inputTextField.resignFirstResponder()
            if (((inputTextField.text?.isEmpty)! && !inputTextField.isHidden) || inputTextField.text == StringLiterals.PLEASE_CHOOSE_ONE) {
                faulted = true
            }
        }
        return !faulted
    }
    
    func toggleVisibility(views: UIView..., shouldShow: Bool) {
        views.forEach { (view) in
            view.alpha = shouldShow ? 1.0 : 0.0
        }
    }
    
    func setDelegateOfTextfields(views: UITextField...) {
        views.forEach {
            $0.delegate = self as? UITextFieldDelegate
        }
    }
    
    var previousViewController:UIViewController?{
        if let controllersOnNavStack = self.navigationController?.viewControllers, controllersOnNavStack.count >= 2 {
            let n = controllersOnNavStack.count
            return controllersOnNavStack[n - 2]
        }
        return nil
    }
}
