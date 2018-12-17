//
//  FactCheckViewController.swift
//  WallPeckers
//
//  Created by Kang Seongchan on 13/12/2018.
//  Copyright © 2018 KimJimin and Company. All rights reserved.
//

import UIKit
import Realm
import RealmSwift
import AloeStackView

class FactCheckViewController: GameTransitionBaseViewController {
    
    let aStackView = AloeStackView()
    var checkData:[FactCheck]?
    var article:Article?
    var five:[Five_W_One_Hs]?
    let submitButton = BottomButton()
    let backButton = UIButton()
    let deskView = DeskBubbleView()
    var questionCount:Int = 0
    var correctCount:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setStack()
    }
    
    func setUI() {
        
        type = GameViewType.factCheck
        
        self.view.addSubview(aStackView)
        
        aStackView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeArea.top).offset(60)
            make.bottom.equalTo(view.safeArea.bottom).offset(-30)
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            
        }
        
        self.view.backgroundColor = .basicBackground
        
        backButton.setImage(UIImage.init(named: "backButton"), for: .normal)
        submitButton.setTitle("SUBMIT", for: .normal)
        backButton.addTarget(self, action: #selector(touchBackButton(sender:)), for: .touchUpInside)
        submitButton.addTarget(self, action: #selector(touchSubmitButton(sender:)), for: UIControl.Event.touchUpInside)
    }
    
    func setStack() {
        
        guard let _data = checkData, let _article = article, let _five = five else {return}

        let clues:[Clue] = Array(_article.clues).map({
            
            return RealmClue.shared.getLocalClue(id: $0, language: Standard.shared.getLocalized())!
            
        })
        
        if let whoC = clues.filter({
            $0.type == "WHO"
        }).first, let whenC = clues.filter({
            $0.type == "WHEN"
        }).first, let whereC = clues.filter({
            $0.type == "WHERE"
        }).first, let whatC = clues.filter({
            $0.type == "WHAT"
        }).first, let howC = clues.filter({
            $0.type == "HOW"
        }).first, let whyC = clues.filter({
            $0.type == "WHY"
        }).first {
            
            aStackView.backgroundColor = .basicBackground
            
            let articleView = ArticleView()
            articleView.forFactCheck()
            
            articleView.setData(article: article!, point: "300")

            aStackView.addRow(articleView)
            
            let whoV = BasicBubbleView()
            let whenV = BasicBubbleView()
            let whereV = BasicBubbleView()
            let whatV = BasicBubbleView()
            let howV = BasicBubbleView()
            let whyV = BasicBubbleView()
            
            whoV.setData(clue: whoC, type: .normal)
            whenV.setData(clue: whenC, type: .normal)
            whereV.setData(clue: whereC, type: .normal)
            whatV.setData(clue: whatC, type: .normal)
            howV.setData(clue: howC, type: .normal)
            whyV.setData(clue: whyC, type: .normal)
            
            let bubbles = [whoV, whenV, whereV, whatV, howV, whyV]
            var wrongs:[String] = []
            
            for b in bubbles {
                
                for f in _five {
                    if f.id == b.tag {
                        if !f.given {
                            b.clueDescLb.text = ""
                            questionCount += 1
                        }
                    }
                }
                
                for data in _data {
                    
                    if b.tag == data.correctClue { // 정답 검증 구간, b.tag 가 correctClue 임
                        
                        if let selectedClue = RealmClue.shared.getLocalClue(id: data.selectedClue, language: Standard.shared.getLocalized()) {
                            
                            if data.selectedClue != data.correctClue {

                                wrongs.append(b.clue!.type!)
                            }else{
                                correctCount += 1
                            }
                            print(selectedClue)
                            print(data)
                            print("~CLUE~~")
                            b.setDataCheck(clue: selectedClue, type: data.selectedClue == data.correctClue ? .correct : .wrong)
                            
                        }
                    }
                }
                
                if b.clueDescLb.text == "" {

                    
                    wrongs.append(b.clue!.type!)

                    b.bubbleBaseView.image = UIImage.init(named: "balloonFail")
                    
//                   wrongs.append(<#T##newElement: FactCheck##FactCheck#>)
                }
                
            }
            
            deskView.setData(region: _article.region!, wrongParts: wrongs)
            
            aStackView.addRows(bubbles)
            aStackView.addRow(deskView)
            
            aStackView.addRow(submitButton)
            submitButton.snp.makeConstraints { (make) in
                make.width.equalTo(200)
                make.height.equalTo(50)
                make.center.equalToSuperview()
            }
            aStackView.addRow(backButton)
            
        }
    }
    
    @objc func touchSubmitButton(sender:UIButton) {
    
        if correctCount > 0 {
            PopUp.callSubmitView(tag: 1, vc: self)
        }
    }
    
    @objc func touchBackButton(sender:UIButton) {
        sender.isUserInteractionEnabled = false
        
        guard let vc = self.findBeforeVc(type: .clue) else {return}
        
        
        delegate?.moveTo(fromVc: self, toVc: vc, sendData: nil, direction: .backward)
//        vc.viewWillAppear(true)

        sender.isUserInteractionEnabled = true
    }
    
    
    func setData(_ data:[FactCheck], article:Article, five:[Five_W_One_Hs]) {
        
        self.checkData = data
        self.article = article
        self.five = five
    }
}

extension FactCheckViewController:ArticleSubmitDelegate {
    func publishArticlewith(hashtag: Int) {
        print(hashtag)
        
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "CompleteArticleViewController") as? CompleteArticleViewController else {return}
        
        delegate?.moveTo(fromVc: self, toVc: vc, sendData: (article, hashtag), direction: .forward)
//        delegate.move
        // Move To ComleteArticle
//        print("DLDKDKDK")
    }
    
    
}

final class BasicBubbleView:UIView {
    
    let bubbleBaseView = UIImageView()
    let clueTypeLb = UILabel()
    let clueDescLb = UILabel()
    var clue:Clue?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    private func setUI() {
        
        self.addSubview([bubbleBaseView])
        
        bubbleBaseView.snp.makeConstraints { (make) in
            make.trailing.equalTo(-20)
            make.height.equalTo(75)
            make.leading.equalTo(DeviceSize.width > 320 ? 66 : 44)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        bubbleBaseView.image = UIImage.init(named: "balloon4")
        bubbleBaseView.contentMode = .scaleAspectFit
        bubbleBaseView.addSubview([clueTypeLb, clueDescLb])
        
        clueTypeLb.snp.makeConstraints { (make) in
            make.leading.equalTo(13)
            make.top.equalTo(DeviceSize.width > 320 ? 10 : 15)
            make.height.equalTo(20)
        }
        clueDescLb.snp.makeConstraints { (make) in
            make.height.equalTo(30)
            make.leading.equalTo(13)
            make.bottom.equalTo(-10)
            make.trailing.equalTo(-20)
        }
        clueDescLb.numberOfLines = 1
        
    }
    
    func setData(clue:Clue, type:FactCorrect) {
        
        self.clue = clue
        clueTypeLb.text = self.clue?.type
        clueTypeLb.font = UIFont.NotoSans(.bold, size: 16)
        clueDescLb.font = UIFont.NotoSans(.medium, size: 16)
        clueDescLb.text = clue.desc
        self.tag = clue.id
        
        switch type {
            
        case .normal:
            bubbleBaseView.image = UIImage.init(named: "balloon4")
            
        case .correct:
            bubbleBaseView.image = UIImage.init(named: "balloonCorrect")
            clueTypeLb.textColor = .white
            clueDescLb.textColor = .white
            
        case .wrong:
            clueTypeLb.textColor = .white
            clueDescLb.textColor = .white
            bubbleBaseView.image = UIImage.init(named: "balloonFail")
            
        case .empty:
            bubbleBaseView.image = UIImage.init(named: "balloon4")
        
        }
        
    }
    
    func setDataCheck(clue:Clue, type:FactCorrect) {

        clueDescLb.text = clue.desc
        self.tag = clue.id
        
        switch type {
            
        case .normal:
            bubbleBaseView.image = UIImage.init(named: "balloon4")
            
        case .correct:
            bubbleBaseView.image = UIImage.init(named: "balloonCorrect")
            clueTypeLb.textColor = .white
            clueDescLb.textColor = .white
            
        case .wrong:
            clueTypeLb.textColor = .white
            clueDescLb.textColor = .white
            bubbleBaseView.image = UIImage.init(named: "balloonFail")
            
        case .empty:
            bubbleBaseView.image = UIImage.init(named: "balloon4")
            
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

final class DeskBubbleView:UIView {
    
    let bubbleBaseView = UIImageView()
    let clueDescLb = UILabel()
    let profileView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    private func setUI() {
        self.addSubview([profileView, bubbleBaseView, clueDescLb])
        bubbleBaseView.image = UIImage.init(named: "balloon")
        profileView.snp.makeConstraints { (make) in
            make.top.leading.bottom.equalToSuperview()
            make.width.equalTo(63)
            make.height.equalTo(87)
        }
        bubbleBaseView.snp.makeConstraints { (make) in
            make.leading.equalTo(profileView.snp.trailing)
            make.top.equalTo(3)
            make.bottom.equalTo(-3)
            make.trailing.equalTo(-10)
        }
        clueDescLb.snp.makeConstraints { (make) in
            make.leading.equalTo(profileView.snp.trailing).offset(30)
            make.top.equalTo(bubbleBaseView.snp.top).offset(3)
            make.trailing.equalTo(bubbleBaseView.snp.trailing).offset(-10)
            make.bottom.equalTo(-10)
        }
        
    }
    
    func setData(region:String, wrongParts:[String]) {

        var sss = ""
        
        for i in 0...wrongParts.count - 1 {
            
            if i == wrongParts.count - 1 {
            
                sss.append("\(wrongParts[i])")
                
            }else{
                sss.append("\(wrongParts[i]), ")
            }
            
        }
        
        clueDescLb.attributedText = sss.makeAttrString(font: .NotoSans(.medium, size: 12), color: .black)
        
        print(wrongParts)
        print("~~~###")
        profileView.image = UIImage.init(named: region == "GERMANY" ? "germanDeskProfile" : "koreanDeskProfile")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



enum FactCorrect:String {
    
    case wrong, correct, normal, empty
}
