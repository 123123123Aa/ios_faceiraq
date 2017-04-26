//
//  history.swift
//  FaceIraq
//
//  Created by HEMIkr on 19/04/2017.
//  Copyright © 2017 Ready4S. All rights reserved.
//

import Realm
import RealmSwift
import Alamofire
import AlamofireImage

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
        //self.image = {
        
        print("attempt to download icon")
        
        
        let headers = ["X-Mashape-Key":"Ep1HhOXXt8mshfxdx2WY5XoiwzdDp1fVjBYjsn8JH6wGTaUKsW"]
        let url = URL(string: "https://realfavicongenerator.p.mashape.com/favicon/icon?platform=iOS&site=https%3A%2F%2Fwww.rp.pl")
        
        print("starting icon fetching process")
        if let imageURL = url {
            print("sending request")
            Alamofire.request(imageURL, headers: headers).responseImage(completionHandler: { response in
                print("attempt to fetch request")
                print(response.response?.statusCode)
                if let image = response.result.value {
                    let imageData = NSData(data: UIImagePNGRepresentation(image)!)
                    self.image = imageData
                    print("image fetched")
                    }
                if response.result.value == nil {
                    print("resonse result is nil")
                }
                }
                
            )
            
            Alamofire.request(imageURL, headers: headers).response { response in
                print("status code: \(response.response?.statusCode)")
                }
            }
        
        
            /*
            let interactor = IconInteracor()
            if let image = interactor.favconRequest(stringURL: "") {
                self.image = NSData(data: UIImagePNGRepresentation(image)!)
            }*/
        
    }
}
