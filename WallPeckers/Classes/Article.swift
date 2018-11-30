//
//  Article.swift
//  WallPeckers
//
//  Created by Seongchan Kang on 30/11/2018.
//  Copyright © 2018 KimJimin and Company. All rights reserved.
//
import Foundation
import Realm
import RealmSwift
import SwiftyJSON

class Article:Object {
    
    
    @objc dynamic var desc:String?
    @objc dynamic var result:String?
    @objc dynamic var point:Int = 0
//    @objc dynamic var clues:List<Int> =
    @objc dynamic var id:Int = 0
    @objc dynamic var hashes:String?
    @objc dynamic var word:String?
    @objc dynamic var section:Int = 0
    @objc dynamic var title:String?
    @objc dynamic var region:String?
    @objc dynamic var title_sub:String?
    let clues = List<Int>()

    convenience init(_ json:JSON) {
        self.init()
        self.desc = json["desc"].stringValue
        self.result = json["result"].stringValue
        self.point = json["point"].intValue
//        self.clues = json["clues"]
        
//        self.clues.append(json["clues"].array
        
        _ = json["clues"].arrayValue.map({
            
            self.clues.append($0.intValue)
            
        })
        
//        RLMArray.init(objectType: .int, optional: true)
        self.id = json["id"].intValue
        self.hashes = json["hashes"].stringValue
        self.word = json["word"].stringValue
        self.section = json["section"].intValue
        self.title = json["title"].stringValue
        self.region = json["region"].stringValue
        self.title_sub = json["title_sub"].stringValue
    }
    
}

class LocalArticle:Object {
    
    @objc dynamic var result:String?
    @objc dynamic var id:Int = 0
    @objc dynamic var article:Int = 0
    @objc dynamic var language:Int = 0
    @objc dynamic var word:String?
    @objc dynamic var title:String?
    @objc dynamic var desc:String?
    @objc dynamic var title_sub:String?
    
    convenience init(_ json:JSON) {
        self.init()
        
        self.desc = json["desc"].stringValue
        self.result = json["result"].stringValue
        self.id = json["id"].intValue
        self.word = json["word"].stringValue
        self.language = json["language"].intValue
        self.title = json["title"].stringValue
        self.article = json["article"].intValue
        self.title_sub = json["title_sub"].stringValue
    }
    
}
