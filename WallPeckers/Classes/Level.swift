//
//  Level.swift
//  WallPeckers
//
//  Created by Seongchan Kang on 30/11/2018.
//  Copyright © 2018 KimJimin and Company. All rights reserved.
//

import Foundation
import Realm
import RealmSwift
import SwiftyJSON

class Level:Object {
    
    @objc dynamic var maxPoint:Int = 0
    @objc dynamic var minPoint:Int = 0
    @objc dynamic var grade:String?
    @objc dynamic var image:String?
    @objc dynamic var id:Int = 0
    
    convenience init(_ json:JSON) {
        self.init()
        self.maxPoint = json["maxPoint"].intValue
        self.minPoint = json["minPoint"].intValue
        self.grade = json["grade"].stringValue
        self.image = json["image"].stringValue
        self.id = json["id"].intValue
    }
    
    
}

class LocalLevel:Object {
    
    @objc dynamic var maxPoint:Int = 0
    @objc dynamic var minPoint:Int = 0
    @objc dynamic var grade:String?
    @objc dynamic var image:String?
    @objc dynamic var level:Int = 0
    @objc dynamic var language:Int = 0
    @objc dynamic var id:Int = 0
    
    convenience init(_ json:JSON) {
        self.init()
        self.maxPoint = json["maxPoint"].intValue
        self.minPoint = json["minPoint"].intValue
        self.grade = json["grade"].stringValue
        self.image = json["image"].stringValue
        self.level = json["level"].intValue
        self.language = json["language"].intValue
        self.id = json["id"].intValue
    }
    
    
}
