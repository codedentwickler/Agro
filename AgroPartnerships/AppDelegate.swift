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
import Firebase
import FirebaseMessaging
import FBSDKCoreKit
import FBSDKLoginKit

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // *************************************************************************************************
    // TODO : Step 0: Add Keychain Sharing entitlements to your app
    // *************************************************************************************************

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
        let navigationBarAppearance = UINavigationBar.appearance()
        
        navigationBarAppearance.tintColor = UIColor.appGreen1
        
        // Register Timeout notification observer
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(AppDelegate.applicationDidTimeout(notification:)),
            name: .appTimeout,
            object: nil
        )
        
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        FirebaseApp.configure()
        Paystack.setDefaultPublicKey(ApiConstants.PaystackPublicKey)

        LocalStorage.shared.loadCountryCodesJSON()
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()

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

public enum LogoutReason {
    case unauthorized
    case timeout
    case none
}
