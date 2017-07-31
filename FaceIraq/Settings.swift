import UIKit
import Foundation
import RealmSwift
import Realm
import UserNotifications

class AppSettings {
    let faceIraqAdress = "http://www.faceiraq.net/"
    let deviceUUID = UIDevice.current.identifierForVendor!.uuidString
    var currentThemeColor = UIColor.AppColors.appBeige
    var currentTintColor: UIColor {
        if currentThemeColor == UIColor.AppColors.appBeige {return UIColor.black}
        else {return UIColor.white}
    }
    
    class var shared: AppSettings {
        struct Singleton {
            static let instance = AppSettings()
        }
        return Singleton.instance
    }
    
    var notificationPage: NotificationPage?
    
    func faceIraqAlreadyOpened()->OpenPage? {
        let array = Database.shared.objects(OpenPage.self).toArray(ofType:OpenPage.self)
        for item in array {
            if item.url == self.faceIraqAdress as NSString {
                return item
            }
        }
        return nil
    }
    
    func loadTheme() {
        if let color = UserDefaults.standard.color(forKey: "themeColor") {
            self.currentThemeColor = color
        }
    }
    
    func setThemeColor(to color: UIColor) {
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
    
    var deviceToken: String {
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
    
    func setNotifications(isOn: Bool) {
        UserDefaults.standard.set(isOn, forKey: "areNotificationsOn")
        Networking.updateNotificationSettings()
    }
    
    func areNotificationsOn()->Bool {
        let notificationSettings = UIApplication.shared.currentUserNotificationSettings?.types
        if notificationSettings?.rawValue == 0 {
            return false
        } else {
            return UserDefaults.standard.bool(forKey: "areNotificationsOn")
        }
    }
}
