//
//  history.swift
//  FaceIraq
//
//  Created by Aleksander Wędrychowski on 19/04/2017.
//  Copyright © 2017 Ready4S. All rights reserved.
//

import RealmSwift

class History: Object {

    dynamic var dateOfLastVisit: Date!
    dynamic var url: NSString!
    dynamic var host: NSString!
    dynamic var title: NSString!
    convenience init(url: NSString, host: NSString, title: NSString) {
        self.init()
        self.dateOfLastVisit = Date()
        self.url = url
        self.host = host
        self.title = title
    }
}
