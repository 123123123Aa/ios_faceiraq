//
//  Bookmark.swift
//  FaceIraq
//
//  Created by Aleksander Wędrychowski on 21/04/2017.
//  Copyright © 2017 Ready4S. All rights reserved.
//

import RealmSwift

class Bookmark: Object {
    
    dynamic var url: NSString!
    dynamic var host: NSString!
    dynamic var title: NSString!
    
    convenience init(url: NSString, host: NSString, title: NSString) {
        self.init()
        self.url = url
        self.host = host
        self.title = title
    }
}
