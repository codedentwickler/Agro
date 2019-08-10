//
//  OnboardingStepThree.swift
//  AgroPartnerships
//
//  Created by Kanyinsola on 03/08/2019.
//  Copyright © 2019 AgroPartnerships. All rights reserved.
//

import UIKit
import SwiftyOnboard

class OnboardingStepThree: SwiftyOnboardPage {
    
    @IBOutlet weak var getStartedButton: AgroActionButton!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "OnboardingStepThree", bundle: nil)
            .instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
}
