//
//  Singleton.swift
//  WallPeckers
//
//  Created by Seongchan Kang on 11/12/2018.
//  Copyright © 2018 KimJimin and Company. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class RealmUser {
    
    static var shared = RealmUser()
    private var user:User?
    var delegate:LevelUpDelegate?
    
    private var score:Int = 0 {
        didSet {
            if oldValue != score { // 변경될때만
                delegate?.levelupPopUp(score: score)
            }
        }
    }
    private init(){}
    
    func getUserData() -> User? {
        if let user = realm.objects(User.self).first {
            self.user = user
            self.score = user.score
            return user
        }else{
            return nil
        }
    }
    
    func savePlayTime() {
        guard let user = user else {return}

        
        try! realm.write {
            user.playTime = Standard.shared.gamePlayTime
        }
    }
    
    func resetPlayTime() {
        guard let user = user else {return}
        
        
        try! realm.write {
            user.playTime = 0
        }
    }
    
    func getUserLevel() -> String {
//        get {
            let levels = RealmLevel.shared.get(Standard.shared.getLocalized()).sorted(by: {$0.id < $1.id})
            
            if let myPoint = RealmUser.shared.getUserData()?.score {
                
                if myPoint < 2000 {
                    return levels[0].grade!
                }else if myPoint < 4000 {
                    return levels[1].grade!
                }else if myPoint < 8000 {
                    return levels[2].grade!
                }else if myPoint < 12000 {
                    return levels[3].grade!
                }else {
                    return levels[4].grade!
                }
            }
            return "Intern"
//        }
    }
    
    
    
    func initializedUserInfo() {
        guard let user = user else {return}
        
        UserDefaults.standard.set(0, forKey: "enterForeground")
        UserDefaults.standard.set(0, forKey: "enterBackground")
        UserDefaults.standard.set(false, forKey: "Tutorial")
        UserDefaults.standard.set(false, forKey: "Playing")
        UserDefaults.standard.set(0, forKey: "sessionId")
        
        try! realm.write {
            user.factCheckList.removeAll()
            user.score = 0
            user.playTime = 0
            user.stars = 0
            
            _ = RealmArticle.shared.get(Standard.shared.getLocalized()).map({
                $0.isPairedArticle = false
                $0.isCompleted = false
                $0.correctQuestionCount = 0
                $0.wrongQuestionsId.removeAll()
                $0.selectedHashtag = 0
                $0.totalQuestionCount = 0
                $0.point = 0
                
            })
            
            _ = RealmArticle.shared.getAll().map({
                
                $0.isPairedArticle = false
                $0.isCompleted = false
                $0.correctQuestionCount = 0
                $0.wrongQuestionsId.removeAll()
                $0.selectedHashtag = 0
                $0.totalQuestionCount = 0
                $0.point = 0

            })
        }
    }
}

protocol LevelUpDelegate {
    func levelupPopUp(score:Int)
}

class RealmLevel {
    
    static var shared = RealmLevel()
    
    private init() {}
    
    func getAll() -> [Level] {
        
        return Array(realm.objects(Level.self))
        
    }
    
    func get(_ language:Language) -> [Level] {
        
        let originalLevel = getAll()
        var languageInt = 0
        switch language {
        case .ENGLISH:
            languageInt = 2
        case .GERMAN:
            languageInt = 3
        case .KOREAN:
            return originalLevel
            
        }
        
        let localLevel = realm.objects(LocalLevel.self).filter("language = \(languageInt)")
        
        
        var translates:[Level] = []
        
        _ = originalLevel.map({
            
            for lv in localLevel {
                
                if $0.id == lv.level {

                    let tr = Level()
                    
                    tr.translate(level: $0.id, grade: lv.grade!, maxPoint: $0.maxPoint, minPoint: $0.minPoint)
                    
                    translates.append(tr)

                }
                
            }
        })
        
        return translates
  
    }
    
    
}

class RealmArticle {
    
    static var shared = RealmArticle()
    
    private init() {}
    
    open func getAll() -> [Article]{
        
        return Array(realm.objects(Article.self))
        
    }
    
    open func get(_ language:Language) -> [Article] {
        
        let originalArticles = getAll()
        var languageInt = 0
        switch language {
        case .ENGLISH:
            languageInt = 2
        case .GERMAN:
            languageInt = 3
        case .KOREAN:
            return originalArticles

        }
        
        let localArticles = Array(realm.objects(LocalArticle.self).filter("language = \(languageInt)"))
        
        var translateArticles:[Article] = []
        

        _ = originalArticles.map({
            
            
            for local in localArticles {
                
                if $0.id == local.article {
                    
                    let translate = Article()
                   
                    translate.translate(word: local.word!, title: local.title!, title_sub: local.title_sub!, result: local.result!, id: local.article, clues: Array($0.clues), hashes: $0.hashes!, section: $0.section, region: $0.region!, isCompleted: $0.isCompleted, selectedHashTag: $0.selectedHashtag, totalquestionCOunt: $0.totalQuestionCount, correctquestioncount: $0.correctQuestionCount, isPaired: $0.isPairedArticle, point: $0.point, selectedPictureId: $0.selectedPictureId, prints: local.prints!)
                    
                    translateArticles.append(translate)
                }
            }
            
        })
        
        return translateArticles

    }
    
    
    
}

class RealmArticleLink {
    
    static var shared = RealmArticleLink()
    
    private init() {}
    
    open func getAll() -> [ArticleLink] {
        
        return Array(realm.objects(ArticleLink.self))
        
    }
    
    func get(_ language:Language) -> [ArticleLink] {
        
        var lanInt = 0
        let originals = getAll()
        
        switch language {
        case .ENGLISH:
            lanInt = 2
        case .KOREAN :
            return originals
        case .GERMAN :
            lanInt = 3
        }
        
        let localLink = Array(realm.objects(LocalArticleLink.self).filter("language = \(lanInt)"))
        
        var translates:[ArticleLink] = []
        
        _ = originals.map({
            
            for la in localLink {
                if $0.id == la.article_link {
                    
                    let tr = ArticleLink()
                    
                    tr.translate(desc:la.desc!, id: $0.id, color: $0.color!, articles: Array($0.articles))
                    
                    translates.append(tr)
                }
            }
            
        })
        
        return translates
        
    }
}

class RealmSection {
    
    static var shared = RealmSection()
    
    private init() {}
    
    private func getAll() -> [Section] {
        
        return Array(realm.objects(Section.self))
        
    }
    
    func get(_ language:Language) -> [Section] {
        
        var lanInt = 0
        let originalSection = getAll()
        switch language {
        case .ENGLISH:
            lanInt = 2
        case .KOREAN:
            return originalSection
        case .GERMAN:
            lanInt = 3
        }
        let localSection = Array(realm.objects(LocalSection.self).filter("language = \(lanInt)"))
        
        var translates:[Section] = []
        
  
        _ = originalSection.map({
            
            for ls in localSection {
                if $0.image == ls.image {
                    
                    let a = Section()
                    
                    a.translate(title: ls.title!, desc: ls.desc!, id: $0.id, badge: ls.badge!, image: ls.image!)
                    
                    translates.append(a)
                }

            }
            
        })
        
        return translates

        
        
    }
}

class RealmClue {
    
    static var shared = RealmClue()
    
    private init(){}
    
    func getClue(id:Int) -> Clue? {
        
        if let clue = realm.objects(Clue.self).filter({
            
            $0.id == id
        }).first {
            return clue
        }else{
            return nil
        }
    }
    
    func getClueAsIdentification(_ identification:String, language:Language) -> Clue? {
        
        var lanInt = 0
        
        switch language {
        case .KOREAN:
            return realm.objects(Clue.self).filter("identification = '\(identification)'").first
        case .GERMAN:
            lanInt = 3
        case .ENGLISH:
            lanInt = 2
        }
        let localClue = Array(realm.objects(LocalClue.self).filter("language = \(lanInt)"))

        

        if let original = realm.objects(Clue.self).filter("identification = '\(identification)'").first {
            
            let translate = Clue()
            
            for lc in localClue {
                
                if original.id == lc.clue {
                    translate.translate(id: lc.clue, identification: original.identification!, desc: lc.desc!, type: original.type!)
                }
                
            }
            return translate
            
            
        }else{
            return nil
        }
        
        
        
    }
    
//    func getClueAsIdentifcation() -> Clue? {
//
//    }
    
    func getLocalClue(id:Int, language:Language) -> Clue? {
        
        var lanInt = 0
        
        switch language {
        case .KOREAN:
            return getClue(id: id)
        case .GERMAN:
            lanInt = 3
        case .ENGLISH:
            lanInt = 2
        }
        
        let originalClue = getClue(id: id)
        let localClue = Array(realm.objects(LocalClue.self).filter("language = \(lanInt)"))
        var translate:Clue?

        _ = originalClue.map({


            for lc in localClue {
                
                if $0.id == lc.clue {
                    
                    let translateClue = Clue()
                    translateClue.translate(id: lc.clue, identification: $0.identification!, desc: lc.desc!, type: $0.type!)
                    translate = translateClue
                }
            }

        })
        
        return translate
        
        
    }
    
}

struct Album {
    //
    static func findImages(articleId:Int)-> [String]{
        
        
        var images:[String] = []
        
        if let mainImage = Bundle.main.path(forResource: "image_article_0\(articleId)", ofType: "png") {
            
            images.append(mainImage)
            
        }
        
        for i in 2...6 {
            
            if let subImages = Bundle.main.path(forResource: "image_article_0\(articleId)_0\(i)", ofType: "jpg") {
                images.append(subImages)
            }
            
        }
        
        return images
        
    }
}
