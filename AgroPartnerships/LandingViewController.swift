//
//  ViewController.swift
//  AgroPartnerships
//
//  Created by Kanyinsola on 21/07/2019.
//  Copyright © 2019 AgroPartnerships. All rights reserved.
//

import UIKit

class LandingViewController : UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        for family in UIFont.familyNames.sorted() {
//            let names = UIFont.fontNames(forFamilyName: family)
//            AgroLogger.log("Family: \(family) Font names: \(names)")
//        }
    }

    @IBAction func userPressedLoginButton(_ sender: UIButton) {
        let vc = viewController(type: LoginViewController.self,
                                from: StoryBoardIdentifiers.MAIN)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func signUpWasPressed(_ sender: Any) {
        let signUpVc = viewController(type: SignUpViewController.self,
                                      from: StoryBoardIdentifiers.MAIN)
        navigationController?.pushViewController(signUpVc, animated: true)
    }
    
}
