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

class RealmArticle {
    
    static var shared = RealmArticle()
    
    private init() {}
    
    private func getAll() -> [Article]{
        
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
                    
                    translate.translate(word: local.word!, title: local.title!, title_sub: local.title_sub!, result: local.result!, id: local.article, clues: $0.clues, hashes: $0.hashes!, section: $0.section)
                    
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
