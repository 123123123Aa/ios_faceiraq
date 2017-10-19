//
//  AppDelegate.swift
//  FaceIraq
//
//  Created by Aleksander Wędrychowski on 14/04/2017.
//  Copyright © 2017 Ready4S. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import UserNotifications
import Firebase
import FirebaseMessaging
import FirebaseInstanceID

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        
        AppSettings.shared.loadTheme()
        //Fabric.with([Crashlytics.self])
        
        
        
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in
                    UserDefaults.standard.set(true, forKey: "areNotificationsOn")
                    self.registerForPushNotifications(application: application)
            })
            // For iOS 10 data message (sent via FCM
            
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        }
        
        Messaging.messaging().delegate = self
        registerForPushNotifications(application: application)
        FirebaseApp.configure()
        connectToFCM()
        
        if let remoteNotification = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] as? NSDictionary
        {
            self.application(application, didReceiveRemoteNotification: remoteNotification as [NSObject : AnyObject])
            return true
        }
        
        // If in OpenPages is FaceIraq page then open this page insteed of creating new one.
        if let openedFaceIraqPage = AppSettings.shared.faceIraqAlreadyOpened(), AppSettings.shared.notificationPage == nil {
            let browserVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BrowserController") as! BrowserViewController
            let navController = UINavigationController(rootViewController: browserVC)
            browserVC.pageFromPagesController = openedFaceIraqPage
            browserVC.remoteOpenURL(stringURL: openedFaceIraqPage.url as String?)
            self.window = UIWindow(frame: UIScreen.main.bounds)
            self.window?.rootViewController = navController
            self.window?.makeKeyAndVisible()

            return true
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        application.applicationIconBadgeNumber = 0
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        application.registerForRemoteNotifications()
        print()
    }
    
    func registerForPushNotifications(application: UIApplication) {
        let notificationSettings = UIUserNotificationSettings(types: [.badge,.sound,.alert], categories: nil)
        application.registerUserNotificationSettings(notificationSettings)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        AppSettings.shared.deviceToken = tokenString
        InstanceID.instanceID().setAPNSToken(deviceToken, type: .sandbox)
        Networking.faceIraqServerRegister()
        Networking.updateNotificationSettings()
        connectToFCM()
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error)
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        guard let url = userInfo["url"] as? String else { return }
        AppSettings.shared.notificationPage = NotificationPage(stringURL: url)
        let state = UIApplication.shared.applicationState
        if state == .inactive || state == .active || state == .background {
            
            let browserVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BrowserController") as! BrowserViewController
            let navController = UINavigationController(rootViewController: browserVC)
            UIApplication.shared.keyWindow?.rootViewController = navController
            UIApplication.shared.keyWindow?.rootViewController?.loadView()
            
        }
    }
    
    func connectToFCM() {
        Messaging.messaging().connect { error in
            if error != nil {
                print("Unable to connect with FCM: \(error)")
            } else {
                print("Coneccted to FCM.")
            }
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate, MessagingDelegate {
    
    func application(received remoteMessage: MessagingRemoteMessage) {
        
        print(remoteMessage.appData)
        guard let url = remoteMessage.appData["url"] as? String else { return }
        
    }
 
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        //let tokenString = fcmToken.reduce("", {$0 + String(format: "%02X", $1)})
        //AppSettings.shared.deviceToken = fcmToken
        //InstanceID.instanceID().setAPNSToken(fcmToken.data(using: String.Encoding.ascii)!, type: .sandbox)
        //Messaging.messaging().apnsToken = fcmToken.data(using: String.Encoding.ascii)
        //Networking.faceIraqServerRegister()
        //Networking.updateNotificationSettings()
        //connectToFCM()
    }
    
    
    
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.badge, .alert, .sound])
    }
}
