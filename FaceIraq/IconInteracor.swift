//
//  IconInteracor.swift
//  FaceIraq
//
//  Created by HEMIkr on 25/04/2017.
//  Copyright © 2017 Ready4S. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage
import SwiftyJSON

class IconInteracor {
    func favconRequest(stringURL: NSString) -> UIImage? {
        let headers = ["X-Mashape-Key":"Ep1HhOXXt8mshfxdx2WY5XoiwzdDp1fVjBYjsn8JH6wGTaUKsW"]
        let url = URL(string: "https://realfavicongenerator.p.mashape.com/favicon/icon?site=https%3A%2F%2Fwww.rp.pl")//stringURL as String)
        
        print("starts faviconRequest")
        let req = Alamofire.request(url!, headers: headers)
        
       
            req.responseImage { response in
            print("req.responseImage: response")
            print(response)
            
            
            guard let statusCode = response.response?.statusCode else {
                print("no statusCode")
                return}
            switch statusCode {
            case 200:
                print("status code == 200")
                break
            default:
                print("status code != 200")
                break
            }
        }
        print("end of req.responseImage.request")
        return nil
            /*
            { response in
            
            print(response)
            guard let statusCode = response.response?.statusCode
                else { return handler(.networkError) }
            switch statusCode {
            case 200:
                var json: [String: AnyObject]?
                do {
                    json = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject]
                } catch {
                    handler(.networkError)
                }
                
                if let json = json, let response = ScoreProfileDetails(json: json) {
                    handler(.success(response))
                } else {
                    handler(.networkError)
                }
            default:
                handler(.networkError)
            }
        }*/
        //return req
        //Alamofire.request
        //Alamofire.request(url, method: .get, parameters: nil, encoding: nil, headers: headers)
        
        /*
        NSDictionary *headers = @{@"X-Mashape-Key": @"Ep1HhOXXt8mshfxdx2WY5XoiwzdDp1fVjBYjsn8JH6wGTaUKsW"};
        UNIUrlConnection *asyncConnection = [[UNIRest get:^(UNISimpleRequest *request) {
            [request setUrl:@"https://realfavicongenerator.p.mashape.com/favicon/icon?site=https%3A%2F%2Fwww.rp.pl"];
            [request setHeaders:headers];
            }] asBinaryAsync:^(UNIHTTPBinaryResponse *response, NSError *error) {
            NSInteger code = response.code;
            NSDictionary *responseHeaders = response.headers;
            UNIJsonNode *body = response.body;
            NSData *rawBody = response.rawBody;
            }];
        */
        
    
}
}
