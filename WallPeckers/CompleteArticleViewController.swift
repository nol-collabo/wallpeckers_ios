//
//  CompleteArticleViewController.swift
//  WallPeckers
//
//  Created by Seongchan Kang on 17/12/2018.
//  Copyright © 2018 KimJimin and Company. All rights reserved.
//

import UIKit
import AloeStackView

class CompleteArticleViewController: GameTransitionBaseViewController, UIScrollViewDelegate, GetPictureIdDelegate {
    
    var pictureId: Int = 0
    var isCompletedFirst:Bool = false
    var bottomReached:Bool = false
    var topReached:Bool = false
    var article:Article?
    var hashTag:Int?
    var wrongIds:[Int] = []
    let aStackView = AloeStackView()
    let okButton = BottomButton()
    let titleLb = UILabel()
    var fromMyPage:Bool?
    let completeArticleView = CompletedArticleView()
    let deskView = DeskBubbleView()
    let hashView = HashTagGraphView()
    let backArticleBtn = BottomButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
//        print
        
        if let _hash = hashTag, let _article = article {
            
            print(_article.selectedPictureId, "MYPICUTREID")
            
            if let a = article?.hashArray {

                let aa = Array(a)
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                    self.hashView.startAnimation(heights: aa)
                }
                
                for i in 0...aa.count - 1 {
                    
                    if let gps = self.hashView.subviews.filter({
                        
                        $0 is GraphView
                    }) as? [GraphView] {
                        
                        _ = gps.map({
                            if $0.tag == i {
                                $0.initData(percent: aa[i], myTag: _hash)
                            }
                            
                        })
                    }
                
                }
                
            }
            
            completeArticleView.setData(article: _article, wrongClue: wrongIds, region: _article.region!)
            completeArticleView.delegate = self
            if !isCompletedFirst {
                print(_article.selectedPictureId, "MYPICTUREID")
              
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
                     self.completeArticleView.imageCollectionView.scrollToItem(at: IndexPath.init(row: _article.selectedPictureId, section: 0), at: .centeredHorizontally, animated: false)
                }

                
            }
            aStackView.addRow(titleLb)
            aStackView.addRow(completeArticleView)
            aStackView.delegate = self
            
            if wrongIds.count > 0 {
                aStackView.addRow(deskView)
                deskView.setDataForCompleteArticle(region: _article.region!, desc: "completearticle_desk".localized)
            }
            aStackView.addRow(hashView)
            
            let emptyView = UIView()
            
            aStackView.addRow(emptyView)
            
            emptyView.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
                make.height.equalTo(10)
            }
            
            aStackView.addRow(okButton)
            
            okButton.snp.makeConstraints { (make) in
                make.top.bottom.equalToSuperview()
                make.height.equalTo(55)
                make.leading.equalTo(20)
                make.trailing.equalTo(-20)
            }
            
            let middle = UIView()
            aStackView.addRow(middle)
            middle.snp.makeConstraints { (make) in
                make.height.equalTo(10)
                make.edges.equalToSuperview()
            }
            
            aStackView.addRow(backArticleBtn)
            backArticleBtn.snp.makeConstraints { (make) in
                make.top.bottom.equalToSuperview()
                make.height.equalTo(55)
                make.leading.equalTo(20)
                make.trailing.equalTo(-20)
            }
            
            let bottomV = UIView()
            aStackView.addRow(bottomV)
            bottomV.snp.makeConstraints { (make) in
                make.height.equalTo(50)
                make.edges.equalToSuperview()
            }
        }
        
    }
    
    private func setUI() {
        
        self.view.backgroundColor = .basicBackground
        self.view.addSubview(aStackView)
        aStackView.backgroundColor = .basicBackground
        aStackView.snp.makeConstraints { (make) in
        
            if let _ = fromMyPage {
                make.top.equalTo(view.safeArea.top).offset(10)
            }else{
                make.top.equalTo(view.safeArea.top).offset(60)
            }
            
            make.bottom.equalTo(view.safeArea.bottom)
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            
        }
        
        
        if isCompletedFirst {
            okButton.setTitle("CHANGE TOPIC".localized, for: .normal)
            okButton.setBackgroundColor(color: .white, forState: .normal)
            okButton.setTitleColor(.black, for: .normal)
            backArticleBtn.isHidden = false
            
            if let section = RealmSection.shared.get(Standard.shared.getLocalized()).filter({$0.id == article?.section}).first {
                backArticleBtn.titleLabel?.numberOfLines = 2
                backArticleBtn.titleLabel?.textAlignment = .center
                backArticleBtn.setTitle(String(format: "selectotherarticle".localized, section.title!.replacingOccurrences(of: "\n", with: "")), for: .normal)

            }
            
            backArticleBtn.addTarget(self, action: #selector(moveToArticleChooseVc(sender:)), for: .touchUpInside)
        }else{
            backArticleBtn.isHidden = true
            okButton.setBackgroundColor(color: .black, forState: .normal)
            okButton.setTitleColor(.white, for: .normal)
            okButton.setTitle("OK".localized, for: .normal)

        }
        
        titleLb.attributedText = "completearticle_title".localized.makeAttrString(font: .NotoSans(.medium, size: 25), color: .black)
        titleLb.textAlignment = .center
        okButton.addTarget(self, action: #selector(moveToTopicVc(sender:)), for: .touchUpInside)
    }
    
    @objc func moveToArticleChooseVc(sender:UIButton) {
        guard let article = article else {return}
        
        guard let vc = self.findBeforeVc(type: .article) else {return}
        
        try! realm.write {
//            if let _article = article {
                article.isCompleted = true
//            }
        }
        
        if isCompletedFirst {
            CustomAPI.saveArticleData(articleId: article.id, category: article.section, playerId: (RealmUser.shared.getUserData()?.allocatedId)!, language: Standard.shared.getLocalized(), sessionId: UserDefaults.standard.integer(forKey: "sessionId"), tag: article.selectedHashtag, count: article.tryCount, photoId: article.selectedPictureId) { (result) in
                
                print(article.section)
                print("ARTICLESECTION")

                
                if result == "OK" {
                    self.delegate?.moveTo(fromVc: self, toVc: vc, sendData: (article.section), direction: .backward)
                }else{
                    
                    self.delegate?.moveTo(fromVc: self, toVc: vc, sendData: (article.section), direction: .backward)
                    
                    print("오류")
                }
            }
        }
    }
    
    @objc func moveToTopicVc(sender:UIButton) {
        
        if let _ = fromMyPage {
            self.navigationController?.popViewController(animated: true)
        }else{
            guard let vc = self.findBeforeVc(type: .topic) else {return}
            
            try! realm.write {
                if let _article = article {
                    _article.isCompleted = true
                }
            }
            
            guard let article = article else {return}
            
            
            if isCompletedFirst {
                CustomAPI.saveArticleData(articleId: article.id, category: article.section, playerId: (RealmUser.shared.getUserData()?.allocatedId)!, language: Standard.shared.getLocalized(), sessionId: UserDefaults.standard.integer(forKey: "sessionId"), tag: article.selectedHashtag, count: article.tryCount, photoId: article.selectedPictureId) { (result) in
                    
                    if result == "OK" {
                        self.delegate?.moveTo(fromVc: self, toVc: vc, sendData: (article.section), direction: .backward)
                    }else{
                        self.delegate?.moveTo(fromVc: self, toVc: vc, sendData: (article.section), direction: .backward)
                    }
                }
            }else{
                self.delegate?.moveTo(fromVc: self, toVc: vc, sendData: (article.section), direction: .backward)
            }
        }
    }

    func setData(article:Article, hashTag:Int, wrongIds:[Int]) {
        
        self.article = article
        self.hashTag = hashTag
        self.wrongIds = wrongIds
   
    }
    
    func hashTagGraphAnimation() {
        if let _hash = hashTag, let _article = article {
            
             let a = Array(_article.hashArray)
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
                    self.hashView.startAnimation(heights: a)
                }

                for i in 0...a.count - 1 {
                    
                    if let gps = self.hashView.subviews.filter({$0 is GraphView}) as? [GraphView] {
                        
                        _ = gps.map({
                            if $0.tag == i {
                                if a[i] == a.max() {
                                    $0.initData(percent: a[i], myTag: _hash, top: true)
                                }else{
                                    $0.initData(percent: a[i], myTag: _hash)
                                }
                            }
                        })
                    }
                }
            
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
  
        if (scrollView.contentOffset.y + 100) >= (scrollView.contentSize.height - scrollView.frame.size.height) {
            //reach bottom
            if !bottomReached {
                bottomReached = true
                topReached = false
                self.hashTagGraphAnimation()
                
            }
        }
        
        if (scrollView.contentOffset.y <= 0){
            if !topReached {
                topReached = true
                bottomReached = false
                self.hashView.initAnimation()
            }
        }
        
        if (scrollView.contentOffset.y > 0 && scrollView.contentOffset.y < (scrollView.contentSize.height - scrollView.frame.size.height)){
            //not top and not bottom
        }
    }
    
}

