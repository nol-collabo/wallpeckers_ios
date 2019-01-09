//
//  GameViewController.swift
//  WallPeckers
//
//  Created by Seongchan Kang on 12/12/2018.
//  Copyright © 2018 KimJimin and Company. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

class GameViewController: UIViewController {
    
    let selectedLanguage = Standard.shared.getLocalized()
    var timerView:NavigationCustomView?
    var scoreView:NavigationCustomView?
    let horizontalView = BaseHorizontalScrollView()
    let topicView = UIView()
    let articleView = UIView()
    let clueSelectView = UIView()
    let factCheckView = UIView()
    let articleResultView = UIView()
    let topicViewController = UIStoryboard.init(name: "Game", bundle: nil).instantiateViewController(withIdentifier: "TopicViewController") as! TopicViewController
    var inputCode:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        horizontalView.setScrollView(vc: self)
        self.setCustomNavigationBar()
        setUI()
        addChildVc()
        self.timerView = self.findTimerView()
        self.scoreView = self.findScoreView()
        Standard.shared.delegate = self
        Standard.shared.timerInit(inputCode: inputCode)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setScore()
    }
    
    func setScore() {
        scoreView?.textLb.attributedText = "\(RealmUser.shared.getUserData()!.score) P".makeAttrString(font: .NotoSans(.bold, size: 14), color: .black)
    }
    
    private func setUI() {
        
        self.view.backgroundColor = .basicBackground
        horizontalView.contentView.addSubview([topicView, articleView, clueSelectView, factCheckView, articleResultView])
        
        topicView.snp.makeConstraints { (make) in
            make.top.leading.bottom.equalToSuperview()
            make.width.equalTo(DeviceSize.width)
        }
        articleView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(topicView.snp.trailing)
            make.width.equalTo(DeviceSize.width)
        }
        clueSelectView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(articleView.snp.trailing)
            make.width.equalTo(DeviceSize.width)
        }
        factCheckView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(clueSelectView.snp.trailing)
            make.width.equalTo(DeviceSize.width)
        }
        articleResultView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(factCheckView.snp.trailing)
            make.width.equalTo(DeviceSize.width)
            make.trailing.equalToSuperview()
        }
        topicView.backgroundColor = .red
        articleView.backgroundColor = .blue
        topicView.addSubview(topicViewController.view)
        topicViewController.delegate = self
        topicViewController.view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        horizontalView.scrollView.isScrollEnabled = false
    }
    
    func addChildVc() {
        for v in [topicViewController] {
            addChild(v)
        }
    }
}

extension GameViewController:GamePlayTimeDelegate, GameNavigationBarDelegate, AlerPopupViewDelegate {
    func tapBottomButton(sender: AlertPopUpView) {
        
        if sender.tag == 2 {
            sender.removeFromSuperview()
        }else{
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ResultViewController") as? ResultViewController else {return}
            RealmUser.shared.savePlayTime()
            sender.removeFromSuperview()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    
    func touchMoveToMyPage(sender: UIButton) {
        sender.isUserInteractionEnabled = false
        
        guard let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyPage") as? UINavigationController else {return}
        
        if let mvc = vc.viewControllers.first as? MyPageViewController {
            
            mvc.fromGame = true
        }
        
        sender.isUserInteractionEnabled = true
        
        self.present(vc, animated: true, completion: nil)
    }
    
    func checkPlayTime(_ time: Int) {
        
        timerView?.updateTime(time)
        if time <= 0 { //완료 됐을떄
            
            PopUp.callAlert(time: "00:00", desc: "timedialog_timeend".localized, vc: self, tag: 1)
            
        }else if time == 300 { // 1분 남았을 때
            PopUp.callAlert(time: "05:00", desc: String(format:"timedialog_timelimit".localized, "5"), vc: self, tag: 2)
            
        }else if time == 120 {
            PopUp.callAlert(time: "02:00", desc: String(format:"timedialog_timelimit".localized, "2"), vc: self, tag: 2)
        }
        
    }
    
    
}

extension GameViewController:GameViewTransitionDelegate {
    
    func moveTo(fromVc: GameTransitionBaseViewController, toVc: GameTransitionBaseViewController, sendData: Any?, direction:TransitionDirection) {
        
        switch direction {
            
        case .forward:
            
            if let vc = toVc as? CompleteArticleViewController {
                
                guard let _sendData = sendData as? (Article, Int, [Int], Bool) else {return}
                
                vc.setData(article: _sendData.0, hashTag: _sendData.1, wrongIds:_sendData.2)
                vc.isCompletedFirst = _sendData.3
                self.setChildVc(rootView: articleResultView, vc)
                
                horizontalView.scrollView.setContentOffset(CGPoint.init(x: DeviceSize.width * 4, y: horizontalView.scrollView.contentOffset.y), animated: true)
                
            }
            
            if let vc = toVc as? FactCheckViewController {
                
                guard let _sendData = sendData as? ([FactCheck], Article, [Five_W_One_Hs], String) else {return}
                vc.setData(_sendData.0, article: _sendData.1, five: _sendData.2, questionPoint: _sendData.3)
                self.setChildVc(rootView: factCheckView, vc)
                clueSelectView.subviews.first?.removeFromSuperview()
                horizontalView.scrollView.setContentOffset(CGPoint.init(x: DeviceSize.width * 3, y: horizontalView.scrollView.contentOffset.y), animated: true)
            }
            
            if let vc = toVc as? ArticleChooseViewController {
                
                var articleButtons:[ArticleSelectButton] = []
                
                for article in RealmArticle.shared.get(selectedLanguage).filter({
                    $0.section == sendData as! Int
                }) {
                    
                    let btn = ArticleSelectButton()
                    
                    let aa = realm.objects(Five_W_One_Hs.self).filter("article = \(article.id)").map({
                        
                        $0.point
                    }).reduce(0, +)
                    
                    vc.changeColor()
                    btn.setData(point: "\(aa)P", textColor: .black, title: article.word!, isStar: article.isCompleted, tag: article.id)
                    articleButtons.append(btn)
                    
                }
                
                vc.setData(localData: nil, articles: RealmArticle.shared.get(selectedLanguage).filter({
                    $0.section == sendData as! Int
                }), articleBtns: articleButtons, articleLinks: RealmArticleLink.shared.getAll())
                
                
                self.setChildVc(rootView: articleView, vc)
                
                horizontalView.scrollView.setContentOffset(CGPoint.init(x: DeviceSize.width, y: horizontalView.scrollView.contentOffset.y), animated: true)
            }
            
            
            if let vc = toVc as? ClueSelectViewController {
                
                let data = sendData as! (Article, [Five_W_One_Hs], String)
                
                
                vc.setData(article: data.0, five: data.1)
                vc.questionPoint = data.2
                self.setChildVc(rootView: clueSelectView, vc)
                horizontalView.scrollView.setContentOffset(CGPoint.init(x: DeviceSize.width * 2, y: horizontalView.scrollView.contentOffset.y), animated: true)
            }
            
        case .backward:
            fromVc.removeFromParent()
            
            if let fvc = fromVc as? CompleteArticleViewController {
                
                
                if let vc = toVc as? TopicViewController {
                    
                    _ = articleView.subviews.map({$0.removeFromSuperview()})

                    let sectionTag = sendData as! Int
                    
                    if fvc.isCompletedFirst {
                        vc.callLevelPopUp(topic: sectionTag)
                    }
                    
                    vc.setStars()
                    vc.view.layoutIfNeeded()
                    vc.view.layoutSubviews()
                    horizontalView.scrollView.setContentOffset(CGPoint.init(x: 0, y: horizontalView.scrollView.contentOffset.y), animated: false)
                    
                }
                
                if let vc = toVc as? ArticleChooseViewController {

                    _ = articleView.subviews.map({$0.removeFromSuperview()})
                    
                    print(articleView.subviews)
                    print("ARTICLESUBVIEWLIST")
                    let sectionTag = sendData as! Int

                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
                        
                        if fvc.isCompletedFirst {
                            vc.callLevelPopUp(topic: sectionTag)
                        }
                        
                        self.setArticleVc(vc, sectionTag: sectionTag)
                        
                        self.horizontalView.scrollView.setContentOffset(CGPoint.init(x: DeviceSize.width, y: self.horizontalView.scrollView.contentOffset.y), animated: false)
                    }

                    
                }
                
            }
            
            if let _ = fromVc as? ArticleChooseViewController {
                
                if let vc = toVc as? TopicViewController {
                    vc.setStars()
                }
                
                horizontalView.scrollView.setContentOffset(CGPoint.init(x: 0, y: horizontalView.scrollView.contentOffset.y), animated: true)
            }else if let _ = fromVc as? ClueSelectViewController {
                
                
                if let _ac = toVc as? ArticleChooseViewController {
                    
                    _ = articleView.subviews.map({$0.removeFromSuperview()})

                    let sectionTag = sendData as! Int

                    self.setArticleVc(_ac, sectionTag: sectionTag)
//                    _ac.factCheckList = Array(RealmUser.shared.getUserData()?.factCheckList ?? List<FactCheck>())
//                    self.setChildVc(rootView: self.articleView, _ac)
                    
                }
                
                horizontalView.scrollView.setContentOffset(CGPoint.init(x: DeviceSize.width, y: horizontalView.scrollView.contentOffset.y), animated: true)
            }else if let _ = fromVc as? FactCheckViewController {
                
                if let _toVc = toVc as? ClueSelectViewController {
                    
                    
                    let data = sendData as! (Article, [Five_W_One_Hs], String)
                    
                    self.setChildVc(rootView: clueSelectView, _toVc)

                    _toVc.setData(article: data.0, five: data.1)
                    _toVc.questionPoint = data.2
                    _toVc.checkedFactList = Array((RealmUser.shared.getUserData()?.factCheckList)!).filter({$0.selectedArticleId == data.0.id})
//                    _toVc.changeColor()
                    
                    print("CLUESELES")
                    _toVc.setStack()
                    
                    horizontalView.scrollView.setContentOffset(CGPoint.init(x: DeviceSize.width * 2, y: horizontalView.scrollView.contentOffset.y), animated: true)
                    
                    
                }
                
            }
        }
    }
    
    func setChildVc(rootView:UIView, _ vc:GameTransitionBaseViewController) {
        
        if rootView.subviews.count > 0 {
            
            for i in rootView.subviews {
                i.removeFromSuperview()
            }
            
        }
        self.addChild(vc)
        rootView.addSubview(vc.view)
        vc.view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        vc.delegate = self
        vc.view.layoutSubviews()
        
        
        
    }
    
    func setArticleVc(_ vc:ArticleChooseViewController, sectionTag:Int) {
        
        vc.sectionId = sectionTag
        vc.factCheckList = Array(RealmUser.shared.getUserData()?.factCheckList ?? List<FactCheck>())
        self.setChildVc(rootView: self.articleView, vc)
        
        var articleButtons:[ArticleSelectButton] = []
        
        for article in RealmArticle.shared.get(Standard.shared.getLocalized()).filter({$0.section == sectionTag}) {
            
            let btn = ArticleSelectButton()
            
            let aa = realm.objects(Five_W_One_Hs.self).filter("article = \(article.id)").map({$0.point}).reduce(0, +)
            
            btn.setData(point: "\(aa)P", textColor: .black, title: article.word!, isStar: false, tag: article.id)
            articleButtons.append(btn)
            
        }
        
        vc.setData(localData: nil, articles: RealmArticle.shared.get(Standard.shared.getLocalized()).filter({$0.section == sectionTag}), articleBtns: articleButtons, articleLinks: RealmArticleLink.shared.getAll())
        
        vc.view.layoutIfNeeded()
        
        
    }
    
    
}
