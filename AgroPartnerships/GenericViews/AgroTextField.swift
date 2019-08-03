
import SkyFloatingLabelTextField

class AgroTextField : UITextField {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    private func setup() {
        textColor = UIColor.primaryBlue
        backgroundColor = UIColor.textFieldBackground
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.primaryBlue {
        didSet{
            layer.borderColor = borderColor.cgColor
        }
    }
}
