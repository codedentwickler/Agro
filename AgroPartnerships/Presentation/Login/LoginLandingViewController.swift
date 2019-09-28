//
//  ViewController.swift
//  AgroPartnerships
//
//  Created by Kanyinsola on 21/07/2019.
//  Copyright © 2019 AgroPartnerships. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class LoginLandingViewController : BaseViewController {
    
    @IBOutlet weak var timeoutLogoutMessageLabel: UILabel!
    @IBOutlet weak var loginButton: FBLoginButton!
    
    var logoutReason = LogoutReason.none
    
    private var presenter: LoginPresenter!
    
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
        LocalStorage.shared.logout()
        if logoutReason == .timeout {
            timeoutLogoutMessageLabel.isHidden = false
        }
        
        presenter  = LoginPresenter(apiService: ApiServiceImplementation.shared,
                                           view: self)
        loginButton.permissions = ["public_profile", "email"]
        loginButton.delegate = self
    }

    @IBAction func userPressedLoginButton(_ sender: UIButton) {
        let vc = viewController(type: LoginViewController.self,
                                from: StoryBoardIdentifiers.Main)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func signUpWasPressed(_ sender: Any) {
        let signUpVc = viewController(type: SignUpViewController.self,
                                      from: StoryBoardIdentifiers.Main)
        navigationController?.pushViewController(signUpVc, animated: true)
    }
    
}

extension LoginLandingViewController : LoginButtonDelegate {
    
    func loginButtonWillLogin(_ loginButton: FBLoginButton) -> Bool {
        AgroLogger.log("FB  loginButtonWillLogin ")
        return true
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        AgroLogger.log("FB  loginButtonDidLogOut ")
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        // sign up with facebook
        if let token = result?.token?.tokenString {
            presenter.loginWithFacebook(accessToken: token)
        } else {
            AgroLogger.log("USER DIDNT COMPLETE FACEBOOK LOGIN")
        }
    }
    
}

extension LoginLandingViewController: LoginView {
    
    func showDashBoard(dashboardInformation: DashboardResponse) {
        let vc = viewController(type: LandingViewController.self,
                                from: StoryBoardIdentifiers.Dashboard)
        LoginSession.shared.dashboardInformation = dashboardInformation
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
}
