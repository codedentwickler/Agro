//
//  AppDelegate+Notification.swift
//  AgroPartnerships
//
//  Created by Kanyinsola on 14/09/2019.
//  Copyright © 2019 AgroPartnerships. All rights reserved.
//

import Foundation
import Firebase
import UserNotifications
import FirebaseMessaging

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    //MARK: - UIApplicationDelegate Methods
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        ////         Print message ID.
        //            if let messageID = userInfo[gcmMessageIDKey] {
        //              Logger.log("Message ID: \(messageID)")
        //            }
        
        // Print full message.
        AgroLogger.log(userInfo)
        
        //    let code = String.getString(message: userInfo["code"])
        guard let aps = userInfo["aps"] as? Dictionary<String, Any> else { return }
        guard let alert = aps["alert"] as? String else { return }
        //    guard let body = alert["body"] as? String else { return }
        
        completionHandler([])
    }
    
    // Handle notification messages after display notification is tapped by the user.
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        AgroLogger.log(userInfo)
        completionHandler()
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        AgroLogger.log("Firebase registration token: \(fcmToken)")
        
        let dataDict:[String: String] = ["FCMToken": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        
        // Persist token
        LocalStorage.shared.persistString(string:fcmToken , key: PersistenceIDs.FCMToken)
        
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
    }
}
