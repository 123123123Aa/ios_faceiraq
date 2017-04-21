//
//  Bookmark.swift
//  FaceIraq
//
//  Created by HEMIkr on 21/04/2017.
//  Copyright © 2017 Ready4S. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class Bookmark: Object {
    
    dynamic var url: NSString!
    dynamic var host: NSString!
    dynamic var userTitle: NSString?
    
    convenience init(url: NSString, host: NSString) {
        self.init()
        self.url = url
        self.host = host
    }
}
