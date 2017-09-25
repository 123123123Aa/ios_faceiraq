//
//  Note.swift
//  FaceIraq
//
//  Created by Aleksander Wędrychowski on 19/09/2017.
//  Copyright © 2017 Ready4S. All rights reserved.
//

import RealmSwift
import Foundation

class Note: Object {
    dynamic var urlString: NSString?
    dynamic var date: NSDate!
    dynamic var text: NSString?
    
    convenience init(url: String?, text: String?) {
        self.init()
        self.urlString = url as NSString?
        self.text = text as NSString?
        
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = calendar
        dateFormatter.dateFormat = "YYYY-MM-DD HH:MM"
        
        self.date = NSDate()
    }
}
