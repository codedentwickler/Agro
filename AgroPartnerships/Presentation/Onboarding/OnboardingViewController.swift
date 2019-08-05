//
//  OnboardingStepTwo.swift
//  SaveFunds
//
//  Created by Kanyinsola on 19/09/2018.
//  Copyright © 2018 Crevance Savers. All rights reserved.
//

import UIKit
import SwiftyOnboard

class OnboardingViewController: UIViewController {
    
    @IBOutlet weak var swiftyOnboard: SwiftyOnboard!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        swiftyOnboard.dataSource = self
        swiftyOnboard.delegate = self
    }
    
    @objc func handleSkip() {
        swiftyOnboard?.goToPage(index: 2, animated: true)
    }
    
    @objc func handleContinue(sender: UIButton) {
        let index = sender.tag
        swiftyOnboard?.goToPage(index: index + 1, animated: true)
    }
}

extension OnboardingViewController: SwiftyOnboardDataSource {
    
    func swiftyOnboardNumberOfPages(_ swiftyOnboard: SwiftyOnboard) -> Int {
        return 3
    }
    
    func swiftyOnboardPageForIndex(_ swiftyOnboard: SwiftyOnboard, index: Int) -> SwiftyOnboardPage? {
        if index == 0 {
            return OnboardingStepOne.instanceFromNib() as? OnboardingStepOne
        } else if index == 1 {
            return OnboardingStepTwo.instanceFromNib() as? OnboardingStepTwo
        } else {
            return OnboardingStepThree.instanceFromNib() as? OnboardingStepThree
        }
    }
}

extension OnboardingViewController: SwiftyOnboardDelegate {
    
    func swiftyOnboardViewForOverlay(_ swiftyOnboard: SwiftyOnboard) -> SwiftyOnboardOverlay? {
        let overlay = OnboardingOverlay.instanceFromNib() as? OnboardingOverlay
        overlay?.skip.addTarget(self, action: #selector(handleSkip), for: .touchUpInside)
        overlay?.buttonContinue.addTarget(self, action: #selector(handleContinue), for: .touchUpInside)
        return overlay
    }
    
    func swiftyOnboardOverlayForPosition(_ swiftyOnboard: SwiftyOnboard, overlay: SwiftyOnboardOverlay, for position: Double) {
        let overlay = overlay as! OnboardingOverlay
        let currentPage = round(position)
        overlay.pageControl.currentPage = Int(currentPage)
        overlay.buttonContinue.tag = Int(position)
        if currentPage == 0.0 || currentPage == 1.0 {
            overlay.buttonContinue.isHidden = true
            overlay.skip.isHidden = false
            overlay.skip.setTitle("Skip", for: .normal)
        } else {
            overlay.skip.isHidden = true
        }
    }
}
