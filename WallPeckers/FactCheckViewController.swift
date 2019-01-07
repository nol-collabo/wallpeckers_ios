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

typealias wrongClueTuple = (String, String, String) // (CorrectId, IncorrectId, ClueType)

class FactCheckViewController: GameTransitionBaseViewController, BasicBubbleViewDelegate {
    func tapToBack() {
        
        
        
        guard let vc = self.findBeforeVc(type: .clue) else {return}
        
//        print((article, five, questionPoint)) /
        print("~~~~~")
        delegate?.moveTo(fromVc: self, toVc: vc, sendData: (article!, five! , questionPoint!), direction: .backward)
    }
    
    
    let aStackView = AloeStackView()
    var checkData:[FactCheck]?
    var article:Article?
    var five:[Five_W_One_Hs]?
    let submitButton = BottomButton()
    let backButton = UIButton()
    let deskView = DeskBubbleView()
    var questionCount:Int = 0
    var correctCount:Int = 0
    var wrongQuestionId:[Int] = []
    var questionPoint:String?
    var wrongQuestions:[wrongClueTuple] = [] { // (CorrectId, IncorrectId, ClueType)
        
        didSet {

            if wrongQuestions.count > 0 {
                for wrong in wrongQuestions {
                    
                    CustomAPI.saveIncorrect(articleId: article!.id, clue_type: wrong.2, code_incorrect: wrong.1, code_correct: wrong.0) { (result) in
                        print(result)
                        print(wrong)
                    }
                    
                }
            }
        }
    }
    
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
        submitButton.setTitle("REPORT".localized, for: .normal)
        backButton.addTarget(self, action: #selector(touchBackButton(sender:)), for: .touchUpInside)
        submitButton.addTarget(self, action: #selector(touchSubmitButton(sender:)), for: UIControl.Event.touchUpInside)
    }
    
    func setStack() {
        
        guard let _data = checkData, let _article = article, let _five = five else {return}

        let clues:[Clue] = Array(_article.clues).map({
            
            return RealmClue.shared.getLocalClue(id: $0, language: Standard.shared.getLocalized())!
            
        })
        
        print(_data)
        print("~~~~~~")
        
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
            
            
            if let _questionPoint = questionPoint, let _article = article {
                articleView.setData(article: _article, point: _questionPoint)

            }
            

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
            var wrongC:[wrongClueTuple] = []
            
            for b in bubbles {
                
                b.delegate = self
                
                guard let correctClueIdentification = RealmClue.shared.getClue(id: b.tag)?.identification else {return}
                
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

                                wrongQuestionId.append((b.clue?.id)!)
                                wrongs.append(b.clue!.type!)
                                
                                

                                wrongC.append((correctClueIdentification, "\(data.selectedIdentication)", "\(b.clue!.type!)"))

                                
                                b.setDataCheck(clue: selectedClue, type: .wrong)

                            }else{
                                if !wrongQuestionId.contains((b.clue?.id)!) {
                                    correctCount += 1
                                    b.setDataCheck(clue: selectedClue, type: .correct)
                                }
                            }
                        
                            
                        }
                    }
                }
                
                if b.clueDescLb.text == "" { // 선택을 안했을때도 오류처리

                    wrongs.append(b.clue!.type!)
                    wrongQuestionId.append((b.clue?.id)!)
                    wrongC.append((correctClueIdentification, "", "\(b.clue!.type!)"))

                    print("TYPEYEPEPEPEPE")

                    b.bubbleBaseView.image = UIImage.init(named: "balloonFail")
                    
                }
                
            }
            
            self.wrongQuestions = wrongC

            
            deskView.setData(region: _article.region ?? "GERMANY", wrongParts: wrongs)
            
            aStackView.addRows(bubbles)
            aStackView.addRow(deskView)
            
            aStackView.addRow(submitButton)
            submitButton.snp.makeConstraints { (make) in
                make.width.equalTo(200)
                make.height.equalTo(50)
                make.center.equalToSuperview()
            }
            
            if correctCount < 1  {
                submitButton.backgroundColor = .basicBackground
                submitButton.setTitleColor(.black, for: .normal)
                submitButton.setBorder(color: .black, width: 1.5)
            }
            
            
            if wrongQuestionId.isEmpty {
                backButton.isHidden = true
            }else{
                backButton.isHidden = false
            }
            
            aStackView.addRow(backButton)
            
        }
    }
    
    @objc func touchSubmitButton(sender:UIButton) {
        
        if correctCount > 0 {
            
            let myList = Array((RealmUser.shared.getUserData()?.factCheckList)!)

            _ = myList.map({
                
                fc in
                
                if let _checkdata = checkData {
                    
                    _ = _checkdata.map({
                        
                        if fc.selectedClue == $0.selectedClue && fc.selectedArticleId == $0.selectedArticleId {
                            try! realm.write {
                                fc.isSubmit = true
                            }
                        }
                    })
                    
                }
                
            })
            
            PopUp.callSubmitView(article: article!, tag: 1, correctCount: correctCount, questionCount: questionCount, vc: self)
        }
    }
    
    @objc func touchBackButton(sender:UIButton) {
        
        sender.isUserInteractionEnabled = false
        
        guard let vc = self.findBeforeVc(type: .clue) else {return}
        
        delegate?.moveTo(fromVc: self, toVc: vc, sendData:  (article!, five! , questionPoint!), direction: .backward)

        sender.isUserInteractionEnabled = true
    }
    
    
    func setData(_ data:[FactCheck], article:Article, five:[Five_W_One_Hs], questionPoint:String) {
        
        self.checkData = data
        self.article = article
        self.five = five
        self.questionPoint = questionPoint
     
    }
}

extension FactCheckViewController:ArticleSubmitDelegate {
    func publishArticlewith(hashtag: Int) {
        
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "CompleteArticleViewController") as? CompleteArticleViewController else {return}
        
        
        try! realm.write {

            if let saved = RealmArticle.shared.getAll().filter({$0.id == article!.id}).first {
                saved.isCompleted = true
                saved.selectedHashtag = hashtag
                saved.totalQuestionCount = questionCount
                saved.correctQuestionCount = correctCount
                _ = wrongQuestionId.map({
                    
                    saved.wrongQuestionsId.append($0)
                })
                
            }

            
            if let _a = self.parent as? GameViewController {
                
                _a.setScore()
            }
        
        
            
            
            // 이 시점에서 paired article 여부 체크해서 한번 더 띄워야함
            
            let unpairedCompletedIds = RealmArticle.shared.get(Standard.shared.getLocalized()).filter({!($0.isPairedArticle) && $0.isCompleted}).map({$0.id})

            if let articleLink = RealmArticleLink.shared.get(Standard.shared.getLocalized()).filter({$0.articles.contains(article!.id)}).first {
                                
                let ar = Array(articleLink.articles)
                
                if unpairedCompletedIds.contains(ar[0]) && unpairedCompletedIds.contains(ar[1]) {
                    print("Time To Paired Popup")
                    if let ar1 = RealmArticle.shared.getAll().filter({$0.id == ar[0]}).first,
                        let ar2 = RealmArticle.shared.getAll().filter({$0.id == ar[1]}).first {
                        
                            ar1.isPairedArticle = true
                            ar2.isPairedArticle = true

                        let point = (ar1.point + ar2.point) * 2
                        
                        RealmUser.shared.getUserData()?.score += point
                        
                        
                        if let _a = self.parent as? GameViewController {
                            
                            _a.setScore()
                        }
                        
                        if let local1 = RealmArticle.shared.get(Standard.shared.getLocalized()).filter({$0.id == ar1.id}).first, let local2 = RealmArticle.shared.get(Standard.shared.getLocalized()).filter({$0.id == ar2.id}).first {
                            PopUp.callPairedPopUp(articleLink: articleLink, left: local1, right:local2, earnPoint: point, vc: self)

                        }
                        
                        
                    }else{
                        delegate?.moveTo(fromVc: self, toVc: vc, sendData: (article, hashtag, wrongQuestionId, true), direction: .forward)
                    }
                }else{
                    delegate?.moveTo(fromVc: self, toVc: vc, sendData: (article, hashtag, wrongQuestionId, true), direction: .forward)
                }
            }else{
                delegate?.moveTo(fromVc: self, toVc: vc, sendData: (article, hashtag, wrongQuestionId, true), direction: .forward)
            }
        }
    }
    
}

extension FactCheckViewController:PairedPopupDelegate {
    func moveToNext(sender: UIButton) {
        
         guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "CompleteArticleViewController") as? CompleteArticleViewController else {return}
        delegate?.moveTo(fromVc: self, toVc: vc, sendData: (article,article?.selectedHashtag, wrongQuestionId, true), direction: .forward)
    }
    
    
}






enum FactCorrect:String {
    
    case wrong, correct, normal, empty
}
