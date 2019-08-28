//
//  AppDelegate.swift
//  AgroPartnerships
//
//  Created by Kanyinsola on 21/07/2019.
//  Copyright © 2019 AgroPartnerships. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
        let navigationBarAppearance = UINavigationBar.appearance()
        navigationBarAppearance.tintColor = UIColor.appGreen1

        // Override point for customization after application launch.
        return true
    }

}
