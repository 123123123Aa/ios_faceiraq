//
//  Realm extensions.swift
//  FaceIraq
//
//  Created by Aleksander Wędrychowski on 19/04/2017.
//  Copyright © 2017 Ready4S. All rights reserved.
//

import Realm
import RealmSwift

extension Results {
    func toArray<T>(ofType: T.Type) -> [T] {
        var array = [T]()
        for i in 0 ..< count {
            if let result = self[i] as? T {
                array.append(result)
            }
        }
        
        return array
    }
}

