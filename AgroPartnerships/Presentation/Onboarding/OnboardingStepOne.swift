//
//  OnboardingStepOne.swift
//  AgroPartnerships
//
//  Created by Kanyinsola on 03/08/2019.
//  Copyright © 2019 AgroPartnerships. All rights reserved.
//

import UIKit
import SwiftyOnboard

class OnboardingStepOne: SwiftyOnboardPage {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "OnboardingStepOne", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
}
