//
//  Section.swift
//  WallPeckers
//
//  Created by Seongchan Kang on 30/11/2018.
//  Copyright © 2018 KimJimin and Company. All rights reserved.
//

import Foundation
import Realm
import RealmSwift
import SwiftyJSON

class Section:Object {
    
    @objc dynamic var title:String?
    @objc dynamic var desc:String?
    @objc dynamic var id:Int = 0
    @objc dynamic var badge:String?
    @objc dynamic var image:String?
    
    
    convenience init(_ json:JSON) {
        self.init()
        self.title = json["title"].stringValue
        self.desc = json["desc"].stringValue
        self.id = json["id"].intValue
        self.badge = json["badge"].stringValue
        self.image = json["image"].stringValue
    }
    
}


class LocalSection:Object {
    
    @objc dynamic var title:String?
    @objc dynamic var desc:String?
    @objc dynamic var id:Int = 0
    @objc dynamic var badge:String?
    @objc dynamic var image:String?
    @objc dynamic var language:Int = 0
    @objc dynamic var section:Int = 0
    
    
    convenience init(_ json:JSON) {
        self.init()
        self.title = json["title"].stringValue
        self.desc = json["desc"].stringValue
        self.id = json["id"].intValue
        self.badge = json["badge"].stringValue
        self.language = json["language"].intValue
        self.section = json["section"].intValue
        self.image = json["image"].stringValue

    }
    
}
