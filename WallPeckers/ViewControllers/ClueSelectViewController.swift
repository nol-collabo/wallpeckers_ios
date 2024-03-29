//
//  ClueSelectViewController.swift
//  WallPeckers
//
//  Created by Seongchan Kang on 10/12/2018.
//  Copyright © 2018 KimJimin and Company. All rights reserved.
//

import UIKit
import SnapKit
import AloeStackView
import Realm
import RealmSwift

class ClueSelectViewController: GameTransitionBaseViewController {

    var article:Article?
    let factCheckButton = BottomButton()
    let backButton = UIButton()
    var five_W_One_Hs:[Five_W_One_Hs]?
    let stackView = AloeStackView()
    var sectionString:String?
    var questionPoint:String?
    var checkedFactList = Array(RealmUser.shared.getUserData()?.factCheckList ?? List<FactCheck>())
    var articleTrycount:Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    func setData(article:Article, five:[Five_W_One_Hs]) {
        self.article = article
        self.five_W_One_Hs = five
        if let _ = RealmArticle.shared.get(Standard.shared.getLocalized()).filter({$0.id == article.id}).first {
            
            articleTrycount = article.tryCount
        }
        factCheckBtnStatus()
 
    }
    
    private func setUI(){
        
        type = GameViewType.clue

        self.view.addSubview(stackView)
        
        stackView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeArea.top).offset(60)
            make.bottom.equalTo(view.safeArea.bottom).offset(-30)
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            
        }
        
        self.view.backgroundColor = .basicBackground
        backButton.setImage(UIImage.init(named: "backButton"), for: .normal)
        factCheckButton.setTitle("FACT CHECK".localized, for: .normal)
        backButton.addTarget(self, action: #selector(moveToBack(sender:)), for: .touchUpInside)
        factCheckButton.addTarget(self, action: #selector(moveToFactCheck(sender:)), for: .touchUpInside)
        setStack()

    }
    
    func setStack() {
        
        stackView.removeAllRows() // 기존에 있던 데이터 초기화
        stackView.backgroundColor = .basicBackground
        
        let articleView = ArticleView()
        
        articleView.setData(article: article!, point: questionPoint!)
        
        stackView.addRow(articleView)
        
        for v in five_W_One_Hs! {
            
            let view = ClueSelectView()
            
            view.delegate = self
            
            if let aa = RealmClue.shared.getLocalClue(id: v.clue, language: Standard.shared.getLocalized()) {
                
                view.setData(five: v, clue: aa, info: "Tap_Code".localized, tryCount: articleTrycount ?? 0)
                view.tag = v.clue
                
                _ = checkedFactList.map({
                    if view.tag == $0.correctClue {
                        view.indicatedWhenBeforeChecked($0, tryCount:articleTrycount ?? 0)
                        factCheckButton.backgroundColor = .black
                        factCheckButton.setTitleColor(.white, for: .normal)
                        factCheckButton.isEnabled = true
                        print("VV")
                    }
                })
                stackView.addRow(view)
            }
  
            stackView.addRow(factCheckButton)
            factCheckButton.snp.makeConstraints { (make) in
                make.width.equalTo(200)
                make.height.equalTo(50)
                make.center.equalToSuperview()
            }
            stackView.addRow(backButton)
            
        }
    }
    
    func changeColor() { // 정답 선택 시 버튼 색상 변경
        if let csv = stackView.getAllRows().filter({$0 is ClueSelectView}) as? [ClueSelectView] {
            
            let selected = Array((RealmUser.shared.getUserData()?.factCheckList)!).filter({$0.selectedArticleId == article?.id})
            
            _ = selected.map({
                fact in
                _ = csv.map({
                    id in
                    if id.tag == fact.correctClue {
                        id.indicatedWhenBeforeChecked(fact, tryCount:1)
                        print("correctAnswer")
                        id.layoutSubviews()
                        id.layoutIfNeeded()
                    }else{
                        _ = five_W_One_Hs!.map({
                            if !$0.given {
                                if $0.clue == id.tag {
                                    id.clueButton.setTitleColor(.red, for: .normal)
                                }
                            }
                        })
                    }
                })
            })
        }
    }
    
    @objc func moveToFactCheck(sender:UIButton) { // 팩트체크 페이지로 이동하는 버튼 누를 때
        var sendingData:[FactCheck] = []
        
        _ = checkedFactList.map({
            
            if $0.selectedArticleId == article?.id {
                if $0.selectedClue == $0.correctClue {
                    realm.beginWrite()
                    $0.isCorrect = true
                    try! realm.commitWrite()
                    
                }
                sendingData.append($0)
            }
        })
        
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "FactCheckViewController") as? FactCheckViewController else {return}
        
        realm.beginWrite()
            article!.tryCount += 1
        try! realm.commitWrite()

        delegate?.moveTo(fromVc: self, toVc: vc, sendData: (sendingData, article, five_W_One_Hs, questionPoint), direction: .forward)
       

        
    }
    @objc func moveToBack(sender:UIButton) { // 뒤로가기 버튼 누를 때
        sender.isUserInteractionEnabled = false
        
        guard let vc = self.findBeforeVc(type: .article) else {return}
        
        
        if let _vc = vc as? ArticleChooseViewController {
            
            _vc.changeColor()
            
            delegate?.moveTo(fromVc: self, toVc: _vc, sendData: article?.section, direction: .backward)

        }
        
        
        sender.isUserInteractionEnabled = true
    }
    
    func factCheckBtnStatus() { // 팩트체크 버튼 활성화 관련 함수
        if articleTrycount == 0 {
            factCheckButton.backgroundColor = .basicBackground
            factCheckButton.setTitleColor(.black, for: .normal)
            factCheckButton.isEnabled = false
        }else{
            factCheckButton.backgroundColor = .black
            factCheckButton.setTitleColor(.white, for: .normal)
            factCheckButton.isEnabled = true
        }
    }
    
}

extension ClueSelectViewController: ClueSelectDelegate, CluePopUpViewDelegate {
    func inputCode(_ code: String?, tag: Int) {
        guard let code = code else {return}
        
        if code == "" {
            return
        }
        
        if let selectedClue = RealmClue.shared.getClueAsIdentification(code, language: Standard.shared.getLocalized()) {
      
            if let selectedClueView = findClueView(tag: tag) {
                
                selectedClueView.clueLb.text = selectedClue.desc!
                selectedClueView.clueButton.setBackgroundColor(color: .sunnyYellow, forState: .normal)
                selectedClueView.clueButton.setTitleColor(.black, for: .normal)
                selectedClueView.infoLb.attributedText = String(format:"Tap_Code_inputed".localized, "\(selectedClue.identification!)").makeAttrString(font: .NotoSans(.bold, size: 15), color: .white)
                let factCheck = FactCheck()
                factCheck.selectedClue = selectedClue.id
                factCheck.selectedArticleId = article!.id
                factCheck.selectedIdentication = selectedClue.identification!
                factCheck.correctClue = selectedClueView.tag
                factCheckButton.backgroundColor = .black
                factCheckButton.setTitleColor(.white, for: .normal)
                factCheckButton.isEnabled = true
                
                if let beforeSelected = RealmUser.shared.getUserData()?.factCheckList.filter("correctClue = \(selectedClueView.tag)").first {
                    if let idx = RealmUser.shared.getUserData()?.factCheckList.index(of: beforeSelected) {
                        try! realm.write {
                            RealmUser.shared.getUserData()?.factCheckList.remove(at: idx)
                        }
                    }
                }
                
                try! realm.write {
                    RealmUser.shared.getUserData()?.factCheckList.append(factCheck)
                    self.checkedFactList = Array(RealmUser.shared.getUserData()?.factCheckList ?? List<FactCheck>())
                }
            }
            
        }else{
            PopUp.callAlert(time: "", desc: "writearticleerrordialog_desc".localized, vc: self, tag: 9)
        }
    }
    
    func touchButton(sender: Clue, tag: Int) {
        if let clueType = sender.type {
            PopUp.callCluePopUp(clueType: clueType.localized, tag: tag, vc: self)
        }
    }
    
    func findClueView(tag:Int) -> ClueSelectView? {
        
        if let clueView = stackView.getAllRows().filter({
            
            $0.tag == tag
        }).first as? ClueSelectView {
            
            return clueView
        }else{
            return nil
        }
        
    }

}

extension ClueSelectViewController:AlerPopupViewDelegate {
    func tapBottomButton(sender: AlertPopUpView) {
        if sender.tag == 9 {
            sender.removeFromSuperview()
        }else{
            sender.removeFromSuperview()
        }
    }
    
    
}
