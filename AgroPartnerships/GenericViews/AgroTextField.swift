
import SkyFloatingLabelTextField

class AgroUITextField : UITextField {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        textColor = UIColor.primaryBlue
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.primaryBlue {
        didSet{
            layer.borderColor = borderColor.cgColor
        }
    }
}

class AgroTextField : SkyFloatingLabelTextField {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        placeholderColor = UIColor.text
        textColor = UIColor.primaryBlue
        
        borderStyle = .none
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.primaryBlue {
        didSet{
            layer.borderColor = borderColor.cgColor
        }
    }
}
