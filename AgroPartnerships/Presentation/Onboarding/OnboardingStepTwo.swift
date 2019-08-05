//
//  OnboardingStepTwo.swift
//  AgroPartnerships
//
//  Created by Kanyinsola on 03/08/2019.
//  Copyright © 2019 AgroPartnerships. All rights reserved.
//

import UIKit
import SwiftyOnboard


class OnboardingStepTwo: SwiftyOnboardPage {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "OnboardingStepTwo", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
}
