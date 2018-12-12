//
//  GameViewController.swift
//  WallPeckers
//
//  Created by Seongchan Kang on 12/12/2018.
//  Copyright © 2018 KimJimin and Company. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    let selectedLanguage = Standard.shared.getLocalized()
    var timerView:NavigationCustomView?
    let horizontalView = BaseHorizontalScrollView()
    let topicView = UIView()
    let articleView = UIView()
    let clueSelectView = UIView()
    let factCheckView = UIView()
    let articleResultView = UIView()
    let topicViewController = UIStoryboard.init(name: "Game", bundle: nil).instantiateViewController(withIdentifier: "TopicViewController") as! TopicViewController
//    let articleViewContoller = UIStoryboard.init(name: "Game", bundle: nil).instantiateViewController(withIdentifier: "ArticleChooseViewController") as! ArticleChooseViewController
//    let clueSelectViewContoller = UIStoryboard.init(name: "Game", bundle: nil).instantiateViewController(withIdentifier: "ClueSelectViewController") as! ClueSelectViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        horizontalView.setScrollView(vc: self)
        self.setCustomNavigationBar()
        setUI()
        addChildVc()
        self.timerView = self.findTimerView()
        Standard.shared.delegate = self
        Standard.shared.startTimer(gameMode: .short)

        // Do any additional setup after loading the view.
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
//        articleView.addSubview(articleViewContoller.view)
//        clueSelectView.addSubview(clueSelectViewContoller.view)
        topicViewController.view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

//        clueSelectViewContoller.view.snp.makeConstraints { (make) in
//            make.edges.equalToSuperview()
//        }
        horizontalView.scrollView.isScrollEnabled = false
    }
    
    func addChildVc() {
        for v in [topicViewController] {
            addChild(v)
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

extension GameViewController:GamePlayTimeDelegate, GameNavigationBarDelegate, AlerPopupViewDelegate {
    func tapBottomButton(sender: AlertPopUpView) {
        print(sender.tag)
        if sender.tag == 2 {
            sender.removeFromSuperview()
        }else{
            
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ResultViewController") as? ResultViewController else {return}
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    
    func touchMoveToMyPage(sender: UIButton) {
        sender.isUserInteractionEnabled = false
        
        guard let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyPageViewController") as? MyPageViewController else {return}
        sender.isUserInteractionEnabled = true
        
        self.present(vc, animated: true, completion: nil)
    }
    
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
    
    
}

extension GameViewController:GameViewTransitionDelegate {
    func moveTo(fromVc: GameTransitionBaseViewController, toVc: GameTransitionBaseViewController, sendData: Any?, direction:TransitionDirection) {
        print(fromVc)
        print(toVc)
        
        switch direction {
            
        case .forward:
            
            if let vc = toVc as? ArticleChooseViewController {
            
            var articleButtons:[ArticleSelectButton] = []
                
            for article in RealmArticle.shared.get(selectedLanguage).filter({
                $0.section == sendData as! Int
            }) {
                
                let btn = ArticleSelectButton()
                
                let aa = realm.objects(Five_W_One_Hs.self).filter("article = \(article.id)").map({
                    
                    $0.point
                }).reduce(0, +)
                
                btn.setData(point: "\(aa)P", textColor: .black, title: article.word!, isStar: false, tag: article.id)
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
                print(vc)
                horizontalView.scrollView.setContentOffset(CGPoint.init(x: DeviceSize.width * 2, y: horizontalView.scrollView.contentOffset.y), animated: true)
            }
            
        case .backward:
            fromVc.removeFromParent()

            if let _ = fromVc as? ArticleChooseViewController {
                 horizontalView.scrollView.setContentOffset(CGPoint.init(x: 0, y: horizontalView.scrollView.contentOffset.y), animated: true)
            }else if let _ = fromVc as? ClueSelectViewController {
                horizontalView.scrollView.setContentOffset(CGPoint.init(x: DeviceSize.width, y: horizontalView.scrollView.contentOffset.y), animated: true)
            }

        }
        

        
    }
    
    func setChildVc(rootView:UIView, _ vc:GameTransitionBaseViewController) {
        
        self.addChild(vc)
        rootView.addSubview(vc.view)
        vc.view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        vc.delegate = self
        
        
        
    }
    
    
}
