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
    @objc dynamic var score:Int = 0
    @objc dynamic var playTime:Int = 0
    @objc dynamic var allocatedId:Int = 0
    var factCheckList = List<FactCheck>()
    var stars:Int = 0
    var publishedArticles = List<Int>()
    
    
}

class FactCheck:Object {
    
    @objc dynamic var selectedClue:Int = 0
    @objc dynamic var selectedArticleId:Int = 0
    @objc dynamic var isCorrect:Bool = false
    @objc dynamic var correctClue:Int = 0
    @objc dynamic var isSubmit:Bool = false
    @objc dynamic var type:String = ""
    @objc dynamic var selectedIdentication:String = ""

    
}
