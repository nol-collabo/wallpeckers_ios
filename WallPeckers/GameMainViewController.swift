//
//  GameMainViewController.swift
//  WallPeckers
//
//  Created by Seongchan Kang on 03/12/2018.
//  Copyright © 2018 KimJimin and Company. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

class GameMainViewController: UIViewController, GameNavigationBarDelegate, GamePlayTimeDelegate, TopicButtonDelegate, AlerPopupViewDelegate {
    
    
    let iconWidth = DEVICEHEIGHT > 600 ? 90 : 80
    let iconHeight = DEVICEHEIGHT > 600 ? 160 : 120
    
    func tapBottomButton(sender: AlertPopUpView) {
        if sender.tag == 1 {

            print("MOVE TO NEXT")
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ResultViewController") as? ResultViewController else {return}
            sender.removeFromSuperview()

            self.navigationController?.pushViewController(vc, animated: true)
            
        }else {
            sender.removeFromSuperview()
        }
    }

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
            
            print(aa)
            
            btn.setData(point: "\(aa)P", textColor: .black, title: article.word!, isStar: false, tag: article.id)
            articleButtons.append(btn)
            
        }
        
        
        print(articleButtons.count)
        
        vc.setData(localData: nil, articles: RealmArticle.shared.get(selectedLanguage).filter({
            $0.section == tag
        }), articleBtns: articleButtons, articleLinks: RealmArticleLink.shared.getAll())
        

        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    
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
   
    @IBOutlet weak var containerView: UIView!
    
    func checkPlayTime(_ time: Int) {

        timerView?.updateTime(time)
        
        if time == 0 { //완료 됐을떄

            PopUp.callAlert(time: "00:00", desc: "완료", vc: self, tag: 1)
            print("END!")

        }else if time == 60 { // 1분 남았을 때
            PopUp.callAlert(time: "01:00", desc: "1분", vc: self, tag: 2)

            print("1minute!")

        }
    }

    func touchMoveToMyPage(sender: UIButton) {
        sender.isUserInteractionEnabled = false
        
        guard let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyPageViewController") as? MyPageViewController else {return}
        sender.isUserInteractionEnabled = true
        
        self.present(vc, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setUI()
        
        
        self.timerView = self.findTimerView()
     
        Standard.shared.startTimer(gameMode: .short)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Standard.shared.delegate = self
    }
    
    func setUI() {
        self.view.backgroundColor = .basicBackground
        self.setCustomNavigationBar()

        sections = RealmSection.shared.get(selectedLanguage)
        
        self.view.addSubview([topicTitleLb, politicsButton, economyButton, generalButton, artButton, sportsButton, peopleButton])

        
        let buttons = [politicsButton, economyButton, generalButton, artButton, sportsButton, peopleButton]
        
        guard let sections = sections else {return}

        for i in 0...buttons.count - 1 {
            
            buttons[i].setData(title: sections[i].title!, image: UIImage.init(named: "topic\(i + 1)")!, tag: sections[i].id)
        }
      
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
    
    func findTimerView() {
        if let vv = self.view.subviews.filter({
            
            $0 is GameNavigationBar
            
        }).first as? GameNavigationBar {
            if let _timerView = vv.subviews.filter({
                
                $0.tag == 99
                
            }).first as? NavigationCustomView {
                self.timerView = _timerView
            }
        }
    }
}

