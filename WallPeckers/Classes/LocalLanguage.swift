//
//  LocalLanguage.swift
//  WallPeckers
//
//  Created by Seongchan Kang on 30/11/2018.
//  Copyright © 2018 KimJimin and Company. All rights reserved.
//

import Foundation
import Realm
import RealmSwift
import SwiftyJSON

class LocalLanguage:Object {
    
    @objc dynamic var id:Int = 0
    @objc dynamic var two_letter:String?
    @objc dynamic var name:String?
    @objc dynamic var name_native:String?
    
    
    convenience init(_ json:JSON) {
        self.init()
        self.two_letter = json["two_letter"].stringValue
        self.id = json["id"].intValue
        self.name = json["name"].stringValue
        self.name_native = json["name_native"].stringValue
    }
    
}
