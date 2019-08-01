
import UIKit

extension AgroActionButton {
    
    func loadingIndicator(_ show: Bool) {
        let tag = 808404
        if show {
            self.isEnabled = false
            let indicator = UIActivityIndicatorView()
            let buttonHeight = self.bounds.size.height
            let buttonWidth = self.bounds.size.width
            indicator.center = CGPoint(x: buttonWidth/2, y: buttonHeight/2)
            indicator.tag = tag
            self.addSubview(indicator)
            indicator.startAnimating()
            self.titleLabel?.isHidden = true
            UIApplication.shared.beginIgnoringInteractionEvents()
        } else {
            self.isEnabled = true
            self.titleLabel?.isHidden = false
            UIApplication.shared.endIgnoringInteractionEvents()
            if let indicator = self.viewWithTag(tag) as? UIActivityIndicatorView {
                indicator.stopAnimating()
                indicator.removeFromSuperview()
            }
        }
    }
}
