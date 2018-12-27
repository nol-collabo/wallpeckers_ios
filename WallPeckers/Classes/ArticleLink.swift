//
//  ArticleLink.swift
//  WallPeckers
//
//  Created by Seongchan Kang on 30/11/2018.
//  Copyright © 2018 KimJimin and Company. All rights reserved.
//

import Foundation
import Realm
import RealmSwift
import SwiftyJSON

class ArticleLink:Object {
    
    @objc dynamic var id:Int = 0
    @objc dynamic var title:String?
    @objc dynamic var game:Int = 0
    @objc dynamic var desc:String?
    @objc dynamic var color:String?
    let articles = List<Int>()

    convenience init(_ json:JSON) {
        self.init()
        self.id = json["id"].intValue
        self.title = json["title"].stringValue
        self.game = json["game"].intValue
        self.desc = json["desc"].stringValue

        _ = json["articles"].arrayValue.map({
            
            self.articles.append($0.intValue)
            
        })
        
        self.color = json["color"].stringValue
    }
    
    func translate(desc:String, id:Int, color:String, articles:[Int]) {
        
        self.desc = desc
        self.id = id
        self.color = color
        
        _ = articles.map({
            self.articles.append($0)
        })
        
    }
    
}

class LocalArticleLink:Object {
    
    @objc dynamic var id:Int = 0
    @objc dynamic var title:String?
    @objc dynamic var desc:String?
    @objc dynamic var article_link:Int = 0
    @objc dynamic var language:Int = 0

    convenience init(_ json:JSON) {
        self.init()
        self.id = json["id"].intValue
        self.title = json["title"].stringValue
        self.desc = json["desc"].stringValue
        self.article_link = json["article_link"].intValue
        self.language = json["language"].intValue

    }
    
}
