//
//  Realm.swift
//  FaceIraq
//
//  Created by HEMIkr on 22/05/2017.
//  Copyright © 2017 Ready4S. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class Realm {
    static let shared = Realm()
    
    private init() {
        super.init()
    }
}
