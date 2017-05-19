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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        registerForPushNotifications(application: application)
        AppSettings.loadTheme()
        Fabric.with([Crashlytics.self])
    
        // check if app was launched from notification
        if let notification = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] as? [String: AnyObject] {
            guard let
                aps = notification["aps"] as? [String: AnyObject],
                let title = aps["title"] as? String,
                let message = aps["message"] as? String,
                let url = aps["url"] as? String else {
                    
                    return true
            }
            print(aps)
            let initialViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BrowserControll") as! BrowserViewController
            initialViewController.remoteOpenURL(stringURL: aps["url"]?.stringValue)
            self.window = UIWindow(frame: UIScreen.main.bounds)
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
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
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func registerForPushNotifications(application: UIApplication) {
        let notificationSettings = UIUserNotificationSettings(types: [.badge,.sound,.alert], categories: nil)
        application.registerUserNotificationSettings(notificationSettings)
    }
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        print("Did register notificationSettings")
        //if UserDefaults.standard.bool(forKey: "areNotificationsOn") {
        if notificationSettings.types != [] && notificationSettings.types != .none {
            application.registerForRemoteNotifications()
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print("Device Token:", tokenString)
        AppSettings.deviceToken = tokenString
        Networking.faceIraqServerRegister()
        Networking.updateNotificationSettings()
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Push Notification register error: \(error)")
    }

    // executed when app is started by triggering notfication
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        let aps = userInfo as! [String: AnyObject]
        print(userInfo)
        print(aps)
    }

}

