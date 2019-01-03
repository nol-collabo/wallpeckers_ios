//
//  CustomAPI.swift
//  WallPeckers
//
//  Created by Seongchan Kang on 02/01/2019.
//  Copyright © 2019 KimJimin and Company. All rights reserved.
//

import Foundation
import SwiftyJSON
import Realm
import RealmSwift
import Alamofire

struct CustomAPI {
    
    static let domainUrl = "http://api.dmz.wallpeckers.kr/"
    
    static func newPlayer(completion:@escaping ((Int)->Void)) {
        
        Alamofire.request("\(domainUrl)new/player", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
                
            case .success(let value):
                
                print(value)
                
                let json = JSON(value)
                
                completion(json["Player"]["id"].intValue)
                
            case .failure(let error):

                print(error.localizedDescription)
                completion(0)
                
            }
        }
    }
    
    static func getSessionID(passcode:String, completion:@escaping ((Int)->Void)) {
        
        Alamofire.request("\(domainUrl)session/\(passcode)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
                
            case .success(let value):
                
                let json = JSON(value)
                
                if let sessionId = json["Session"]["id"].int {
                    completion(sessionId)
                }else{
                    completion(-1)
                    //에러구간, 팝업 띄우기
                }
                
                
            case .failure(let error):
                print(error.localizedDescription)
                completion(-1)
            }
        }
    }
    
    static func saveArticleData(articleId:Int, category:Int, playerId:Int, language:Language, sessionId:Int, tag:Int, count:Int, photoId:Int, completion:((Any)->())?) {
        
        let params:Parameters = ["article_proto":articleId, "category":category, "player":playerId, "language":language.rawValue, "session":sessionId, "tag":tag, "num_of_check_fact":count, "photo":photoId]
        
        
        Alamofire.request("\(domainUrl)new/article/", method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
                
            case .success(let value):
                
                print(value)
                
                guard let _completion = completion else {return}
                
                _completion(value)
                
                
            case .failure(let error):
                
                guard let _completion = completion else {return}

                _completion(error.localizedDescription)
                print(error.localizedDescription)
                
            }
        }
    }
    
    static func saveIncorrect(articleId:Int, playerId:Int, sessionId:Int, clue_type:String, code_incorrect:Int, code_correct:Int, completion:((Any)->())?) {
        
        let params:Parameters = ["article_proto":articleId, "player":playerId, "session":sessionId, "clue_type":clue_type, "code_incorrect":code_incorrect, "code_correct":code_correct]
        
        
        Alamofire.request("\(domainUrl)", method: .get, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
                
            case .success(let value):
                
                print(value)
                
                guard let _completion = completion else {return}
                
                _completion(value)
                
                
            case .failure(let error):
                
                guard let _completion = completion else {return}
                
                _completion(error.localizedDescription)
                print(error.localizedDescription)
                
            }
        }
    }
    
    static func updatePlayer(sessionId:Int, email:String, headline:Int, main1:Int, main2:Int, isShare:Bool, completion:((Any)->())?) {
        
        var getBadges:[Bool] = []
        let lang = Standard.shared.getLocalized()
        let uuid = UUID().uuidString
        
        func isBadge(tag:Int) -> Bool {
            return RealmArticle.shared.get(lang).filter({$0.section == tag}).filter({$0.isCompleted}).count == 9
        }
        
        for i in 1...6 {
            getBadges.append(isBadge(tag: i))
        }
        
        if let userData = RealmUser.shared.getUserData() {
            
            let params:Parameters = ["email":email, "session":sessionId, "language":lang.rawValue, "badge_politics":getBadges[0], "badge_economy":getBadges[1], "badge_general":getBadges[2], "badge_culture":getBadges[3], "badge_sports":getBadges[4], "badge_people":getBadges[5], "score":userData.score, "uid":uuid]
            
            
            Alamofire.request("\(domainUrl)update/player/\(userData.allocatedId)", method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
                switch response.result {
                    
                case .success(let value):
                    
                    print(value)
                    
                    guard let _completion = completion else {return}
                    
                    _completion(value)
                    
                    
                case .failure(let error):
                    
                    guard let _completion = completion else {return}
                    
                    _completion(error.localizedDescription)
                    print(error.localizedDescription)
                    
                }
            }
        }
    }
    
    static func makePDF(email:String, headline:String, main1:String?, main2:String?, others:[String]?, tag:Int, photoId:Int, completion:((Any?)->())?) {
        
        
        guard let user = RealmUser.shared.getUserData() else {return}
        
        let urlComps = NSURLComponents(string: "http://pdf.dmz.wallpeckers.kr/pdf/")!
        var querys:[URLQueryItem] = []
        
        querys.append(URLQueryItem.init(name: "email", value: email.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)))
        querys.append(URLQueryItem.init(name: "lang", value: Standard.shared.getLocalized().rawValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)))
        querys.append(URLQueryItem.init(name: "name", value: user.name!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)))
        querys.append(URLQueryItem.init(name: "head", value: headline.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)))
        
        if let _main1 = main1 {
            querys.append(URLQueryItem.init(name: "main", value: _main1.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)))
        }
        
        if let _main2 = main2 {
            querys.append(URLQueryItem.init(name: "main", value: _main2.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)))

        }
        if let _others = others {
            
            for i in _others {
                 querys.append(URLQueryItem.init(name: "others", value: i.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)))
            }
        }
        
        urlComps.queryItems = querys
        
//        param?

        
        print(urlComps.url!)
        Alamofire.request(urlComps.url!, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
                
            case .success(let value):
                
                print(value)
                
                guard let _completion = completion else {return}
                
                _completion(value)
                
                
            case .failure(let error):
                
                guard let _completion = completion else {return}
                
                _completion(error.localizedDescription)
                print(error.localizedDescription)
                
            }
        }
    }
    
    static func getHashtag(completion:((Any?)->())?){
        
        Alamofire.request("\(domainUrl)article/hashes/", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
                
            case .success(let value):
                                
                guard let _completion = completion else {return}
                
                _completion(value)
                
                
            case .failure(let error):
                
                guard let _completion = completion else {return}
                
                _completion(error.localizedDescription)
                print(error.localizedDescription)
                
            }
        }
        
    }
    
    
    
}
