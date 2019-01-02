//
//  POPAPI.swift
//  WallPeckers
//
//  Created by Seongchan Kang on 02/01/2019.
//  Copyright © 2019 KimJimin and Company. All rights reserved.
//

import Foundation
import Alamofire

protocol APIProtocol {
    
    func get(url:String, completion:((Any?)->())?)
    
}

struct POPAPI:APIProtocol {
 
    func get(url: String, completion: ((Any?) -> ())?) {
     
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
                
            case .success(let value):
                
                completion!(value)
                
            case .failure(let error):
                
                completion!(error.localizedDescription)
                
            }
        }
    }
}
