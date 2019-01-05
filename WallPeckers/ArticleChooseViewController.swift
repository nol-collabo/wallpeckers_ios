//
//  ArticleChooseViewController.swift
//  WallPeckers
//
//  Created by Seongchan Kang on 07/12/2018.
//  Copyright © 2018 KimJimin and Company. All rights reserved.
//

import UIKit
import RealmSwift
import Realm

let iconWidth = DEVICEHEIGHT > 600 ? 93 : 85

class ArticleChooseViewController: GameTransitionBaseViewController, AlerPopupViewDelegate, ArticleSelectDelegate, CallBadgeDelegate {

    
    func callCompleteBadge(tag: Int) {
        
        if let badge = RealmSection.shared.get(selectedLanguage).filter({$0.id == tag}).first?.badge {
            
            if RealmArticle.shared.get(selectedLanguage).filter({$0.section == tag}).filter({$0.isCompleted}).count == 9 {
                
                PopUp.levelBadgePopup(type: .badge, title:String(format:"getBadge".localized, badge), image: UIImage.init(named: "getBadge\(tag)")!, tag: 10, vc: self)
            }
        }
    }
    
    
    var firstLevelUp:Bool = UserDefaults.standard.bool(forKey: "firstLevelUp")
    var secondLevelUp:Bool = UserDefaults.standard.bool(forKey: "secondLevelUp")
    var thirdLevelUp:Bool = UserDefaults.standard.bool(forKey: "thirdLevelUp")
    var fourthLevelUp:Bool = UserDefaults.standard.bool(forKey: "fourthLevelUp")
    let selectedLanguage = Standard.shared.getLocalized()

    
    func callLevelPopUp(topic:Int) {
        
        if let score = RealmUser.shared.getUserData()?.score {
            
            let level = RealmLevel.shared.get(selectedLanguage).sorted(by: {$0.id < $1.id})
            
            if score >= 2000 && score < 4000{
                if !firstLevelUp {
                    PopUp.levelBadgePopup(type: .level, title: String(format:"levelup".localized, level[1].grade!), image: UIImage.init(named: "level35")!, tag: topic, vc: self)
                    firstLevelUp = true
                    UserDefaults.standard.set(true, forKey: "firstLevelUp")
                }
            }else if score >= 4000 && score < 8000 {
                if !secondLevelUp {
                    PopUp.levelBadgePopup(type: .level, title: String(format:"levelup".localized, level[2].grade!), image: UIImage.init(named: "level36")!, tag: topic, vc: self)
                    secondLevelUp = true
                    UserDefaults.standard.set(true, forKey: "secondLevelUp")
                    
                }
            }else if score >= 8000 && score < 12000 {
                if !thirdLevelUp {
                    PopUp.levelBadgePopup(type: .level, title: String(format:"levelup".localized, level[3].grade!), image: UIImage.init(named: "level37")!, tag: topic, vc: self)
                    thirdLevelUp = true
                    UserDefaults.standard.set(true, forKey: "thirdLevelUp")
                    
                }
            }else if score >= 12000 {
                if !fourthLevelUp {
                    PopUp.levelBadgePopup(type: .level, title: String(format:"levelup".localized, level[4].grade!), image: UIImage.init(named: "level38")!, tag: topic, vc: self)
                    fourthLevelUp = true
                    UserDefaults.standard.set(true, forKey: "fourthLevelUp")
                    
                }
            }
        }
        
        if let popupEmpty = self.parent?.view.subviews.filter({$0 is LevelBadgePopUpView}).isEmpty {
            
            
            if popupEmpty {
                if let badge = RealmSection.shared.get(selectedLanguage).filter({$0.id == topic}).first?.title {
                    
                    print(badge)
                    print("~~~")
                    
                    if RealmArticle.shared.getAll().filter({$0.section == topic}).filter({$0.isCompleted}).count == 9 {
                        
                        PopUp.levelBadgePopup(type: .badge, title:String(format:"getBadge".localized, badge), image: UIImage.init(named: "getBadge\(topic)")!, tag: 10, vc: self)
                    }
                }
            }
        }
    }

    let topConstraint = DeviceSize.width > 320 ? 30 : 20
    
    func tapArticle(sender: ArticleSelectButton) {
        
        func moveToArticlePage() {
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ClueSelectViewController") as? ClueSelectViewController else {return}
            
            if let ar = articles?.filter({
                
                $0.id == sender.tag
                
            }).first {
                
                let a = Array(realm.objects(Five_W_One_Hs.self).filter("article = \(sender.tag)"))
                
                let sendingData = (ar, a, sender.pointTitleLb.text!)
                delegate?.moveTo(fromVc: self, toVc: vc, sendData: sendingData, direction: .forward)
                
                
            }
        }
        
        
        let myList = Array((RealmUser.shared.getUserData()?.factCheckList)!)
        
        
        if myList.count == 0 {
            moveToArticlePage()
        }
        
        if let ar = articles?.filter({$0.id == sender.tag}).first {
            
            if ar.isCompleted {
                
                let sendingData = (ar, ar.selectedHashtag, Array(ar.wrongQuestionsId), false)
                
                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "CompleteArticleViewController") as? CompleteArticleViewController else {return}
                
                delegate?.moveTo(fromVc: self, toVc: vc, sendData: sendingData, direction: .forward)
                
            }else{
                moveToArticlePage()

            }
            
        }

    }
    
    func tapBottomButton(sender: AlertPopUpView) {
        if sender.tag == 1 {
            
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ResultViewController") as? ResultViewController else {return}
            
            sender.removeFromSuperview()

            self.navigationController?.pushViewController(vc, animated: true)
            
                        }else {
            sender.removeFromSuperview()
        }
    }
    
    var factCheckList:[FactCheck] = [] {
        didSet {
            self.changeColor()
        }
    }
    var links:[ArticleLinkLine] = []
    var timerView:NavigationCustomView?
    let backButton = UIButton()
    let articleTitleLb = UILabel()
    var sectionId:Int = 0
    var articles:[Article]?
    var articleLinks:[ArticleLink]?
    var localArticleLinks:Results<LocalArticleLink>?
    var localArticles:Results<LocalArticle>?
    
    var articleButtons:[ArticleSelectButton] = []
    let infoLb = UILabel()
    
    func touchMoveToMyPage(sender: UIButton) {
        sender.isUserInteractionEnabled = false
        guard let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyPage") as? UINavigationController else {return}
        sender.isUserInteractionEnabled = true
        
        self.present(vc, animated: true, completion: nil)
        
    }
    
    func setData(localData:Results<LocalArticle>?, articles:[Article], articleBtns:[ArticleSelectButton], articleLinks:[ArticleLink]) {
        
        self.localArticles = localData
        self.articles = articles
        self.articleButtons = articleBtns
        self.articleLinks = articleLinks
        
    }
    
    func drawLine() {
        
        var ids:[Int] = []
        for ar in articles! {
             ids.append(ar.id)
        }
  
        var filtered:[ArticleLink] = []
        
        for al in self.articleLinks! {
            
            for id in ids {
                
                if al.articles.contains(id) {
                    filtered.append(al)
                }
            }
        }
        
        let removeDuplicated = Array(Set(filtered)).sorted(by: {
            
            $0.id < $1.id
        })
        
        for i in removeDuplicated {
            
            let line = ArticleLinkLine()
            let color = LineColor.init(rawValue: i.color!)
            
            if let left = articleButtons.filter({
                $0.tag == i.articles[0]
            }).first, let right = articleButtons.filter({
                $0.tag == i.articles[1]
            }).first {
                line.setLine(color: color!, leftButton: left, rightButton: right, vc: self)

                links.append(line)
            }

        }

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        factCheckList = Array(RealmUser.shared.getUserData()?.factCheckList ?? List<FactCheck>())

    }
    
    func changeColor() {
        
        print(factCheckList)
        print("CHECK")


        _ = articles?.map({
            
            ar in
            
            factCheckList.map({
                
                fact in
                
                if fact.selectedArticleId == ar.id {
                    
                    _ = articleButtons.map({
                    
                        btn in
                        
                        if btn.tag == ar.id {
                            _ = links.map({
                                
                                if btn.tag == $0.leftTag || btn.tag == $0.rightTag {
                                    if fact.isSubmit {
                                        
                                        btn.backgroundColor = $0.backgroundColor
                                        btn.pointTitleLb.textColor = UIColor.white
                                        btn.titleLb.textColor = UIColor.white
                                        btn.starImageView.isHidden = false
                                    }else{
                                        btn.backgroundColor = $0.backgroundColor?.withAlphaComponent(0.5)

                                    }
                                }
                                
                                
                            })
                        }
                    })
                }
            })
        })
    }
    

    private func setUI() {
        self.view.backgroundColor = .basicBackground
        type = GameViewType.article
        backButton.setImage(UIImage.init(named: "backButton")!, for: .normal)
        self.view.addSubview(backButton)
        self.view.addSubview(articleTitleLb)
        self.view.addSubview(infoLb)
        backButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(40)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(DeviceSize.width > 320 ? -60 : -25)
        }
        
        
        
        
        articleTitleLb.setNotoText("selectarticle_title".localized, color: .black, size: 24, textAlignment: .center, font: .medium)
                
        articleTitleLb.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeArea.top).offset(70)
            make.height.equalTo(35)
            make.centerX.equalToSuperview()
        }
        
        for i in articleButtons {
            self.view.addSubview(i)

            i.delegate = self
        }
        
        articleButtons[1].snp.makeConstraints { (make) in
            make.top.equalTo(articleTitleLb.snp.bottom).offset(topConstraint)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(iconWidth)
        }

        articleButtons[0].snp.makeConstraints { (make) in
            make.top.equalTo(articleTitleLb.snp.bottom).offset(topConstraint)
            make.width.height.equalTo(iconWidth)
            make.trailing.equalTo( articleButtons[1].snp.leading).offset(-25)
            
        }
        articleButtons[2].snp.makeConstraints { (make) in
            make.top.equalTo(articleTitleLb.snp.bottom).offset(topConstraint)
            make.width.height.equalTo(iconWidth)
            make.leading.equalTo( articleButtons[1].snp.trailing).offset(25)
        }
        articleButtons[4].snp.makeConstraints { (make) in
            make.top.equalTo(articleButtons[1].snp.bottom).offset(topConstraint)
            make.width.height.equalTo(iconWidth)
            make.centerX.equalToSuperview()
        }
        articleButtons[3].snp.makeConstraints { (make) in
            make.top.equalTo(articleButtons[1].snp.bottom).offset(topConstraint)
            make.width.height.equalTo(iconWidth)
            make.trailing.equalTo( articleButtons[4].snp.leading).offset(-25)
        }
        articleButtons[5].snp.makeConstraints { (make) in
            make.top.equalTo(articleButtons[1].snp.bottom).offset(topConstraint)
            make.width.height.equalTo(iconWidth)
            make.leading.equalTo(articleButtons[4].snp.trailing).offset(25)
        }
        articleButtons[7].snp.makeConstraints { (make) in
            make.top.equalTo(articleButtons[4].snp.bottom).offset(topConstraint)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(iconWidth)
        }
        articleButtons[6].snp.makeConstraints { (make) in
            make.top.equalTo(articleButtons[4].snp.bottom).offset(topConstraint)
            make.width.height.equalTo(iconWidth)
            make.trailing.equalTo(articleButtons[7].snp.leading).offset(-25)
            
        }
        
        articleButtons[8].snp.makeConstraints { (make) in
            make.top.equalTo(articleButtons[4].snp.bottom).offset(topConstraint)
            make.width.height.equalTo(iconWidth)
            make.leading.equalTo(articleButtons[7].snp.trailing).offset(25)
            
        }
        
        infoLb.snp.makeConstraints { (make) in
            make.top.equalTo(articleButtons[8].snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.left.equalTo(10)
        }
        infoLb.numberOfLines = 0
        infoLb.attributedText = "selectarticle_desc".localized.makeAttrString(font: .NotoSans(.medium, size: 16), color: .black)
        infoLb.adjustsFontSizeToFitWidth = true
        infoLb.textAlignment = .center
        backButton.addTarget(self, action: #selector(back(sender:)), for: .touchUpInside)
        
        drawLine()
    }
    
    @objc func back(sender:UIButton) {
        
        sender.isUserInteractionEnabled = false
        
        guard let vc = self.findBeforeVc(type: .topic) else {return}

     
        delegate?.moveTo(fromVc: self, toVc: vc, sendData: nil, direction: .backward)
        
        
        sender.isUserInteractionEnabled = true
        
    }
}



enum ArticleCompleteStatus:String {
    
    case submit, justcheck, normal
    
}


enum LineColor:String {
    
    case BLUE, RED, ORANGE, GREEN
    
}

enum GameViewType:String {
    
    case topic, article, clue, factCheck, newspaper
    
}
