//
//  Standard.swift
//  iOSboilerplate
//
//  Created by Seongchan Kang on 26/11/2018.
//  Copyright © 2018 KimJimin and Company. All rights reserved.
//

import Foundation
import RealmSwift
import Realm
import SwiftyJSON

class Standard {
    
    static let shared = Standard()
    private var sharedTimer:Timer!
    var delegate:GamePlayTimeDelegate?
    var gamePlayTime:Int = 10000 {
        didSet {
            
            delegate?.checkPlayTime(gamePlayTime)

            if gamePlayTime == -1 {
                sharedTimer.invalidate()
                sharedTimer = nil
            }
        }
    }
    
    private init() {}
    
    
    func startTimer(gameMode:GameMode) {
        
//        gamePlayTime = gameMode?
        
        switch gameMode {
            
        case .long:
            gamePlayTime = 1000
        case .short:
            gamePlayTime = 100000
        }
        
        sharedTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (_) in

            self.gamePlayTime -= 1
        })
        
        
    }
    
    func endTimer() {
        
    
        
    }

    
    func changeLocalized(_ countryCode:String) {

        UserDefaults.standard.set(countryCode, forKey: "Language")
        
    }
    func getLocalized() -> Language {
        
        return Language.init(rawValue: UserDefaults.standard.string(forKey: "Language") ?? "ko")!
        
    }
    
 
    func setLanguate() {
        
//        UserDefaults.standard.set
        
    }
    
    
    func getJSON() -> JSON? {
        
        if let path = Bundle.main.path(forResource: "data", ofType: "json") {
            
            
            let data = try! Data.init(contentsOf: URL.init(fileURLWithPath: path), options: .mappedIfSafe)
            
            let json = try! JSON.init(data: data)
            
            return json
            
        }else{
            return nil
        }
        
        
        
    }
    
    func saveData(_ data:Object) {
        
        try! realm.write {
            realm.add(data)
        }
    }
    
    
    
//    func getUser() ->
    
    
}

enum Language:String {
    
    case KOREAN = "ko"
    case GERMAN = "de"
    case ENGLISH = "en"
    
}

//clas

enum GameMode:String {
    case long, short
}

protocol GamePlayTimeDelegate {
    
    func checkPlayTime(_ time:Int)
    
}
