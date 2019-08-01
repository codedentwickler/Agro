import SkyFloatingLabelTextField

extension UIViewController {
    
    func validateInputFields( views: SkyFloatingLabelTextField...) -> Bool {
        
        var faulted = false
        for inputTextField in views {
            inputTextField.resignFirstResponder()
            if (((inputTextField.text?.isEmpty)! && !inputTextField.isHidden) || inputTextField.text == StringLiterals.PLEASE_CHOOSE_ONE) {
                inputTextField.errorColor = UIColor.red
                inputTextField.errorMessage = StringLiterals.FIELD_IS_REQUIRED
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
}
