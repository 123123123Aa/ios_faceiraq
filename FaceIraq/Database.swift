//
//  Realm.swift
//  FaceIraq
//
//  Created by HEMIkr on 30/05/2017.
//  Copyright © 2017 Ready4S. All rights reserved.
//

import Foundation
import RealmSwift

class Database {
    
    class var shared: Realm {
        struct Singleton {
            static let instance = try! Realm()
        }
        
        return Singleton.instance
    }
    
    
}

extension Realm {
    
    func save(_ object: History) {
        if self.isInWriteTransaction == false {
            self.beginWrite()}
        self.add(object)
        try! self.commitWrite()
    }
    
    func save(_ object: Bookmark) {
        if self.isInWriteTransaction == false {
            self.beginWrite()}
        self.add(object)
        try! self.commitWrite()
    }
    
    func save(_ object: OpenPage) {
        if self.isInWriteTransaction == false {
            self.beginWrite()}
        self.add(object)
        try! self.commitWrite()
    }
    
    func remove(_ object: OpenPage) {
        if self.isInWriteTransaction == false {
            self.beginWrite()}
        self.delete(object)
        try! self.commitWrite()
        self.refresh()

    }
    
    func remove(_ object: History) {
        if self.isInWriteTransaction == false {
            self.beginWrite()}
        self.delete(object)
        try! self.commitWrite()
        self.refresh()
    }
    
    func remove(_ object: Bookmark) {
        if self.isInWriteTransaction == false {
            self.beginWrite()}
        self.delete(object)
        try! self.commitWrite()
        self.refresh()
    }
    
}
