//
//  CompleteArticleViewController.swift
//  WallPeckers
//
//  Created by Seongchan Kang on 17/12/2018.
//  Copyright © 2018 KimJimin and Company. All rights reserved.
//

import UIKit
import AloeStackView

class CompleteArticleViewController: GameTransitionBaseViewController, UIScrollViewDelegate {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        
        if let _hash = hashTag, let _article = article {
            
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
            aStackView.addRow(titleLb)
            aStackView.addRow(completeArticleView)
            aStackView.delegate = self
            
            if wrongIds.count > 0 {
                aStackView.addRow(deskView)
                deskView.setDataForCompleteArticle(region: _article.region!, desc: "completearticle_desk".localized)
            }
            aStackView.addRow(hashView)
            aStackView.addRow(okButton)
            okButton.snp.makeConstraints { (make) in
                make.top.bottom.equalToSuperview()
                make.height.equalTo(55)
                make.leading.equalTo(20)
                make.trailing.equalTo(-20)
            }
            okButton.setTitle("OK".localized, for: .normal)
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
            
            make.bottom.equalTo(view.safeArea.bottom).offset(-40)
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            
        }
         
        titleLb.attributedText = "completearticle_title".localized.makeAttrString(font: .NotoSans(.medium, size: 25), color: .black)
        titleLb.textAlignment = .center
        okButton.addTarget(self, action: #selector(moveToBack(sender:)), for: .touchUpInside)
    }
    
    @objc func moveToBack(sender:UIButton) {
        
        if let _ = fromMyPage {
            self.navigationController?.popViewController(animated: true)
        }else{
            guard let vc = self.findBeforeVc(type: .topic) else {return}
            
            try! realm.write {
                if let _article = article {
                    _article.selectedPictureId = completeArticleView.indexRow + 1
                }
            }
            
            print(completeArticleView.indexRow + 1) // 선택된 사진 아이디값, 여기서 ArticleData 저장하는 API 호출
            
            delegate?.moveTo(fromVc: self, toVc: vc, sendData: (article?.section)!, direction: .backward)
        }
    }

    func setData(article:Article, hashTag:Int, wrongIds:[Int]) {
        
        self.article = article
        self.hashTag = hashTag
        self.wrongIds = wrongIds
   
    }
    
    func hashTagGraphAnimation() {
        if let _hash = hashTag, let _article = article {
            
            if let a = _article.hashes?.components(separatedBy: "/") {
                
                let ints = a.map({Int($0)!})
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
                    self.hashView.startAnimation(heights: ints)
                }
                for i in 0...ints.count - 1 {
                    
                    if let gps = self.hashView.subviews.filter({$0 is GraphView}) as? [GraphView] {
                        
                        _ = gps.map({
                            if $0.tag == i {
                                $0.initData(percent: ints[i], myTag: _hash)
                            }
                        })
                    }
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

