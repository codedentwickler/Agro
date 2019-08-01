

import UIKit

class AgroAlert: UIView , Modal{
    
    var backgroundView = UIView()
    var dialogView = UIView()
    
    private var closure: Closure!

    convenience init(title:String, buttonTitle: String , image:UIImage, action: @escaping Closure) {
        self.init(frame: UIScreen.main.bounds)
        
        setupView(title, buttonTitle, image, action)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    func setupView(_ title: String,_ buttonTitle: String, _ image: UIImage,_ action: @escaping Closure) {
        backgroundView.frame = frame
        backgroundView.backgroundColor = UIColor.black
        backgroundView.alpha = 0.6
        addSubview(backgroundView)
        
        let rootView = Bundle.main.loadNibNamed("AgroAlertDialog", owner: self, options: nil)
        let dialogView = rootView?.first as! AgroAlertDialog
        
        dialogView.actionButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTappedOnActionButton)))

        dialogView.actionButton.setTitleColor(UIColor.clear, for: .disabled)
        closure = action
        dialogView.titleLabel.text = title
        dialogView.actionButton.titleLabel?.text = buttonTitle
        dialogView.imageView.image = image

        self.dialogView = dialogView
        addSubview(dialogView)
    }
    
    @objc func didTappedOnActionButton() {
        closure()
        dismiss(animated: true)
    }
}
