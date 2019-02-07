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

class GameViewController: UIViewController { // 게임페이지 내에서의 이동은 모두 여기서 처리함
    
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
    func tapBottomButton(sender: AlertPopUpView) { // 타이머 얼럿뷰 제어
        
        if sender.tag == 2 {
            sender.removeFromSuperview()
        }else{
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ResultViewController") as? ResultViewController else {return}
            RealmUser.shared.savePlayTime()
            sender.removeFromSuperview()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    
    func touchMoveToMyPage(sender: UIButton) { // 마이페이지로 이동
        sender.isUserInteractionEnabled = false
        
        guard let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyPage") as? UINavigationController else {return}
        
        if let mvc = vc.viewControllers.first as? MyPageViewController {
            
            mvc.fromGame = true
        }
        
        sender.isUserInteractionEnabled = true
        
        self.present(vc, animated: true, completion: nil)
    }
    
    func checkPlayTime(_ time: Int) { // 타이머 얼럿 띄우는 시기 체크
        
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
            
            if let vc = toVc as? CompleteArticleViewController { // 기사완료페이지로 이동할때
                
                guard let _sendData = sendData as? (Article, Int, [Int], Bool) else {return}
                
                vc.setData(article: _sendData.0, hashTag: _sendData.1, wrongIds:_sendData.2)
                vc.isCompletedFirst = _sendData.3
                self.setChildVc(rootView: articleResultView, vc)
                
                horizontalView.scrollView.setContentOffset(CGPoint.init(x: DeviceSize.width * 4, y: horizontalView.scrollView.contentOffset.y), animated: true)
                
            }
            
            if let vc = toVc as? FactCheckViewController { // 팩트체크페이지로 이동할때
                
                guard let _sendData = sendData as? ([FactCheck], Article, [Five_W_One_Hs], String) else {return}
                vc.setData(_sendData.0, article: _sendData.1, five: _sendData.2, questionPoint: _sendData.3)
                self.setChildVc(rootView: factCheckView, vc)
                clueSelectView.subviews.first?.removeFromSuperview()
                horizontalView.scrollView.setContentOffset(CGPoint.init(x: DeviceSize.width * 3, y: horizontalView.scrollView.contentOffset.y), animated: true)
            }
            
            if let vc = toVc as? ArticleChooseViewController { // 기사선택 페이지로 이동할때
                
                var articleButtons:[ArticleSelectButton] = []
                
                for article in RealmArticle.shared.get(selectedLanguage).filter({$0.section == sendData as! Int}) {
                    
                    let btn = ArticleSelectButton()
                    let aa = realm.objects(Five_W_One_Hs.self).filter("article = \(article.id)").map({$0.point}).reduce(0, +)
                    vc.changeColor()
                    btn.setData(point: "\(aa)P", textColor: .black, title: article.word!, isStar: article.isCompleted, tag: article.id)
                    articleButtons.append(btn)
                    
                }
                
                vc.setData(localData: nil, articles: RealmArticle.shared.get(selectedLanguage).filter({$0.section == sendData as! Int}), articleBtns: articleButtons, articleLinks: RealmArticleLink.shared.getAll())
                
                self.setChildVc(rootView: articleView, vc)
                
                horizontalView.scrollView.setContentOffset(CGPoint.init(x: DeviceSize.width, y: horizontalView.scrollView.contentOffset.y), animated: true)
            }
            
            
            if let vc = toVc as? ClueSelectViewController { // 증거 선택 페이지로 이동할 때
                
                let data = sendData as! (Article, [Five_W_One_Hs], String)
                
                
                vc.setData(article: data.0, five: data.1)
                vc.questionPoint = data.2
                self.setChildVc(rootView: clueSelectView, vc)
                horizontalView.scrollView.setContentOffset(CGPoint.init(x: DeviceSize.width * 2, y: horizontalView.scrollView.contentOffset.y), animated: true)
            }
            
        case .backward:
            fromVc.removeFromParent()
            
            if let fvc = fromVc as? CompleteArticleViewController { // 기사 완료 페이지에서 뒤로가기 누를때
                
                
                if let vc = toVc as? TopicViewController { // 주제 페이지로 이동할 때
                    
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
                
                if let vc = toVc as? ArticleChooseViewController { // 기사 선택 페이지로 이동할 때

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
            
            if let _ = fromVc as? ArticleChooseViewController { // 기사 선택페이지에서 뒤로 가기 누를 때
                
                if let vc = toVc as? TopicViewController { // 주제 선택 페이지로 돌아올 때
                    vc.setStars()
                }
                
                horizontalView.scrollView.setContentOffset(CGPoint.init(x: 0, y: horizontalView.scrollView.contentOffset.y), animated: true)
            }else if let _ = fromVc as? ClueSelectViewController { // 증거선택 페이지에서 뒤로 누를 때
                
                
                if let _ac = toVc as? ArticleChooseViewController { // 기사 선택 페이지로 돌아올 때
                    
                    _ = articleView.subviews.map({$0.removeFromSuperview()})

                    let sectionTag = sendData as! Int

                    self.setArticleVc(_ac, sectionTag: sectionTag)
                    
                }
                
                horizontalView.scrollView.setContentOffset(CGPoint.init(x: DeviceSize.width, y: horizontalView.scrollView.contentOffset.y), animated: true)
            }else if let _ = fromVc as? FactCheckViewController { // 팩트체크 페이지에서 뒤로 가기 누를 때
                
                if let _toVc = toVc as? ClueSelectViewController { // 증거선택 페이지로 돌아올때
                    
                    
                    let data = sendData as! (Article, [Five_W_One_Hs], String)
                    
                    self.setChildVc(rootView: clueSelectView, _toVc)

                    _toVc.setData(article: data.0, five: data.1)
                    _toVc.questionPoint = data.2
                    _toVc.checkedFactList = Array((RealmUser.shared.getUserData()?.factCheckList)!).filter({$0.selectedArticleId == data.0.id})
                    _toVc.setStack()
                    
                    horizontalView.scrollView.setContentOffset(CGPoint.init(x: DeviceSize.width * 2, y: horizontalView.scrollView.contentOffset.y), animated: true)
                    
                    
                }
                
            }
        }
    }
    
    func setChildVc(rootView:UIView, _ vc:GameTransitionBaseViewController) { // 비어있는 컨테이너뷰에 각각의 뷰컨트롤러 할당
        
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
    
    func setArticleVc(_ vc:ArticleChooseViewController, sectionTag:Int) { // 기사선택페이지 데이터 설정 함수
        
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
