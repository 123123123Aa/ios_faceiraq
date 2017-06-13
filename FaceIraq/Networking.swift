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
        let dict = ["regID": AppSettings.shared.deviceToken.data(using: String.Encoding.utf8, allowLossyConversion: true)!,
                    "uuid": AppSettings.shared.deviceUUID.data(using: String.Encoding.utf8, allowLossyConversion: true)!,
                    "model":UIDevice.current.model.data(using: String.Encoding.utf8, allowLossyConversion: true)!,
                    "platform":UIDevice.current.systemName.data(using: String.Encoding.utf8, allowLossyConversion: true)!,
                    "version":UIDevice.current.systemVersion.data(using: String.Encoding.utf8, allowLossyConversion: true)!,
                    "areNotificationsOn":AppSettings.shared.areNotificationsOn.description.data(using: String.Encoding.utf8, allowLossyConversion: true)!] as [String: Data]
        
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(dict["regID"]!, withName: "regID")
            multipartFormData.append(dict["uuid"]!, withName: "uuid")
            multipartFormData.append(dict["model"]!, withName: "model")
            multipartFormData.append(dict["platform"]!, withName: "platform")
            multipartFormData.append(dict["version"]!, withName: "version")
            multipartFormData.append(dict["areNotificationsOn"]!, withName: "areNotificationsOn")
        }, to: "http://www.faceiraq.net/app/api.php?action=regUser",
           encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.response { response in
                    print(response)
                }
            case .failure(let encodingError):
                print(encodingError)
            }
        })
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
        let params = ["is_active": "\(isOnInt)".data(using: String.Encoding.utf8, allowLossyConversion: true)!,
                      "uuid": "\(AppSettings.shared.deviceUUID)".data(using: String.Encoding.utf8, allowLossyConversion: true)!] as [String: Data]
        
        Alamofire.upload(multipartFormData: {multipartFormData in
            multipartFormData.append(params["is_active"]!, withName: "is_active")
            multipartFormData.append(params["uuid"]!, withName: "uuid")
        }, to: "http://www.faceiraq.net/app/api.php?action=pushSetting",
           encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    print(response.result.value)
                }
            case .failure(let encodingError):
                print(encodingError)
            }
        })
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
                            case .failure(let encodingError):
                                success(false)
                            }
                        }
        )
        
        
    }
}
