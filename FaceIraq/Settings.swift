//
//  ThemeColors.swift
//  FaceIraq
//
//  Created by Aleksander Wędrychowski on 20/04/2017.
//  Copyright © 2017 Ready4S. All rights reserved.
//

import UIKit
import Foundation

struct AppSettings {
    static let faceIraqAdress = "http://www.faceiraq.net"
    static var currentThemeColor = UIColor.AppColors.appBeige
    static var currentTintColor: UIColor {
        if currentThemeColor == UIColor.AppColors.appBeige {return UIColor.black}
        else {return UIColor.white}
    }
    
    static func loadTheme() {
        if let color = UserDefaults.standard.color(forKey: "themeColor") {
            AppSettings.currentThemeColor = color
        }
    }
    
    static func setThemeColor(to color: UIColor) {
        UserDefaults.standard.set(color, forKey: "themeColor")
        currentThemeColor = color
    }
    
    // google e-mail account to AppStore: 
    // ahmeddjappstore@gmail.com - invalid
    // developersgroupslebanon@gmail.com - invalid
    // ahmedQaysHammed@gmail.com
    // pass: FACEiraq0405$
    // data urodzenia : 04/01/1982
    // jak się wabi Twój pierwszy zwierzak : "Pluto"
    // jaka jest twoja ulubiona książka dla dzieci : "Winnie-the-Pooh"
    // W jakim mieście poznali się Twoi rodzice : "Rome"
    
    static var deviceToken: String {
        get {
            if let token = UserDefaults.standard.string(forKey: "token") {
                return token
            } else {
                return "no token"
            }
        } set(newToken) {
            UserDefaults.standard.set(newToken as String, forKey: "token")
        }
    }
    
    static let deviceUUID = {()->String in
        return UIDevice.current.identifierForVendor!.uuidString
    }
    
    static func setNotifications(isOn: Bool) {
        print("setNotifications: \(isOn)")
        UserDefaults.standard.set(isOn, forKey: "areNotificationsOn")
        Networking.updateNotificationSettings()
    }
    
    static var areNotificationsOn: Bool = {() -> Bool in
        print("areNotificationsOn")
        return UserDefaults.standard.bool(forKey: "areNotificationsOn")
    }()
}
