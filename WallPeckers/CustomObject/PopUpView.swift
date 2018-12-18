//
//  PopUpView.swift
//  WallPeckers
//
//  Created by Seongchan Kang on 26/11/2018.
//  Copyright © 2018 KimJimin and Company. All rights reserved.
//

import Foundation
import UIKit
import AloeStackView

var TIMERTIME:Int?


class BasePopUpView:UIView {
    
    let baseView = UIView()
    let popupView = UIView()
    var popUpViewHeight:CGFloat = 340
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview([baseView, popupView])
        
        baseView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        baseView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        popupView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.leading.equalTo(40)
            make.height.equalTo(popUpViewHeight)
        }
        popupView.backgroundColor = .white

    }
    
    func setPopUpViewHeight(_ height:CGFloat) {
        popUpViewHeight = height
        popupView.snp.remakeConstraints { (make) in
            make.center.equalToSuperview()
            make.leading.equalTo(40)
            make.height.equalTo(popUpViewHeight)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

enum PopUpType:String {
    
    case level, badge
    
}

class LevelBadgePopUpView:BasePopUpView {
    
    let bgImageView = UIImageView()
    let mainImageView = UIImageView()
    let descLb = UILabel()
    let bottomButton = BottomButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    func setData(type:PopUpType, mainImage:UIImage, desc:String) {
        
        switch type {
        
        case .badge:
            bgImageView.image = UIImage.init(named: "badgeBackground")
            mainImageView.snp.remakeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.top.equalTo(100)
                make.width.equalTo(130)
                make.height.equalTo(190)
            }
        case .level:
            bgImageView.image = UIImage.init(named: "levelBackground")
            mainImageView.snp.remakeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.top.equalTo(170)
                make.width.equalTo(88)
                make.height.equalTo(88)
            }
        }
        
        mainImageView.image = mainImage
        descLb.text = desc
        
    }
    
    private func setUI() {
        
        self.popupView.addSubview([bgImageView, mainImageView, descLb, bottomButton])
        self.setPopUpViewHeight(450)
        
        bgImageView.snp.makeConstraints { (make) in
            make.leading.equalTo(15)
            make.top.equalTo(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(310)
        }
        mainImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(100)
            make.width.equalTo(130)
            make.height.equalTo(190)
        }
        
        bottomButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-20)
            make.width.equalTo(200)
            make.height.equalTo(44)
        }
        bottomButton.addTarget(self, action: #selector(removePopup), for: .touchUpInside)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func removePopup() {
        
        self.removeFromSuperview()
        
    }
}

class ArticleSubmitView:BasePopUpView {
    

    let hashTags = ["happy", "hopeful", "don't care", "sad", "frustrated"]
    let topStarView = UILabel()
    let centerInfoView = UIStackView()
    let descLb = UILabel()
    let hashTagBtnView = UIView()
    let publishButton = BottomButton()
    var hashBtns:[HashTagBtn] = []
    let centerLabel = UILabel()
    var delegate:ArticleSubmitDelegate?
    private var selectedHashTag:Int?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        
    }
    
    func setData(correctCount:Int, questionCount:Int) {
        
        var point = 0
        
        
        
        
        
        
        switch questionCount {
            
            
            
        case 1:
            topStarView.attributedText = "★".makeAttrString(font: .NotoSans(.bold, size: 45), color: .black)
            point = 100

        case 2:
            if correctCount == 1{
                topStarView.attributedText = "★  ☆".makeAttrString(font: .NotoSans(.bold, size: 45), color: .black)
                point = 150
//
            }else{
                topStarView.attributedText = "★  ★".makeAttrString(font: .NotoSans(.bold, size: 45), color: .black)
                point = 300

            }

        case 3:
            
            if correctCount == 1 {
                topStarView.attributedText = "☆  ★  ☆".makeAttrString(font: .NotoSans(.bold, size: 45), color: .black)
                point = 200

            }else if correctCount == 2 {
                topStarView.attributedText = "★  ☆  ★".makeAttrString(font: .NotoSans(.bold, size: 45), color: .black)
                point = 400

            }else {
                topStarView.attributedText = "★  ★  ★".makeAttrString(font: .NotoSans(.bold, size: 45), color: .black)
                point = 600

            }

        case 4:
            
            if correctCount == 1 {
                topStarView.attributedText = "★  ☆  ☆  ☆".makeAttrString(font: .NotoSans(.bold, size: 45), color: .black)
                point = 200

            }else if correctCount == 2 {
                topStarView.attributedText = "★  ★  ☆  ☆".makeAttrString(font: .NotoSans(.bold, size: 45), color: .black)
                point = 400

            }else if correctCount == 3 {
                topStarView.attributedText = "★  ★  ★  ☆".makeAttrString(font: .NotoSans(.bold, size: 45), color: .black)
                point = 600

            }else {
                topStarView.attributedText = "★  ★  ★  ★".makeAttrString(font: .NotoSans(.bold, size: 45), color: .black)
                point = 800

            }

        case 5:
            
            if correctCount == 1 {
                topStarView.attributedText = "☆  ☆  ★  ☆  ☆".makeAttrString(font: .NotoSans(.bold, size: 45), color: .black)
                point = 200

            }else if correctCount == 2 {
                topStarView.attributedText = "★  ★  ☆  ☆  ☆".makeAttrString(font: .NotoSans(.bold, size: 45), color: .black)
                point = 400

            }else if correctCount == 3 {
                topStarView.attributedText = "★  ★  ★  ☆  ☆".makeAttrString(font: .NotoSans(.bold, size: 45), color: .black)
                point = 600

            }else if correctCount == 4 {
                topStarView.attributedText = "★  ★  ★  ★  ☆".makeAttrString(font: .NotoSans(.bold, size: 45), color: .black)
                point = 800

            }else {
                topStarView.attributedText = "★  ★  ★  ★  ★".makeAttrString(font: .NotoSans(.bold, size: 45), color: .black)
                point = 1000

            }

        default:
            break
            
        }
        
        try! realm.write {
            RealmUser.shared.getUserData()?.score += point
        }
        
        let pointString = "\n\(point) P".makeAttrString(font: .AmericanTypeWriter(.bold, size: 49), color: .black)
        let articleString = correctCount != questionCount ? "GOOD ARTICLE".makeAttrString(font: .AmericanTypeWriter(.bold, size: 30), color: .black) : "PERFECT ARTICLE".makeAttrString(font: .AmericanTypeWriter(.bold, size: 30), color: .black)
        let aString = "".makeAttrString(font: .AmericanTypeWriter(.bold, size: 36), color: .black)
        aString.append(articleString)
        aString.append(pointString)
        
        self.centerLabel.attributedText = aString
        
    }
    
    private func setUI() {
        
        popupView.snp.remakeConstraints { (make) in
            make.top.equalTo(60)
            make.leading.equalTo(30)
            make.height.equalTo(450)
            make.centerX.equalToSuperview()
        }
        popupView.addSubview([topStarView, centerInfoView, descLb, hashTagBtnView, publishButton])
        
        topStarView.attributedText = "★  ☆  ★".makeAttrString(font: .NotoSans(.bold, size: 45), color: .black)
        topStarView.textAlignment = .center
        
        topStarView.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(45)
        }
        
        centerInfoView.snp.makeConstraints { (make) in
            make.top.equalTo(topStarView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(140)
        }
        centerInfoView.axis = .horizontal
        
        let leftWingImv = UIImageView.init(image: UIImage.init(named: "leftWing"))
        let rightWingImv = UIImageView.init(image: UIImage.init(named: "rightWing"))
        
        
        for v in [leftWingImv, centerLabel, rightWingImv] {
            
            centerInfoView.addArrangedSubview(v)
            
        }
        
        for i in 0...hashTags.count - 1 {
            
            let hashbtn = HashTagBtn()
            hashbtn.setTitle("# \(hashTags[i])", for: .normal)
            hashbtn.tag = i
            hashbtn.addTarget(self, action: #selector(touchHashtag(sender:)), for: .touchUpInside)
            hashBtns.append(hashbtn)
            hashTagBtnView.addSubview(hashbtn)
        }
        
        leftWingImv.snp.makeConstraints { (make) in
            make.width.equalTo(50)
            make.top.equalToSuperview()
        }
        rightWingImv.snp.makeConstraints { (make) in
            make.width.equalTo(50)
            make.top.equalToSuperview()
        }
        centerLabel.text = "a\n b\n c"
        centerLabel.numberOfLines = 0
        centerLabel.textAlignment = .center
    
        leftWingImv.contentMode = .top
        rightWingImv.contentMode = .top
        
        descLb.snp.makeConstraints { (make) in
            make.top.equalTo(centerInfoView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.7)
        }
//        descLb.setBorder(color: .black, width: 1)
        descLb.text = "Pick your #hashtag for \nyour article."
        descLb.textAlignment = .center
        descLb.numberOfLines = 2
        
        hashTagBtnView.snp.makeConstraints { (make) in
            make.top.equalTo(descLb.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(100)
        }
        
//        for i in hashb
        
        hashBtns[0].snp.makeConstraints { (make) in
            make.leading.equalTo(10)
            make.top.equalToSuperview()
            make.width.equalTo(82)
            make.height.equalTo(42)
        }
        
        hashBtns[2].snp.makeConstraints { (make) in
            make.trailing.equalTo(-10)
            make.height.equalTo(42)
            make.top.equalToSuperview()
            make.width.equalTo(115)
        }
        
        
        hashBtns[1].snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.height.equalTo(42)
            make.leading.equalTo(hashBtns[0].snp.trailing).offset(10)
            make.trailing.equalTo(hashBtns[2].snp.leading).offset(-10)
        }
        
        hashBtns[3].snp.makeConstraints { (make) in
            make.top.equalTo(hashBtns[0].snp.bottom).offset(10)
            make.width.equalTo(80)
            make.height.equalTo(42)
            make.leading.equalTo(60)
        }
        hashBtns[4].snp.makeConstraints { (make) in
            make.trailing.equalTo(-60)
            make.top.equalTo(hashBtns[0].snp.bottom).offset(10)
            make.leading.equalTo(hashBtns[3].snp.trailing).offset(10)
            make.height.equalTo(42)
        }
        
        publishButton.snp.makeConstraints { (make) in
            make.top.equalTo(hashTagBtnView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-20)
            make.width.equalToSuperview().multipliedBy(0.7)
            make.height.equalTo(43)
        }
        
        publishButton.setTitle("PUBLISH THE ARTICLE", for: .normal)

        
        
//        centerInfoView.adda
        publishButton.addTarget(self, action: #selector(removeView), for: .touchUpInside)
        
        
        hashTagBtnView.backgroundColor = .sunnyYellow
        popupView.backgroundColor = .sunnyYellow
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func removeView() {
        
        guard let ht = selectedHashTag else {return}
        delegate?.publishArticlewith(hashtag: ht)
        self.removeFromSuperview()
    }
    
    @objc func touchHashtag(sender:HashTagBtn) {
        
        for i in hashBtns {
            
            i.isSelected = false
        }
    
        sender.isSelected = !(sender.isSelected)
    
        selectedHashTag = sender.tag
        print(sender.tag)
        
    }
    
}

protocol ArticleSubmitDelegate {
    
    func publishArticlewith(hashtag:Int)
    
}

final class HashTagBtn:UIButton {
    
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.backgroundColor = .black
            }else{
                self.backgroundColor = UIColor.init(white: 216/255, alpha: 1)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    func setUI() {
        self.backgroundColor = UIColor.init(white: 216/255, alpha: 1)
        self.setBorder(color: .black, width: 1.5, cornerRadius: 8)
        self.titleLabel?.font = UIFont.AmericanTypeWriter(.regular, size: 19)
        self.titleLabel?.adjustsFontSizeToFitWidth = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}


class SelectPopUpView:BasePopUpView {
    

    let titleView = UIView()
    let titleLb = UILabel()
    let buttonView = AloeStackView()
    let bottomView = UIView()
    let confirmBtn = UIButton()
    var delegate:SelectPopupDelegate?
     
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    private func setUI() {
        
        popupView.addSubview([titleView, buttonView, bottomView])
        
        titleView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.leading.equalTo(0)
            make.centerX.equalToSuperview()
            make.height.equalTo(70)
        }
        titleView.backgroundColor = .white
        
        titleView.addSubview(titleLb)
        
        titleLb.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(20)
            make.leading.equalTo(30)
            make.height.equalTo(50)
        }
        
        titleLb.backgroundColor = .black
        
        bottomView.snp.makeConstraints { (make) in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(80)
        }
        
        bottomView.addSubview(confirmBtn)
        
        confirmBtn.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
        buttonView.snp.makeConstraints { (make) in
            make.top.equalTo(titleView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(60)
            make.bottom.equalTo(bottomView.snp.top).offset(-10)
        }
        buttonView.separatorColor = .black
        buttonView.separatorHeight = 2
        buttonView.separatorInset = .init(top: 0, left: 20, bottom: 0, right: 20)
        
        confirmBtn.addTarget(self, action: #selector(bottomBtnTouched(sender:)), for: .touchUpInside)
        
    }
    
    func setButton(selectedButton:[String], bottomBtn:String) {
        
        confirmBtn.setAttributedTitle(bottomBtn.makeAttrString(font: .NotoSans(.medium, size: 20), color: .white), for: .normal)

        
        buttonView.snp.updateConstraints { (make) in
            make.height.equalTo(selectedButton.count * 60)
        }
        for i in 0...selectedButton.count - 1 {
            
            let button = UIButton()
            
            button.setAttributedTitle(selectedButton[i].makeAttrString(font: .NotoSans(.medium, size: 18), color: .black), for: .normal)
            button.setAttributedTitle(selectedButton[i].makeAttrString(font: .NotoSans(.medium, size: 18), color: .white), for: .selected)

//            button.setTitle(, for: .normal)
            button.tag = i
//            button.setBackgroundColor(color: .gray, forState: .selected)
            button.setTitleColor(.black, for: .normal)
            button.addTarget(self, action: #selector(selectBtnTouched(sender:)), for: .touchUpInside)
            buttonView.addRow(button)

        }
        
    }
    
    @objc func bottomBtnTouched(sender:UIButton) {
        
        delegate?.bottomButtonTouched(sender: sender)

    }
    
    func clear() {
        
        for i in buttonView.subviews[0].subviews {
            i.subviews[0].backgroundColor = .white
            let a = i.subviews[0] as! UIButton
            a.isSelected = false
        }
    }
    
    @objc func selectBtnTouched(sender:UIButton) {
        clear()
        sender.isSelected = !(sender.isSelected)
        
        sender.backgroundColor = .black
        delegate?.selectButtonTouched(tag: sender.tag)
        
        
    }
    
    func bottomButtonType(_ type:Int) {
        if type == 0 {
            confirmBtn.backgroundColor = .black
            confirmBtn.setTitleColor(.white, for: .normal)
        }else if type == 1 {
            confirmBtn.backgroundColor = .white
            confirmBtn.setTitleColor(.black, for: .normal)
            confirmBtn.setBorder(color: .black, width: 1, cornerRadius: 3)
        }else{
            
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

protocol SelectPopupDelegate {
    func bottomButtonTouched(sender:UIButton)
    func selectButtonTouched(tag:Int)
    
}

class AlertPopUpView:BasePopUpView {
 
    let timeLb = UILabel()
    let descLb = UILabel()
    let bottomButton = BottomButton()
    var delegate:AlerPopupViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    func setUI() {
        
        self.setPopUpViewHeight(250)
        popupView.addSubview([timeLb, descLb, bottomButton])
        
        timeLb.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
        }
        descLb.snp.makeConstraints { (make) in
//            make.top.equalTo(timeLb.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-10)
            make.leading.equalTo(32)
        }
        bottomButton.snp.makeConstraints { (make) in
//            make.top.equalTo(descLb.snp.bottom).offset(10)
            make.width.equalTo(200)
            make.height.equalTo(43)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-24)
        }
        bottomButton.addTarget(self, action: #selector(tapButton(sender:)), for: .touchUpInside)
    }
    
    @objc func tapButton(sender:AlertPopUpView) {
//        self.removeFromSuperview()
        delegate?.tapBottomButton(sender: self)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

protocol AlerPopupViewDelegate {
    
    func tapBottomButton(sender:AlertPopUpView)
}


struct PopUp {
    
    static func levelBadgePopup(vc:UIViewController) {
        
        let popupView = LevelBadgePopUpView()

        if let _parent = vc.parent {
            _parent.view.addSubview(popupView)
        }else{
            vc.view.addSubview(popupView)
        }
        
        popupView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
    }
    
    static func callSubmitView(tag:Int, correctCount:Int, questionCount:Int, vc:UIViewController) {
        
        let popupView = ArticleSubmitView()
        popupView.delegate = vc as? ArticleSubmitDelegate
        popupView.setData(correctCount: correctCount, questionCount: questionCount)
        if let _parent = vc.parent {
            _parent.view.addSubview(popupView)
        }else{
            vc.view.addSubview(popupView)
        }
        
        popupView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
    }
    
    static func callCluePopUp(clueType:String, tag:Int, vc:UIViewController) {
        
        let popupView = CluePopUpView()
        
        
        if let _parent = vc.parent {
            _parent.view.addSubview(popupView)
        }else{
            vc.view.addSubview(popupView)

        }
            
        popupView.delegate = vc as? CluePopUpViewDelegate
        popupView.tag = tag
        popupView.titleLb.attributedText = clueType.makeAttrString(font: .NotoSans(.medium, size: 20), color: .black)
        popupView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        
    }
    
    static func callAlert(time:String, desc:String, vc:UIViewController, tag:Int) {
        
        let popUpView = AlertPopUpView()
        
        vc.view.addSubview(popUpView)
        popUpView.timeLb.setNotoText(time, size: 12, textAlignment: .center)
        popUpView.descLb.setNotoText(desc, size: 12, textAlignment: .center)
        popUpView.delegate = vc as? AlerPopupViewDelegate
        popUpView.tag = tag
        
        popUpView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
    }
    
    static func call(mainTitle:String, selectButtonTitles:[String], bottomButtonTitle:String, bottomButtonType:Int,
                     _ vc:UIViewController) {
        
        let popUpView = SelectPopUpView()
        
        vc.view.addSubview(popUpView)
        popUpView.titleLb.setNotoText(mainTitle, color: .white, size: 20, textAlignment: .center)
        popUpView.delegate = vc as? SelectPopupDelegate
        
        
        popUpView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        popUpView.setButton(selectedButton: selectButtonTitles, bottomBtn: bottomButtonTitle)
        popUpView.bottomButtonType(bottomButtonType)
        popUpView.popupView.setBorder(color: .black, width: 5)
        
    }
}
