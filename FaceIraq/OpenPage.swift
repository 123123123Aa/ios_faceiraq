//
//  OpenPage.swift
//  FaceIraq
//
//  Created by Aleksander Wędrychowski on 18/04/2017.
//  Copyright © 2017 Ready4S. All rights reserved.
//

import RealmSwift
import Foundation

class OpenPage: Object {
    
    dynamic var dateOfLastVisit: Date!
    dynamic var url: NSString?
    dynamic var screen: NSData?
    dynamic var host: NSString?
    dynamic var id: NSString!
    convenience init(url: NSString?, host: NSString?, screen: NSData?) {
        self.init()
        self.dateOfLastVisit = Date()
        self.url = url
        self.host = host
        self.screen = screen
        self.id = String(UUID().uuidString.prefix(10)) as NSString
    }
}

struct NotificationPage {
    let url: URL
    
    init(stringURL: String) {
        self.url = URL(string: stringURL)!
    }
}
