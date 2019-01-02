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
    
    static func saveIncorrect(articleId:Int, playerId:Int, sessionId:Int, clue_type:String,  completion:((Any)->())?) {
        
    }
    
    
}
