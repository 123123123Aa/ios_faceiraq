//
//  Networking.swift
//  FaceIraq
//
//  Created by HEMIkr on 18/05/2017.
//  Copyright © 2017 Ready4S. All rights reserved.
//

import Foundation
import Alamofire

class Networking {
    
    //MARK: API methonds
    
    static func faceIraqServerRegister() {
        print("faceIraqServerRegister")
        let dict = ["regID": AppSettings.shared.deviceToken,
                    "uuid": AppSettings.shared.deviceUUID,
                    "model":UIDevice.current.model,
                    "platform":UIDevice.current.systemName,
                    "version":UIDevice.current.systemVersion,
                    "areNotificationsOn":AppSettings.shared.areNotificationsOn ] as [String: Any]
        
        Alamofire.request(URL(string: "http://www.faceiraq.net/app/api.php?action=regUser")!,
                          method: .post,
                          parameters: dict)
            .response { response in
                print(response)
        }
    }
    
    static func updateNotificationSettings() {
        let notifcationsSettings = UserDefaults.standard.bool(forKey: "areNotificationsOn")
        let isOnInt: Int = {()->Int in
            if notifcationsSettings == true {
                return 1
            } else {
                return 0
            }
        }()
        let params = ["is_active": isOnInt,
                      "uuid": AppSettings.shared.deviceUUID] as [String: Any]
        Alamofire.request(URL(string: "http://www.faceiraq.net/app/api.php?action=pushSetting")!,
                          method: .post,
                          parameters: params)
            .response { response in
                print(response)
        }
    }
    
    
    
}
