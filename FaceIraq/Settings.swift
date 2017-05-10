//
//  ThemeColors.swift
//  FaceIraq
//
//  Created by Aleksander Wędrychowski on 20/04/2017.
//  Copyright © 2017 Ready4S. All rights reserved.
//

import UIKit

struct AppSettings {
    
    static var currentThemeColor = UIColor.AppColors.appBeige
    static var currentTintColor: UIColor {
        if currentThemeColor == UIColor.AppColors.appBeige {
            return UIColor.black
        } else {
            return UIColor.white
        }
    }
    
    static func loadTheme() {
        print("loadTheme")
        if let color = UserDefaults.standard.color(forKey: "themeColor") {
            AppSettings.currentThemeColor = color
        }
        print("loading theme color")
    }
    
    static func setThemeColor(to color: UIColor) {
        print("setThemeColor")
        UserDefaults.standard.set(color, forKey: "themeColor")
        currentThemeColor = color
    }
    
    // google e-mail account to AppStore: 
    // ahmeddjappstore@gmail.com
    // developersgroupslebanon@gmail.com
    // pass: FACEiraq0405$
    // data urodzenia : 01.01.1980
    // jak się wabi Twój pierwszy zwierzak : "Pluto"
    // jaka jest twoja ulubiona książka dla dzieci : "Winnie-the-Pooh"
    // W jakim mieście poznali się Twoi rodzice : "Lebanon"
    
    static var deviceToken: String = ""
    
    static func setNotifications(isOn: Bool) {
        print("setNotifications: \(isOn)")
        UserDefaults.standard.set(isOn, forKey: "areNotificationsOn")
        var notificationsSettings: UIUserNotificationSettings?
        if isOn {
            notificationsSettings = UIUserNotificationSettings(types: [.alert,.badge,.sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(notificationsSettings!)
            UIApplication.shared.registerForRemoteNotifications()
        } else {
            notificationsSettings = UIUserNotificationSettings(types: [], categories: nil)
            UIApplication.shared.unregisterForRemoteNotifications()
        }
    }
    
    
    static var areNotificationsOn: Bool = {() -> Bool in
        print("areNotificationsOn")
        if UIApplication.shared.isRegisteredForRemoteNotifications != nil {
            return UIApplication.shared.isRegisteredForRemoteNotifications
        }
        return false
    }()
}
