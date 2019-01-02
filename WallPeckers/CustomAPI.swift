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
    
}
