//
//  StartViewController.swift
//  WallPeckers
//
//  Created by Seongchan Kang on 26/11/2018.
//  Copyright © 2018 KimJimin and Company. All rights reserved.
//

import UIKit
import SnapKit
import RealmSwift
import SwiftyJSON

class StartViewController: UIViewController {

    let titleImv = UIImageView()
    let descScrollView = BaseHorizontalScrollView()
    let desc1View = UIImageView()
    let desc2View = UIImageView()
    let goetheView = UIImageView()
    let nolgongView = UIImageView()
    let playButton = UIButton()
    var selectedLanguage:Int?
    let user = realm.objects(User.self)
    var animatedTimer:Timer?
    
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()

        
        transformToRealm { (_) in
            
            self.setUI()
            
        }
        
    }
    
    func transformToRealm(completion:((Any)->())) {
        
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
                
                completion(UserDefaults.standard.set(true, forKey: "databaseTransformComplete"))
            }
            
        }else{
            completion("Already")
            print(realm.configuration.fileURL ?? "")
        }
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        animatedTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { (_) in
            self.animatedTitleImage()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let timer = animatedTimer {
            timer.invalidate()
        }
        animatedTimer = nil
       
//        animatedTimer = ni
    }
    
    func animatedTitleImage() {
        
        if self.descScrollView.scrollView.contentOffset.x  == 0 {
            UIView.animate(withDuration: 0.3) {
                self.descScrollView.scrollView.contentOffset.x = self.descScrollView.scrollView.frame.width
            }
        }else{
            UIView.animate(withDuration: 0.3) {
                self.descScrollView.scrollView.contentOffset.x = 0
            }
        }
        
//        animatedTitleImage()
    }
    

    
    
    private func setUI() {
        
        self.view.addSubview([playButton, titleImv, nolgongView, goetheView])
        self.view.backgroundColor = UIColor.basicBackground
        

        self.navigationController?.isNavigationBarHidden = true
        playButton.backgroundColor = .black
        playButton.setAttributedTitle("selectlanguage_playbtn".localized.makeAttrString(font: .NotoSans(.bold, size: 30), color: .white), for: .normal)
        playButton.addTarget(self, action: #selector(playBtnTouched(sender:)), for: .touchUpInside)
        
        titleImv.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeArea.top).offset(33)
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview()
            make.height.equalTo(150)
        }
        titleImv.image = UIImage.init(named: "MainTitleImv")!
        titleImv.contentMode = .scaleAspectFit
        descScrollView.setScrollViewMiddle(vc: self)
        descScrollView.scrollView.isUserInteractionEnabled = false
        descScrollView.contentView.addSubview([desc2View, desc1View])
        descScrollView.isUserInteractionEnabled = false
        
        desc1View.snp.makeConstraints { (make) in
            make.height.equalToSuperview()
            make.width.equalTo(DeviceSize.width)
            make.leading.top.equalToSuperview()
        }
        desc2View.snp.makeConstraints { (make) in
            make.leading.equalTo(desc1View.snp.trailing)
            make.width.equalTo(DeviceSize.width)
            make.trailing.equalToSuperview()
            make.height.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        playButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.safeArea.bottom).offset(-50)
            make.leading.equalTo(55)
            make.centerX.equalToSuperview()
            make.height.equalTo(56)
        }
        
        goetheView.snp.makeConstraints { (make) in

            make.leading.equalTo(80)
            make.width.equalTo(53)
            make.height.equalTo(25)
            make.bottom.equalTo(view.safeArea.bottom).offset(-7)
        }
        nolgongView.snp.makeConstraints { (make) in
            
            make.trailing.equalTo(-80)
            make.width.equalTo(77)
            make.height.equalTo(17)
            make.bottom.equalTo(view.safeArea.bottom).offset(-12)
        }
        
        desc1View.image = UIImage.init(named: "MainDescImv1")
        desc2View.image = UIImage.init(named: "MainDescImv2")
        goetheView.image = UIImage.init(named: "goethe")
        nolgongView.image = UIImage.init(named: "nolgong")
        
        
        
    }
    
    @objc func playBtnTouched(sender:UIButton) {
        
        PopUp.call(mainTitle: "LANGUAGE", selectButtonTitles: ["Deutsch","한국어","English"], bottomButtonTitle: "OK", bottomButtonType: 0, self, buttonImages: [UIImage.init(named: "languageDeBlack")!, UIImage.init(named: "languageKrBlack")!, UIImage.init(named: "languageEnBlack")!])
    }

}


extension StartViewController:SelectPopupDelegate {
    func bottomButtonTouched(sender: UIButton) {
        
        if let _ = selectedLanguage {

            if user.count > 0 { // 유저정보 있을 떄
                
                if let _ = RealmUser.shared.getUserData() {
                    
                    if !UserDefaults.standard.bool(forKey: "Playing") { //플레이 기록 없을때
                        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "AfterRegisterViewController") as? AfterRegisterViewController else {return}
                        
                        self.navigationController?.pushViewController(vc, animated: true)
                    }else{ // 한문제 이상 풀어서 이어하기 선택 가능할 때

                        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "AlreadyRegisterViewController") as? AlreadyRegisterViewController else {return}
                        
                        
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }

            }else{ // 신규유저
                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as? RegisterViewController else {return}
                
                self.navigationController?.pushViewController(vc, animated: true)
            }

        }else{
            print("언어를 선택해주세요")
        }
    }
    
    func selectButtonTouched(tag: Int) {
        selectedLanguage = tag
        
        if tag == 0 {
            Standard.shared.changeLocalized(Language.GERMAN.rawValue)
            
            UserDefaults.standard.set([Language.GERMAN.rawValue], forKey: "AppleLanguages")
            UserDefaults.standard.synchronize()


        }else if tag == 1 {
            UserDefaults.standard.set([Language.KOREAN.rawValue], forKey: "AppleLanguages")
            UserDefaults.standard.synchronize()

            Standard.shared.changeLocalized(Language.KOREAN.rawValue)

        }else {
            Standard.shared.changeLocalized(Language.ENGLISH.rawValue)
            UserDefaults.standard.set([Language.ENGLISH.rawValue], forKey: "AppleLanguages")
            UserDefaults.standard.synchronize()
        }

        
    }

}


