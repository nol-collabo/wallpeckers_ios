//
//  Standard.swift
//  iOSboilerplate
//
//  Created by Seongchan Kang on 26/11/2018.
//  Copyright © 2018 KimJimin and Company. All rights reserved.
//

import Foundation


class Standard {
    
    static let shared = Standard()
    
    private init() {
        
    }
    
    func changeLocalized(_ countryCode:String) {
        
        
        
        UserDefaults.standard.set(countryCode, forKey: "Language")
        
    }
    
   
    func getLocalized() -> String {
        return UserDefaults.standard.string(forKey: "Language") ?? "ko"
    }
    
    func addUser(name:String, age:Int) {
        UserDefaults.standard.set(name, forKey: "UserName")
        UserDefaults.standard.set(age, forKey: "UserAge")
    }
    
//    func getUser() ->
    
    
}

enum Language:String {
    
    case KOREAN = "ko"
    case GERMAN = "de"
    case ENGLISH = "en"
    
}

//clas
