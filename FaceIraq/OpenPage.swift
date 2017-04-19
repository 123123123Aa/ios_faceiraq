//
//  OpenPage.swift
//  FaceIraq
//
//  Created by HEMIkr on 18/04/2017.
//  Copyright © 2017 Ready4S. All rights reserved.
//

import RealmSwift
import Realm
import Foundation

class OpenPage: Object {
    dynamic var dateOfLastVisit: Date!
    dynamic var url: NSString?
    dynamic var screen: NSData?
    
    convenience init(url: NSString, screen: NSData?) {
        self.init()
        self.dateOfLastVisit = Date()
        self.url = url
        self.screen = screen
    }
}
