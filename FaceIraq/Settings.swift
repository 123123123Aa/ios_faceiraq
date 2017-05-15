//
//  ThemeColors.swift
//  FaceIraq
//
//  Created by Aleksander Wędrychowski on 20/04/2017.
//  Copyright © 2017 Ready4S. All rights reserved.
//

import UIKit
import Foundation
import Alamofire

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
    
    static func faceIraqServerRegister() {
        print("faceIraqServerRegister")
        let dict = ["regID": deviceToken,
                    "uuid": deviceUUID(),
                    "model":UIDevice.current.model,
                    "platform":UIDevice.current.systemName,
                    "version":UIDevice.current.systemVersion,
                    "areNotificationsOn":areNotificationsOn ] as [String: Any]
        
        //if (try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)) != nil {
            Alamofire.request(URL(string: "http://www.faceiraq.net/app/api.php?action=regUser")!,
                              method: .post,
                              parameters: dict)
                .response { response in
                    print(response)
            }
            
        //}
    }
    
    static func setNotifications(isOn: Bool) {
        print("setNotifications: \(isOn)")
        UserDefaults.standard.set(isOn, forKey: "areNotificationsOn")
        let isOnInt: Int = {()->Int in
            if isOn {
                return 1
            } else {
                return 0
            }
        }()
        
        let params: [String:AnyObject] = ["is_active": isOnInt as AnyObject,
                                          "uuid":deviceUUID() as AnyObject]
        Alamofire.request(URL(string: "http://www.faceiraq.net/app/api.php?action=pushSetting")!,
                                           method: .post,
                                           parameters: params)
            .response { response in
                print(response)
        }
        
        //AppSettings.faceIraqServerRegister()
    }
    
    
    static var areNotificationsOn: Bool = {() -> Bool in
        print("areNotificationsOn")
        //if UIApplication.shared.isRegisteredForRemoteNotifications != nil {
        return UserDefaults.standard.bool(forKey: "areNotificationsOn")
        //}
        //return false
    }()
}
