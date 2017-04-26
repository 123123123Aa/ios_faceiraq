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
import FavIcon

class Bookmark: Object {
    
    dynamic var url: NSString!
    dynamic var host: NSString!
    dynamic var icon: NSData?
    
    convenience init(url: NSString, host: NSString) {
        self.init()
        self.url = url
        self.host = host
        
        DispatchQueue.main.async {
            try! FavIcon.downloadPreferred(URL(string: host as String)!) { result in
                if case let .success(returnedImage) = result {
                    print("icon downloaded")
                    self.icon = NSData(data: UIImagePNGRepresentation(returnedImage)!)
                } else {
                    print("FavIcon was unable to download image")
                    
                }
                print("\(result)")
            }
            
        }
    }
}
