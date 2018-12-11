//
//  Clue.swift
//  WallPeckers
//
//  Created by Seongchan Kang on 30/11/2018.
//  Copyright © 2018 KimJimin and Company. All rights reserved.
//

import Foundation
import Realm
import RealmSwift
import SwiftyJSON

class Clue:Object {
    
    @objc dynamic var id:Int = 0
    @objc dynamic var identification:String?
    @objc dynamic var desc:String?
    @objc dynamic var type:String?
    @objc dynamic var title:String?
    
    convenience init(_ json:JSON) {
        self.init()
        self.id = json["id"].intValue
        self.identification = json["identification"].stringValue
        self.desc = json["desc"].stringValue
        self.type = json["type"].stringValue
        self.title  = json["title"].stringValue
    }
    
    func translate(id:Int, identification:String, desc:String, type:String) {
        self.id = id
        self.identification = identification
        self.desc = desc
        self.type = type
        
    }
    
    
    
}

class LocalClue:Object {
    
    @objc dynamic var id:Int = 0
    @objc dynamic var clue:Int = 0
    @objc dynamic var language:Int = 0
    @objc dynamic var desc:String?
    @objc dynamic var title:String?
    
    convenience init(_ json:JSON) {
        self.init()
        self.id = json["id"].intValue
        self.clue = json["clue"].intValue
        self.desc = json["desc"].stringValue
        self.language = json["language"].intValue
        self.title  = json["title"].stringValue
    }
    
}
