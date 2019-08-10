
import SkyFloatingLabelTextField

class AgroTextField : UITextField {
    
    private var errorLabel: UILabel!
    
    private var hasError = false
    private var errorPadding = CGSize.zero

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
        setupErrorLabel()
    }
    
    private func setupErrorLabel() {
        errorLabel = UILabel()
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        errorLabel.textAlignment = .left
        errorLabel.numberOfLines = 0
        errorLabel.textColor = UIColor.desireRed
        addSubview(errorLabel)
        setupErrorConstraints()
    }
    
    func showError(message: String) {
        errorLabel.text = message
        errorLabel.isHidden = false
        borderColor = UIColor.desireRed
    }
    
    func hideErrorLabel() {
        errorLabel.isHidden = true
        borderColor = UIColor.lightGray
    }

    func setupErrorConstraints() {
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        errorLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        errorLabel.topAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }

    @IBInspectable var borderColor: UIColor = UIColor.primaryBlue {
        didSet{
            layer.borderColor = borderColor.cgColor
        }
    }
}
