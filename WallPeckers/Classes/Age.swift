//
//  Age.swift
//  WallPeckers
//
//  Created by Seongchan Kang on 30/11/2018.
//  Copyright © 2018 KimJimin and Company. All rights reserved.
//

import Foundation
import Realm
import RealmSwift
import SwiftyJSON

class Age:Object {
    
    @objc dynamic var age:String?
    @objc dynamic var id:Int = 0
    
    convenience init(_ json:JSON) {
        self.init()
        self.age = json["age"].stringValue
        self.id = json["id"].intValue
    }
    
}

class LocalAge:Object {
    
    @objc dynamic var age:String?
    @objc dynamic var id:Int = 0
    @objc dynamic var language:Int = 0
    @objc dynamic var age_class:Int = 0

    
    
    convenience init(_ json:JSON) {
        self.init()
        self.age = json["age"].stringValue
        self.id = json["id"].intValue
        self.age_class = json["age_class"].intValue
        self.language = json["language"].intValue
    }
    
    
}
