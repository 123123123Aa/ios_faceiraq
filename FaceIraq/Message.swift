//
//  Message.swift
//  FaceIraq
//
//  Created by HEMIkr on 31/05/2017.
//  Copyright © 2017 Ready4S. All rights reserved.
//

import Foundation
import UIKit

class Message {
    
    let text: String
    var email: String
    let subject: String
    
    var attachment1: UIImage? = nil
    var attachment2: UIImage? = nil
    var attachment3: UIImage? = nil
    
    init(_ subject: String, _ text: String, _ email: String?, _ attachments: [UIImage?] ) {
        
        if let mail = email {
            self.email = mail
        } else {
            self.email = ""
        }
        self.subject = subject
        self.text = text
        
        var attachments = attachments
        guard attachments[0] != nil else { return }
        self.attachment1 = attachments.remove(at: 0)
        guard attachments[0] != nil else { return }
        self.attachment2 = attachments.remove(at: 0)
        guard attachments[0] != nil else { return }
        self.attachment3 = attachments.remove(at: 0)
    }
    
    public func formData() -> [String: Data] {
        var data: [String: Data] = [:]
        data.updateValue(self.subject.data(using: String.Encoding.utf8, allowLossyConversion: true)!,
                         forKey: "subject")
        data.updateValue(self.text.data(using: String.Encoding.utf8, allowLossyConversion: true)!,
                         forKey: "message")
        data.updateValue(self.email.data(using: String.Encoding.utf8, allowLossyConversion: true)!,
                         forKey: "email")
        guard let atta1 = attachment1, let attachment1data = UIImagePNGRepresentation(atta1) else {
            return data
        }
        data.updateValue(attachment1data,
                             forKey: "attachment1")
        guard let atta2 = attachment2, let attachment2data = UIImagePNGRepresentation(atta2) else {
            return data
        }
        data.updateValue(attachment2data,
                            forKey: "attachment2")
        guard let atta3 = attachment3, let attachment3data = UIImagePNGRepresentation(atta3) else {
            return data
        }
        data.updateValue(attachment3data,
                         forKey: "attachment3")

        return data
    }
}
