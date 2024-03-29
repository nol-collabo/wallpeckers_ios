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
    
    @objc dynamic var prints:String?
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
    var clues = List<Int>()
    // 완료된 글에 대한 추가 변수
    @objc dynamic var isCompleted:Bool = false
    @objc dynamic var selectedHashtag = 0
    @objc dynamic var totalQuestionCount = 0
    @objc dynamic var correctQuestionCount = 0
    @objc dynamic var isPairedArticle = false
    @objc dynamic var selectedPictureId = 0
    @objc dynamic var tryCount = 0
    var hashArray = List<Int>()
    
//    @objc dynamic var
    
    var wrongQuestionsId = List<Int>()

    convenience init(_ json:JSON) {
        self.init()
        self.desc = json["desc"].stringValue
        self.result = json["result"].stringValue
        self.point = json["point"].intValue
        self.prints = json["prints"].stringValue

        _ = json["clues"].arrayValue.map({
            
            self.clues.append($0.intValue)
            
        })
        
        self.id = json["id"].intValue
        self.hashes = json["hashes"].stringValue
        self.word = json["word"].stringValue
        self.section = json["section"].intValue
        self.title = json["title"].stringValue
        self.region = json["region"].stringValue
        self.title_sub = json["title_sub"].stringValue
    
    }
    
    func translate(word:String, title:String, title_sub:String, result:String, id:Int, clues:[Int], hashes:String, section:Int, region:String, isCompleted:Bool, selectedHashTag:Int, totalquestionCOunt:Int, correctquestioncount:Int, isPaired:Bool, point:Int, selectedPictureId:Int, prints:String, hashArray:[Int], tryCount:Int) {
        
        self.selectedPictureId = selectedPictureId
        self.word = word
        self.title = title
        self.title_sub = title_sub
        self.result = result
        self.id = id
        self.point = point
        self.tryCount = tryCount
        _ = clues.map({
            self.clues.append($0)

        })
        _ = hashArray.map({
            self.hashArray.append($0)
            
        })
        self.prints = prints
        self.hashes = hashes
        self.section = section
        self.region = region
        self.isCompleted = isCompleted
        self.selectedHashtag = selectedHashTag
        self.totalQuestionCount = totalquestionCOunt
        self.correctQuestionCount = correctquestioncount
        self.isPairedArticle = isPaired
        
    }
    
}

class LocalArticle:Object {
    
    @objc dynamic var prints:String?
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
        
        self.prints = json["prints"].stringValue
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
