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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        // Do any additional setup after loading the view.
    }
    
    func setData(article:Article, five:[Five_W_One_Hs]) {
        self.article = article
        self.five_W_One_Hs = five
    }
    
    
    func setUI(){
        
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
        
        stackView.backgroundColor = .basicBackground
        
        let articleView = ArticleView()
        
        articleView.setData(article: article!, point: questionPoint!)
        
        stackView.addRow(articleView)
        
        for v in five_W_One_Hs! {
            
            let view = ClueSelectView()
            view.delegate = self
            
            
            if let aa = RealmClue.shared.getLocalClue(id: v.clue, language: Standard.shared.getLocalized()) {
                view.setData(five: v, clue: aa)
                view.tag = v.clue
                
                _ = checkedFactList.map({
                    
                    
                    if view.tag == $0.correctClue {
                        view.indicatedWhenBeforeChecked($0)
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
    
    @objc func moveToFactCheck(sender:UIButton) {

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
        
        
        delegate?.moveTo(fromVc: self, toVc: vc, sendData: (sendingData, article, five_W_One_Hs, questionPoint), direction: .forward)
       

        
    }
    @objc func moveToBack(sender:UIButton) {
        sender.isUserInteractionEnabled = false
        
        guard let vc = self.findBeforeVc(type: .article) else {return}
        
        
        if let _vc = vc as? ArticleChooseViewController {
            
            _vc.changeColor()
            
            delegate?.moveTo(fromVc: self, toVc: _vc, sendData: nil, direction: .backward)

        }
        
        
        sender.isUserInteractionEnabled = true
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
                selectedClueView.clueButton.backgroundColor = .sunnyYellow
                let factCheck = FactCheck()
                factCheck.selectedClue = selectedClue.id
                factCheck.selectedArticleId = article!.id
                factCheck.correctClue = selectedClueView.tag
                
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
            
//            stackView.getAllRows().filter({$0.tag == tag})
            
            
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





extension UIView {
    
    func dropShadow() {
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.layer.shadowRadius = 1
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        
        self.layer.rasterizationScale = UIScreen.main.scale
        
    }
}
