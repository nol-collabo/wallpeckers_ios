//
//  FIVE_W_ONE_HS.swift
//  WallPeckers
//
//  Created by Seongchan Kang on 30/11/2018.
//  Copyright © 2018 KimJimin and Company. All rights reserved.
//

import Foundation
import Realm
import RealmSwift
import SwiftyJSON

class Five_W_One_Hs:Object {
    
    @objc dynamic var id:Int = 0
    @objc dynamic var clue:Int = 0
    @objc dynamic var point:Int = 0
    @objc dynamic var given:Bool = false
    @objc dynamic var article:Int = 0
    
    convenience init(_ json:JSON) {
        self.init()
        self.id = json["id"].intValue
        self.clue = json["clue"].intValue
        self.point = json["point"].intValue
        self.article = json["article"].intValue
        self.given = json["given"].boolValue
        
    }
    
}
