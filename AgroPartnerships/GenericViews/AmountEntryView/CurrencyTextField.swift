import UIKit

@IBDesignable
class CurrencyTextField : UITextField {
    
    fileprivate let maxDigits = 12
    
    fileprivate var defaultValue: Double = 0.00
    
    fileprivate let currencyFormattor = NumberFormatter()
    
    fileprivate var previousValue : String = ""
    
    // MARK: - init functions
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        initTextField()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initTextField()
    }
    
    func initTextField(){
        AgroLogger.log("CurrencyTextField: INITIALIZING...")
        self.keyboardType = UIKeyboardType.decimalPad
        currencyFormattor.numberStyle = .currency
        currencyFormattor.minimumFractionDigits = 2
        currencyFormattor.maximumFractionDigits = 2
        setAmount(defaultValue)        
    }
    
    // MARK: - UITextField Notifications
    
    override open func willMove(toSuperview newSuperview: UIView!) {
        if newSuperview != nil {
            NotificationCenter.default.addObserver(self, selector: #selector(UITextInputDelegate.textDidChange(_:)), name: UITextField.textDidChangeNotification, object: self)
        } else {
            NotificationCenter.default.removeObserver(self)
        }
    }
    
    @objc func textDidChange(_ notification: Notification) {
        
        //Get the original position of the cursor
        let cursorOffset = getOriginalCursorPosition();
        
        let cleanNumericString : String = getCleanNumberString()
        let textFieldLength = self.text?.count
        
        if cleanNumericString.count > maxDigits {
            self.text = previousValue
        }
        else {
            let textFieldNumber = Double(cleanNumericString)
            if let textFieldNumber = textFieldNumber{
                let textFieldNewValue = textFieldNumber/100
                setAmount(textFieldNewValue)
            }else{
                self.text = previousValue
            }
        }
        //Set the cursor back to its original poistion
        setCursorOriginalPosition(cursorOffset, oldTextFieldLength: textFieldLength)
    }
    
    //MARK: - Custom text field functions
    
    func setAmount (_ amount : Double){
        if Int(amount) == Int(defaultValue) {
            textColor = UIColor(hex: "#C7C7CC")
        } else {
            textColor = UIColor.black
        }
        self.text = amount.asMoney()
    }
    
    func getAmount(asMinor: Bool = true) -> Double {
        guard let text = text, !text.matches(pattern: "[a-zA-Z|!@#$%^&*()?\":{}|<>\\-]") else {
            AgroLogger.log("Amount Not Valid")
            return 0
        }
        
        if asMinor {
            return Double(getCleanNumberString()) ?? 0
        }
        else{
            return Double(text.replacingOccurrences(of: ",", with: "")) ?? 0
        }
    }
    
    //MARK - helper functions
    fileprivate func getCleanNumberString() -> String {
        AgroLogger.log("CurrencyTextField: Received Request to get clean NUMBER String... Current text is: \(String(describing: self.text))")
        var cleanNumericString: String = ""
        let textFieldString = self.text
        if let textFieldString = textFieldString{
            
            //Remove $ sign
            AgroLogger.log("CurrencyTextField: Separating components by \("\u{20A6}")...")
            var toArray = textFieldString.components(separatedBy: "\u{20A6}")
            AgroLogger.log("CurrencyTextField: Separated components by \u{20A6}: RESULT TEXT: \(toArray) ")
            cleanNumericString = removeCurrencySymbol(textFieldString)
            AgroLogger.log("CurrencyTextField: CLEAN NUMERIC STRING BY REMOVING CURRENCY SYMBOL: \(cleanNumericString)")
            //Remove periods, commas
            
            AgroLogger.log("CurrencyTextField: REMOVING Periods AND COMMAS....")
            toArray = cleanNumericString.components(separatedBy: CharacterSet.punctuationCharacters)
            cleanNumericString = toArray.joined(separator: "")
            AgroLogger.log("CurrencyTextField: FINAL CLEANED STRING: \(cleanNumericString)")
        }
        
        return cleanNumericString
    }
    
    // MARK: Remove Currency Symbol
    func removeCurrencySymbol(_ str: String?) -> String {
        var cleanNumericString: String = ""
        let textFieldString = str
        if let textFieldString = textFieldString{
            //Remove $ sign
            let toArray = textFieldString.components(separatedBy: "\u{20A6}")
            cleanNumericString = toArray.joined(separator: "")
        }
        
        return cleanNumericString
    }
    
    
    fileprivate func getOriginalCursorPosition() -> Int{
        
        var cursorOffset : Int = 0
        let startPosition : UITextPosition = self.beginningOfDocument
        if let selectedTextRange = self.selectedTextRange{
            cursorOffset = self.offset(from: startPosition, to: selectedTextRange.start)
        }
        return cursorOffset
    }
    
    fileprivate func setCursorOriginalPosition(_ cursorOffset: Int, oldTextFieldLength : Int?){
        
        let newLength = self.text?.count
        let startPosition : UITextPosition = self.beginningOfDocument
        if let oldTextFieldLength = oldTextFieldLength, let newLength = newLength, oldTextFieldLength > cursorOffset{
            let newOffset = newLength - oldTextFieldLength + cursorOffset
            let newCursorPosition = self.position(from: startPosition, offset: newOffset)
            if let newCursorPosition = newCursorPosition{
                let newSelectedRange = self.textRange(from: newCursorPosition, to: newCursorPosition)
                self.selectedTextRange = newSelectedRange
            }
            
        }
    }
    
}
