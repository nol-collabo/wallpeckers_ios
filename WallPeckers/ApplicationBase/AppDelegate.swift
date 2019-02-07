//
//  AppDelegate.swift
//  WallPeckers
//
//  Created by Seongchan Kang on 26/11/2018.
//  Copyright © 2018 KimJimin and Company. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool { //앱이 최초 켜질 때 타이머 시간 확인

        UserDefaults.standard.set(Int(Date().timeIntervalSince1970), forKey: "enterForeground")
        
        let fore = UserDefaults.standard.integer(forKey: "enterForeground")
        let back = UserDefaults.standard.integer(forKey: "enterBackground")
        Standard.shared.gamePlayTime -= (fore - back)
        
        RealmUser.shared.savePlayTime()
        
        
        return true
    }
    
    
    func applicationDidEnterBackground(_ application: UIApplication) { // 앱이 백그라운드로 나갈 시 시간 저장
        RealmUser.shared.savePlayTime()
        UserDefaults.standard.set(Int(Date().timeIntervalSince1970), forKey: "enterBackground")
        print(UserDefaults.standard.integer(forKey: "enterBackground"))

        if let av = self.window?.rootViewController as? UINavigationController {
            
            if let arv = av.viewControllers.filter({$0 is AfterRegisterViewController}).first as? AfterRegisterViewController{
                arv.keyboardResign()
            }
        }
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) { // 앱이 다시 켜질 때 타이머 상의 시간을 갱신함
        
        UserDefaults.standard.set(Int(Date().timeIntervalSince1970), forKey: "enterForeground")
        
        let fore = UserDefaults.standard.integer(forKey: "enterForeground")
        let back = UserDefaults.standard.integer(forKey: "enterBackground")
   
        
        Standard.shared.gamePlayTime -= (fore - back)
        
        RealmUser.shared.savePlayTime()
        
        if let av = self.window?.rootViewController as? UINavigationController {
            
            if let arv = av.viewControllers.filter({$0 is AfterRegisterViewController}).first as? AfterRegisterViewController{
                arv.keyboardResign()
            }
        }
        
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
        
        
    }
    
    func applicationWillTerminate(_ application: UIApplication) { // 앱이 꺼질 때 타이머 상의 시간을 저장
        RealmUser.shared.savePlayTime()
        UserDefaults.standard.set(Int(Date().timeIntervalSince1970), forKey: "enterBackground")
        print(Standard.shared.gamePlayTime)
        
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

