import UIKit

class AgroActionButton: UIButton {
    
    private var cornerRadii: CGFloat = 10

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    
    private func setup() {
        
        self.hideToastActivity()
        self.clipsToBounds = true
        self.layer.cornerRadius = cornerRadii
        self.titleLabel?.font = UIFont.buttonText
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.primaryBlue {
        didSet{
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var fillColor: UIColor = UIColor.white {
        didSet{
            layer.backgroundColor = fillColor.cgColor
        }
    }
    
    @IBInspectable var titleColor: UIColor = UIColor.primaryBlue {
        didSet{
            self.setTitleColor(titleColor, for: .normal)
        }
    }
    
}
