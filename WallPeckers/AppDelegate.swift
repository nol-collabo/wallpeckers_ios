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
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        

        
        UserDefaults.standard.set(Int(Date().timeIntervalSince1970), forKey: "enterForeground")
        
        let fore = UserDefaults.standard.integer(forKey: "enterForeground")
        let back = UserDefaults.standard.integer(forKey: "enterBackground")
        Standard.shared.gamePlayTime -= (fore - back)
        
        RealmUser.shared.savePlayTime()
        
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        //        RealmUser.shared.savePlayTime()
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        RealmUser.shared.savePlayTime()
        UserDefaults.standard.set(Int(Date().timeIntervalSince1970), forKey: "enterBackground")
        print(UserDefaults.standard.integer(forKey: "enterBackground"))

        if let av = self.window?.rootViewController as? UINavigationController {
            
            if let arv = av.viewControllers.filter({$0 is AfterRegisterViewController}).first as? AfterRegisterViewController{
                arv.keyboardResign()
            }
        }
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
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
        
        
        
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        RealmUser.shared.savePlayTime()
        UserDefaults.standard.set(Int(Date().timeIntervalSince1970), forKey: "enterBackground")
        print(Standard.shared.gamePlayTime)
        
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

