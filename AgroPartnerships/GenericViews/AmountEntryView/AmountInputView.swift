import UIKit

class AmountInputView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var amountInputTextField: CurrencyTextField!
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var lineView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        loadViewFromNib()
    }
    
    func loadViewFromNib() {
        Bundle.main.loadNibNamed("AmountInputView", owner: self, options: nil)
        self.addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        amountInputTextField.delegate = self
    }
    
    func changeAmountSymbol(symbol: String) {
        symbolLabel.text = symbol
    }
}

extension AmountInputView: UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        lineView.backgroundColor = UIColor(hex: "6FCF97")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        lineView.backgroundColor = UIColor(hex: "BDBDBD")
    }
}
