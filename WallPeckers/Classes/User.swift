//
//  User.swift
//  WallPeckers
//
//  Created by Seongchan Kang on 30/11/2018.
//  Copyright © 2018 KimJimin and Company. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class User:Object {
    
    @objc dynamic var name:String?
    @objc dynamic var age:Int = 0
    @objc dynamic var profileImage:Data?
    
}
