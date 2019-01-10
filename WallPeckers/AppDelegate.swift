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
        
        if let statusBar = UIApplication.shared.value(forKey: "statusBar") as? UIView {
            statusBar.backgroundColor = UIColor.basicBackground
        }
        
        UserDefaults.standard.set(Int(Date().timeIntervalSince1970), forKey: "enterForeground")
        
        let fore = UserDefaults.standard.integer(forKey: "enterForeground")
        let back = UserDefaults.standard.integer(forKey: "enterBackground")
        Standard.shared.gamePlayTime -= (fore - back)
        
        RealmUser.shared.savePlayTime()
        
        
        if !UserDefaults.standard.bool(forKey: "databaseTransformComplete") {
            
            if let data = Standard.shared.getJSON() {
                
                let levels = data["level"].arrayValue
                let sections = data["sections"].arrayValue
                let clues = data["clues"].arrayValue
                let gameArticleLinks = data["article_link"].arrayValue
                let gameArticles = data["articles"].arrayValue
                let ages = data["age"].arrayValue
                let localClues = data["locale"]["clues"].arrayValue
                let localLevels = data["locale"]["level"].arrayValue
                let localSections = data["locale"]["sections"].arrayValue
                let localAges = data["locale"]["age"].arrayValue
                let localArticles = data["locale"]["articles"].arrayValue
                let localArticleLinks = data["locale"]["article_link"].arrayValue
                let localLanguages = data["locale"]["language"].arrayValue
                let five_w_one_hs = data["five_w_one_h"].arrayValue
                
                
                _ = five_w_one_hs.map({
                    
                    let fv = Five_W_One_Hs($0)
                    
                    Standard.shared.saveData(fv)
                    
                })
                
                _ = localArticles.map({
                    
                    let lar = LocalArticle($0)
                    
                    Standard.shared.saveData(lar)
                })
                
                _ = localArticleLinks.map({
                    
                    let lal = LocalArticleLink($0)
                    
                    Standard.shared.saveData(lal)
                    
                })
                
                _ = localLanguages.map({
                    
                    let langu = LocalLanguage($0)
                    
                    Standard.shared.saveData(langu)
                })
                
                _ = levels.map({
                    
                    let lvl = Level($0)
                    
                    Standard.shared.saveData(lvl)
                    
                })
                
                _ = localLevels.map({
                    
                    let lolvl = LocalLevel($0)
                    
                    Standard.shared.saveData(lolvl)
                })
                
                _ = sections.map({
                    
                    let section = Section($0)
                    
                    Standard.shared.saveData(section)
                    
                })
                
                _ = localSections.map({
                    
                    let locals = LocalSection($0)
                    
                    Standard.shared.saveData(locals)
                })
                
                _ = clues.map({
                    
                    let clue = Clue($0)
                    
                    Standard.shared.saveData(clue)
                })
                
                _ = localClues.map({
                    
                    let lc = LocalClue($0)
                    Standard.shared.saveData(lc)
                })
                
                _ = gameArticleLinks.map({
                    
                    let gal = ArticleLink($0)
                    
                    Standard.shared.saveData(gal)
                })
                
                _ = gameArticles.map({
                    
                    let ga = Article($0)
                    
                    Standard.shared.saveData(ga)
                    
                })
                
                _ = ages.map({
                    
                    let age = Age($0)
                    
                    Standard.shared.saveData(age)
                    
                })
                
                _ = localAges.map({
                    
                    let lage = LocalAge($0)
                    Standard.shared.saveData(lage)
                })
                
                UserDefaults.standard.set(true, forKey: "databaseTransformComplete")
            }
            
        }else{
            print(realm.configuration.fileURL ?? "")
        }
        
        
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
//        application.
//        application.
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
        UserDefaults.standard.set(Int(Date().timeIntervalSince1970), forKey: "enterForeground")
        
        let fore = UserDefaults.standard.integer(forKey: "enterForeground")
        let back = UserDefaults.standard.integer(forKey: "enterBackground")
   
        
        Standard.shared.gamePlayTime -= (fore - back)
        
        RealmUser.shared.savePlayTime()
        
        
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

