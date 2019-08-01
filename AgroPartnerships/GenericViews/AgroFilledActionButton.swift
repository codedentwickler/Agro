
import UIKit

class AgroFilledActionButton: AgroActionButton {
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.backgroundColor = UIColor.primaryBlue
        self.setTitleColor(UIColor.white, for: .normal)
        self.setTitleColor(UIColor.black, for: .disabled)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
}
