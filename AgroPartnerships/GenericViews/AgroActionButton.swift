import UIKit

class AgroActionButton: UIButton {
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.backgroundColor = UIColor.white
        self.translatesAutoresizingMaskIntoConstraints = true
        self.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.0)
        
        self.contentHorizontalAlignment = .center
        self.titleLabel?.font = UIFont.buttonText
        
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.primaryBlue.cgColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.primaryBlue {
        didSet{
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var titleColor: UIColor = UIColor.primaryBlue {
        didSet{
            self.setTitleColor(titleColor, for: .normal)
        }
    }
}
