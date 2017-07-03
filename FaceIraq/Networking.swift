//
//  Networking.swift
//  FaceIraq
//
//  Created by HEMIkr on 18/05/2017.
//  Copyright © 2017 Ready4S. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Networking {
    
    //MARK: API methonds
    
    static func faceIraqServerRegister() {
        let dict = ["regID": AppSettings.shared.deviceToken,
                    "uuid": AppSettings.shared.deviceUUID,
                    "model":UIDevice.current.model,
                    "platform":UIDevice.current.systemName,
                    "version":UIDevice.current.systemVersion,
                    "areNotificationsOn":AppSettings.shared.areNotificationsOn] as [String: Any]
        
        Alamofire.request("http://www.faceiraq.net/app/api.php?action=regUser", method: .post, parameters: dict).responseJSON { json in
            guard json.result.isSuccess else {
                print("FACEIRAQ.faceIraqServerRegister() failure")
                return
            }
            print("FACEIRAQ.faceIraqServerRegister() success")
        }
    }
    
    static func updateNotificationSettings() {
        let params: [String: Any] = [
            "is_active": AppSettings.shared.areNotificationsOn().hashValue,
            "uuid": AppSettings.shared.deviceUUID
        ]
        
        Alamofire.request("http://www.faceiraq.net/app/api.php?action=pushSetting", method: .post, parameters: params).response { response in
            guard response.response?.statusCode == 200 else {
                print("FACEIRAQ.updateNotificationSettings() failure")
                return
            }
            print("FACEIRAQ.updateNotificationSettings() success")
        }
    }
    
    static func sendMessage(_ message: Message, success: @escaping (_ success: Bool)->()) {
        
        let data = message.formData()
        
        Alamofire.upload(multipartFormData: { multipartFormData in
        
            multipartFormData.append(data["subject"]!, withName: "subject")
            multipartFormData.append(data["message"]!, withName: "message")
            multipartFormData.append(data["email"]!, withName: "email")
            if let attachment1 = data["attachment1"] {
                multipartFormData.append(attachment1, withName: "attachment1")
            }
            if let attachment2 = data["attachment3"] {
                multipartFormData.append(attachment2, withName: "attachment2")
            }
            if let attachment3 = data["attachment3"] {
                multipartFormData.append(attachment3, withName: "attachment3")
            }
            },
                
                         to: "http://www.faceiraq.net/app/api.php?action=contactUsMsg",
                         encodingCompletion: { encodingResult in
                            switch encodingResult {
                            case .success(let upload, _, _):
                                upload.responseJSON { response in
                                    print(response)
                                    
                                    if let json = response.result.value as? [String: Any], let status = json["status"] as? String {
                                        switch status {
                                            case "success":
                                            success(true)
                                            default:
                                            success(false)
                                        }
                                    }
                                }
                            case .failure(let _):
                                success(false)
                            }
                        }
        )
        
        
    }
}
