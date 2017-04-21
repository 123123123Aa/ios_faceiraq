//
//  history.swift
//  FaceIraq
//
//  Created by HEMIkr on 19/04/2017.
//  Copyright © 2017 Ready4S. All rights reserved.
//

import Realm
import RealmSwift

class History: Object {

    dynamic var dateOfLastVisit: Date!
    dynamic var url: NSString!
    dynamic var host: NSString!
    dynamic var image: NSData?
    convenience init(url: NSString, host: NSString) {
        self.init()
        self.dateOfLastVisit = Date()
        self.url = url
    }
}
