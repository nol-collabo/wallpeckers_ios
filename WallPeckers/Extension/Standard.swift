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
    var gamePlayTime:Int = RealmUser.shared.getUserData()?.playTime ?? 1200 {
        didSet {
            
            delegate?.checkPlayTime(gamePlayTime)

            if gamePlayTime <= 0 {
                if sharedTimer != nil {
                    sharedTimer.invalidate()
                    sharedTimer = nil
                }
            }
        }
    }
    
    private init() {}
    
    
    func timerInit(inputCode:String) {
        
        let enPressCodes:[String] = ["peace", "sunshine", "treaty", "agreement", "relations", "highway", "travel", "cow", "march", "border", "evolution", "threat", "deal", "monday", "immediately", "leeway", "emotion", "heroes", "resistance", "revival" ,"joy", "tie", "dream","freedom","bullet", "blood","love", "basement", "memories", "escape"]
        let dePressCodes:[String] = ["frieden", "sonnenschein", "vereinbarung", "einigung", "beziehungen", "weg", "reise", "rinder", "marsch", "grenze", "entwicklung", "bedrohung", "handel", "montag", "sofort", "spalt", "ergriffenheit", "helden", "widerstand", "wiederbelebung" ,"begeisterung", "gleichstand", "traum","freiheit","kugel", "blut","liebe", "keller", "gedenken", "flucht"]
        
        
        print(inputCode)
        print("~~~~")
        
        if enPressCodes.contains(inputCode.lowercased()) {
            if let playTime = RealmUser.shared.getUserData()?.playTime {
                if playTime != 0 {
                    gamePlayTime = playTime
                }else{
                    gamePlayTime = 1800
                }
            }else{
                gamePlayTime = 1800
            }
        }
        
        if dePressCodes.contains(inputCode.lowercased()) {
            if let playTime = RealmUser.shared.getUserData()?.playTime {
                if playTime != 0 {
                    gamePlayTime = playTime
                }else{
                    gamePlayTime = 1800
                }
            }else{
                gamePlayTime = 1800
            }
        }
        
        
        switch inputCode.lowercased() {
            
        case "2", "5", "60" :

            if let playTime = RealmUser.shared.getUserData()?.playTime {
                if playTime != 0 {
                    gamePlayTime = playTime
                }else{
                    gamePlayTime = Int(inputCode)! * 60
                }
            }else{
                gamePlayTime = Int(inputCode)! * 60
            }
            
            
            
        case "berlin", "wall", "dmz", "dorasan":
            
            if let playTime = RealmUser.shared.getUserData()?.playTime {
                if playTime != 0 {
                    gamePlayTime = playTime
                }else{
                    gamePlayTime = 1200
                }
            }else{
                gamePlayTime = 1200
            }
  
        default :
            
            print("default")
            
        }
        
        sharedTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (_) in
            
            self.gamePlayTime -= 1
        })
        
        
    }
    
    
//    func startTimer(gameMode:GameMode) {
//        
//        switch gameMode {
//            
//        case .long:
//            gamePlayTime = 1800
//        case .short:
//            if let playTime = RealmUser.shared.getUserData()?.playTime {
//                if playTime != 0 {
//                    gamePlayTime = playTime
//                }else{
//                    gamePlayTime = 500
//                }
//            }else{
//                gamePlayTime = 500
//            }
//        }
//        
//        sharedTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (_) in
//
//            self.gamePlayTime -= 1
//        })
//        
//        
//    }
    
    func changeLocalized(_ countryCode:String) {

        UserDefaults.standard.set(countryCode, forKey: "Language")
        
    }
    
    func getLocalized() -> Language {
        
        return Language.init(rawValue: UserDefaults.standard.string(forKey: "Language") ?? "ko")!
        
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
    
}

enum Language:String {
    
    case KOREAN = "ko"
    case GERMAN = "de"
    case ENGLISH = "en"
    
}

enum GameMode:String {
    case long, short
}

protocol GamePlayTimeDelegate {
    
    func checkPlayTime(_ time:Int)
    
}
