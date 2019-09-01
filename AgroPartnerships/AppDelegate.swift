//
//  AppDelegate.swift
//  AgroPartnerships
//
//  Created by Kanyinsola on 21/07/2019.
//  Copyright © 2019 AgroPartnerships. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Paystack

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
        let navigationBarAppearance = UINavigationBar.appearance()
        navigationBarAppearance.tintColor = UIColor.appGreen1
        
        Paystack.setDefaultPublicKey(ApiConstants.PaystackPublicKey)
        
        // Register Timeout notification observer
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(AppDelegate.applicationDidTimeout(notification:)),
            name: .appTimeout,
            object: nil
        )

        // Override point for customization after application launch.
        return true
    }
    
    // App Methods
    @objc func applicationDidTimeout(notification: Notification) {
        NSLog("Application Timed Out")
        AppDelegate.applicationDidLogout(with: .timeout)
    }
    
    class func applicationDidLogout(with reason: LogoutReason) {
        
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        
        //Avoid logging out when user is already logged out
        if !LoginSession.shared.isUserInSession && reason != .none {
            return
        }
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        var vc: LoginLandingViewController
        
        let navVC = storyBoard.instantiateViewController(withIdentifier: "LoginNavigationController") as! UINavigationController
        vc = navVC.viewControllers.first as! LoginLandingViewController
        vc.logoutReason = reason
        LoginSession.shared.logout()
        
        window.rootViewController = navVC
        window.makeKeyAndVisible()
    }
}

import Foundation

public enum LogoutReason {
    case unauthorized
    case timeout
    case none
}
