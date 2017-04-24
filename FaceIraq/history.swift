//
//  history.swift
//  FaceIraq
//
//  Created by HEMIkr on 19/04/2017.
//  Copyright © 2017 Ready4S. All rights reserved.
//

import Realm
import RealmSwift
import FavIcon

class History: Object {

    dynamic var dateOfLastVisit: Date!
    dynamic var url: NSString!
    dynamic var host: NSString!
    dynamic var image: NSData?
    convenience init(url: NSString, host: NSString) {
        self.init()
        self.dateOfLastVisit = Date()
        self.url = url
        self.host = host
        
        DispatchQueue.main.async {
            try! FavIcon.downloadPreferred(URL(string: host as String)!) { result in
                if case let .success(returnedImage) = result {
                    print("icon downloaded")
                    self.image = NSData(data: UIImagePNGRepresentation(returnedImage)!)
                } else {
                    print("FavIcon was unable to download image")
                }
                print("\(result)")
            }
        }
    }
}
