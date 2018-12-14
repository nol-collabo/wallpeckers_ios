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
        
            for b in bubbles {
                
                for f in _five {
                    if f.id == b.tag {
                        if !f.given {
                            b.clueDescLb.text = ""
                        }
                    }
                }
                
                for data in _data {
                    
                    if b.tag == data.correctClue { // 정답 검증 구간
                        
                        if let selectedClue = RealmClue.shared.getLocalClue(id: data.selectedClue, language: Standard.shared.getLocalized()) {
                            b.setData(clue: selectedClue, type: data.selectedClue == data.correctClue ? .correct : .wrong)
                        }
                    }
                }
                
 
            }

        aStackView.addRows(bubbles)
            print(DeviceSize.width, "DEVICEWIDTH")

        
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
        print("Article Submit!")
    }
    
    @objc func touchBackButton(sender:UIButton) {
        sender.isUserInteractionEnabled = false
        
        guard let vc = self.findBeforeVc(type: .clue) else {return}
        
        delegate?.moveTo(fromVc: self, toVc: vc, sendData: nil, direction: .backward)
        
        sender.isUserInteractionEnabled = true
    }
    

    func setData(_ data:[FactCheck], article:Article, five:[Five_W_One_Hs]) {
        
        self.checkData = data
        self.article = article
        self.five = five
    }
}

final class BasicBubbleView:UIView {
    
    let bubbleBaseView = UIImageView()
    let clueTypeLb = UILabel()
    let clueDescLb = UILabel()
    
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
            make.top.equalTo(DeviceSize.width > 320 ? 5 : 10)
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
        
        clueTypeLb.text = clue.type
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

        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

final class DeskBubbleView:UIView {
    
    let bubbleBaseView = UIImageView()
    let clueDescLb = UILabel()
    let profileView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

enum FactCorrect:String {
    
    case wrong, correct, normal
}
