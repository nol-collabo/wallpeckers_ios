//
//  TopicViewController.swift
//  WallPeckers
//
//  Created by Seongchan Kang on 12/12/2018.
//  Copyright © 2018 KimJimin and Company. All rights reserved.
//

import UIKit

class TopicViewController: GameTransitionBaseViewController {

    let iconWidth = DEVICEHEIGHT > 600 ? 90 : 80
    let iconHeight = DEVICEHEIGHT > 600 ? 180 : 150
    let topicTitleLb = UILabel()
    var timerView:NavigationCustomView?
    let politicsButton = TopicButton()
    let economyButton = TopicButton()
    let generalButton = TopicButton()
    let artButton = TopicButton()
    let sportsButton = TopicButton()
    let peopleButton = TopicButton()
    let selectedLanguage = Standard.shared.getLocalized()
    var sections:[Section]?
    var sectionStars:[Int] = []
    lazy var buttons = [politicsButton, economyButton, generalButton, artButton, sportsButton, peopleButton]

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    
    func setStars() {
        
        sectionStars = []
        
        guard let sections = sections else {return}

        for i in 1...sections.count {
            
            let a = RealmArticle.shared.get(selectedLanguage).filter({
                
                $0.section == i
                
            })
            
            let starCount = a.map({
                
                $0.correctQuestionCount
            }).reduce(0, +)
            
            self.sectionStars.append(starCount)
            
        }
        
        for i in 0...buttons.count - 1 {
            
            buttons[i].setData(title: sections[i].title!, image: UIImage.init(named: "topic\(i + 1)")!, tag: sections[i].id)
            buttons[i].setStar(count: sectionStars[i])
        }
        
        
        
        print(sectionStars)
    }
    
    
    func setUI() {
        self.view.backgroundColor = .basicBackground
        self.setCustomNavigationBar()
        type = GameViewType.topic
        sections = RealmSection.shared.get(selectedLanguage)
        
        self.view.addSubview([topicTitleLb, politicsButton, economyButton, generalButton, artButton, sportsButton, peopleButton])
        
        
        
        
        setStars()
        

        
        politicsButton.delegate = self
        economyButton.delegate = self
        generalButton.delegate = self
        artButton.delegate = self
        sportsButton.delegate = self
        peopleButton.delegate = self
        
        topicTitleLb.setNotoText("CHOOSE A TOPIC", color: .black, size: 24, textAlignment: .center, font: .medium)
        
        topicTitleLb.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeArea.top).offset(70)
            make.height.equalTo(35)
            make.centerX.equalToSuperview()
        }
        
        economyButton.snp.makeConstraints { (make) in
            make.top.equalTo(topicTitleLb.snp.bottom).offset(34)
            make.width.equalTo(iconWidth)
            make.height.equalTo(iconHeight)
            make.centerX.equalToSuperview()
        }
        
        politicsButton.snp.makeConstraints { (make) in
            make.top.equalTo(topicTitleLb.snp.bottom).offset(34)
            make.width.equalTo(iconWidth)
            make.height.equalTo(iconHeight)
            make.trailing.equalTo(economyButton.snp.leading).offset(-25)
        }
        generalButton.snp.makeConstraints { (make) in
            make.top.equalTo(topicTitleLb.snp.bottom).offset(34)
            make.width.equalTo(iconWidth)
            make.height.equalTo(iconHeight)
            make.leading.equalTo(economyButton.snp.trailing).offset(25)
        }
        
        sportsButton.snp.makeConstraints { (make) in
            make.top.equalTo(economyButton.snp.bottom).offset(30)
            make.width.equalTo(iconWidth)
            make.height.equalTo(iconHeight)
            make.centerX.equalToSuperview()
        }
        
        artButton.snp.makeConstraints { (make) in
            make.top.equalTo(economyButton.snp.bottom).offset(30)
            make.width.equalTo(iconWidth)
            make.height.equalTo(iconHeight)
            make.trailing.equalTo(sportsButton.snp.leading).offset(-25)
        }
        
        peopleButton.snp.makeConstraints { (make) in
            make.top.equalTo(economyButton.snp.bottom).offset(30)
            make.width.equalTo(iconWidth)
            make.height.equalTo(iconHeight)
            make.leading.equalTo(sportsButton.snp.trailing).offset(25)
        }
        
        
        
    }

}

extension TopicViewController:TopicButtonDelegate {
    func tap(tag: Int) {
        print("TAG", tag)
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ArticleChooseViewController") as? ArticleChooseViewController else {return}
        
        vc.sectionId = tag
        
        var articleButtons:[ArticleSelectButton] = []
        
        for article in RealmArticle.shared.get(selectedLanguage).filter({
            $0.section == tag
        }) {
            
            let btn = ArticleSelectButton()
            
            let aa = realm.objects(Five_W_One_Hs.self).filter("article = \(article.id)").map({
                
                $0.point
            }).reduce(0, +)
            
//            print(aa)
            
            btn.setData(point: "\(aa)P", textColor: .black, title: article.word!, isStar: false, tag: article.id)
            articleButtons.append(btn)
            
        }
        
        
//        print(articleButtons.count)
        
        vc.setData(localData: nil, articles: RealmArticle.shared.get(selectedLanguage).filter({
            $0.section == tag
        }), articleBtns: articleButtons, articleLinks: RealmArticleLink.shared.getAll())
        
        delegate?.moveTo(fromVc: self, toVc: vc, sendData: tag, direction: .forward)
        
        
//        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    
}

protocol GameViewTransitionDelegate {
    
    func moveTo(fromVc:GameTransitionBaseViewController, toVc:GameTransitionBaseViewController, sendData:Any?, direction:TransitionDirection)
    
}

enum TransitionDirection:String {
    case forward, backward
}

