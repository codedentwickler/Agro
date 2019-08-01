//
//  OnboardingStepTwo.swift
//  SaveFunds
//
//  Created by Kanyinsola on 19/09/2018.
//  Copyright © 2018 Crevance Savers. All rights reserved.
//

import Foundation

class OnboardingStepOneViewController: UIViewController {}

class OnboardingStepTwoViewController: UIViewController {
    
    @IBAction func userPressedStart(_ sender: Any) {
        let vc = storyboard!.instantiateViewController(withIdentifier: "NavController") as! UINavigationController
        present(vc, animated: true, completion: nil)
    }
}
