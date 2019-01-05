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

class EmailPopupView:BasePopUpView, UITextFieldDelegate {
    
    let titleLb = UILabel()
    let okButton = BottomButton()
    let cancelButton = BottomButton()
    var delegate:TwobuttonAlertViewDelegate?
    var emailTf = LeftPaddedTextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        
    }
    
    private func setUI() {
//        emailTf.delegate = se
//        emailTf.textAlignment = .cent
        self.setPopUpViewHeight(300)
        self.popupView.setBorder(color: .black, width: 3.5)
        self.popupView.addSubview([titleLb, emailTf, okButton, cancelButton])
        
        titleLb.snp.makeConstraints { (make) in
            make.top.left.equalTo(20)
            make.trailing.equalTo(-10)
            make.height.equalTo(55)
        }
        emailTf.keyboardType = .emailAddress
        
        emailTf.snp.makeConstraints { (make) in
            make.leading.equalTo(10)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(30)
        }
        emailTf.addUnderBar()
        
        titleLb.backgroundColor = .black
        titleLb.attributedText = "inputemaildialog_email".localized.makeAttrString(font: .NotoSans(.medium, size: 25), color: .white)
        titleLb.textAlignment = .center
        
        cancelButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(-20)
            make.leading.equalTo(30)
            make.centerX.equalToSuperview()
            make.height.equalTo(DeviceSize.width > 320 ? 42 : 32)
        }
        okButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(cancelButton.snp.top).offset(-10)
            make.leading.equalTo(30)
            make.centerX.equalToSuperview()
            make.height.equalTo(cancelButton.snp.height)
        }
        
        okButton.setTitle("OK".localized, for: .normal)
        cancelButton.setAttributedTitle("CANCEL".localized.makeAttrString(font: .NotoSans(.bold, size: 20), color: .white), for: .normal)
        cancelButton.setBorder(color: .black, width: 1.5)
        okButton.addTarget(self, action: #selector(touchOk(sender:)), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(touchCancel(sender:)), for: .touchUpInside)
        
    }
    
    @objc func touchOk(sender:UIButton) {
        sender.isUserInteractionEnabled = false
        
        
        if emailTf.text != "" {
            delegate?.tapOk(sender: emailTf.text ?? "")
            self.removeFromSuperview()
        }
        
        sender.isUserInteractionEnabled = true
    }
    
    @objc func touchCancel(sender:UIButton) {
        self.removeFromSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class AlertTwoButtonView:BasePopUpView {
    
    let descLb = UILabel()
    let okButton = BottomButton()
    let cancelButton = UIButton()
    var delegate:TwobuttonAlertViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        
    }
    
    private func setUI() {
        
        self.setPopUpViewHeight(310)
        self.popupView.setBorder(color: .black, width: 1.5)
        self.popupView.addSubview([descLb, okButton, cancelButton])
        
        descLb.snp.makeConstraints { (make) in
            make.top.equalTo(20)
            make.leading.equalTo(5)
            make.centerX.equalToSuperview()
        }
        
        descLb.numberOfLines = 0
        descLb.textAlignment = .center
        
        cancelButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(-10)
            make.leading.equalTo(30)
            make.centerX.equalToSuperview()
            make.height.equalTo(DeviceSize.width > 320 ? 42 : 32)
        }
        okButton.snp.makeConstraints { (make) in
            make.top.equalTo(descLb.snp.bottom).offset(10)
            make.bottom.equalTo(cancelButton.snp.top).offset(-10)
            make.leading.equalTo(30)
            make.centerX.equalToSuperview()
            make.height.equalTo(cancelButton.snp.height)
//            make.height.equalTo(42)
        }
        descLb.attributedText = "inputkeydialog_description".localized.makeAttrString(font: .NotoSans(.medium, size: 16), color: .black)
        okButton.setTitle("OK".localized, for: .normal)
        cancelButton.setAttributedTitle("CANCEL".localized.makeAttrString(font: .NotoSans(.bold, size: 20), color: .black), for: .normal)
        cancelButton.setBorder(color: .black, width: 1.5)
        okButton.addTarget(self, action: #selector(touchOk(sender:)), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(touchCancel(sender:)), for: .touchUpInside)
        
    }
    
    @objc func touchOk(sender:UIButton) {
        sender.isUserInteractionEnabled = false
        delegate?.tapOk(sender: sender)
        self.removeFromSuperview()
        sender.isUserInteractionEnabled = true
    }
    
    @objc func touchCancel(sender:UIButton) {
        self.removeFromSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

protocol TwobuttonAlertViewDelegate {
    func tapOk(sender:Any)
}

enum PopUpType:String {
    
    case level, badge
    
}

class LevelBadgePopUpView:BasePopUpView {
    
    let bgImageView = UIImageView()
    let mainImageView = UIImageView()
    let topLb = UILabel()
    let descLb = UILabel()
    let bottomButton = BottomButton()
    var delegate:CallBadgeDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    
    func setData(type:PopUpType, mainImage:UIImage, desc:String, tag:Int) {
        
        self.tag = tag
        switch type {
        
        case .badge:
            bgImageView.image = UIImage.init(named: "badgeBackground")
            mainImageView.snp.remakeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.top.equalTo(100)
                make.width.equalTo(130)
                make.height.equalTo(190)
            }
            topLb.attributedText = "badgeTitle".localized.makeAttrString(font: .AmericanTypeWriter(.bold, size: 32), color: .black)
            
        case .level:
            bgImageView.image = UIImage.init(named: "levelBackground")
            mainImageView.snp.remakeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.top.equalTo(170)
                make.width.equalTo(88)
                make.height.equalTo(88)
            }
            topLb.attributedText = "levelUpTitle".localized.makeAttrString(font: .AmericanTypeWriter(.bold, size: 32), color: .black)

        }
        
        mainImageView.image = mainImage
        mainImageView.contentMode = .center
        descLb.text = desc
        
    }
    
    private func setUI() {
        
        self.popupView.addSubview([bgImageView, mainImageView, descLb, bottomButton, topLb])
        self.popupView.setBorder(color: .black, width: 2.5)
        self.setPopUpViewHeight(450)
        
        bgImageView.snp.makeConstraints { (make) in
            make.leading.equalTo(15)
            make.top.equalTo(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(310)
        }
       
        topLb.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(60)
        }
        
        mainImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(100)
            make.width.equalTo(130)
            make.height.equalTo(190)
        }
        
  
        descLb.numberOfLines = 0
        
        bottomButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-20)
            make.width.equalTo(200)
            make.height.equalTo(44)
        }
        
        descLb.snp.makeConstraints { (make) in
            make.bottom.equalTo(bottomButton.snp.top).offset(-20)
            make.leading.equalTo(20)
            make.centerX.equalToSuperview()
        }
        descLb.textAlignment = .center
        
        bottomButton.setTitle("OK".localized, for: .normal)
        bottomButton.addTarget(self, action: #selector(removePopup), for: .touchUpInside)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func removePopup() {
        
        delegate?.callCompleteBadge(tag: self.tag)
        self.removeFromSuperview()
        
    }
}

protocol CallBadgeDelegate {
    func callCompleteBadge(tag:Int)
}

class PairedArticleView:BasePopUpView {
    
    let topStackView = UIStackView()
    let leftArticle = ArticleSelectButton()
    let rightArticle = ArticleSelectButton()
    let linkView = UIView()
    let pointLb = UILabel()
    let descLb = UILabel()
    let okButton = BottomButton()
    var delegate:PairedPopupDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    private func setUI() {
        
        popupView.snp.remakeConstraints { (make) in
            make.center.equalToSuperview()
            make.leading.equalTo(30)
//            make.height.equalTo(popUpViewHeight)
        }
        self.popupView.addSubview([topStackView, leftArticle, rightArticle, linkView, pointLb, descLb, okButton])
        
        let leftWingImv = UIImageView.init(image: UIImage.init(named: "leftWing"))
        let rightWingImv = UIImageView.init(image: UIImage.init(named: "rightWing"))
        let infoLb = UILabel()
        
        topStackView.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.leading.equalTo(10)
            make.trailing.equalTo(-10)
            make.height.equalTo(120)
        }
        
        topStackView.addArrangedSubview(leftWingImv)
        topStackView.addArrangedSubview(infoLb)
        topStackView.addArrangedSubview(rightWingImv)
        infoLb.textAlignment = .center
        
        leftWingImv.snp.makeConstraints { (make) in
            make.width.equalTo(50)
            make.top.equalToSuperview()
        }
        rightWingImv.snp.makeConstraints { (make) in
            make.width.equalTo(50)
            make.top.equalToSuperview()
        }
        
        leftWingImv.contentMode = .top
        rightWingImv.contentMode = .top
        
        leftArticle.borderColor = .black
        rightArticle.borderColor = .black
        okButton.addTarget(self, action: #selector(tapOkButton(sender:)), for: .touchUpInside)
        
        infoLb.attributedText = "paireddialog_title".localized.makeAttrString(font: .AmericanTypeWriter(.bold, size: DeviceSize.width > 320  ? 32 : 28), color: .black)
        infoLb.numberOfLines = 0
        infoLb.adjustsFontSizeToFitWidth = true
        
        leftArticle.snp.makeConstraints { (make) in
            make.top.equalTo(topStackView.snp.bottom).offset(10)
            make.leading.equalTo(DeviceSize.width > 320 ? 40 : 30)
            make.width.height.equalTo(iconWidth)
        }
        
        rightArticle.snp.makeConstraints { (make) in
            make.top.equalTo(topStackView.snp.bottom).offset(10)
            make.trailing.equalTo(DeviceSize.width > 320 ? -40 : -30)
            make.width.height.equalTo(iconWidth)
        }
        
        linkView.snp.makeConstraints { (make) in
            make.centerY.equalTo(rightArticle.snp.centerY)
            make.leading.equalTo(leftArticle.snp.trailing)
            make.trailing.equalTo(rightArticle.snp.leading)
            make.height.equalTo(15)
            
        }
        linkView.backgroundColor = .black
        
        pointLb.snp.makeConstraints { (make) in
            make.top.equalTo(rightArticle.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        descLb.snp.makeConstraints { (make) in
            make.leading.equalTo(10)
            make.top.equalTo(pointLb.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        descLb.textAlignment = .center
        descLb.numberOfLines = 0
        
        self.popupView.setBorder(color: .black, width: 2.5)
        okButton.setTitle("OK".localized, for: .normal)
        okButton.snp.makeConstraints { (make) in
            make.top.equalTo(descLb.snp.bottom).offset(10)
            make.bottom.equalTo(-20)
            make.leading.equalTo(50)
            make.height.equalTo(40)
            make.centerX.equalToSuperview()
        }
        
    }
    
    @objc func tapOkButton(sender:UIButton) {
        self.removeFromSuperview()
        delegate?.moveToNext(sender: sender)
    }
    
    func setData(articleLink:ArticleLink, left:Article, right:Article, earnPoint:Int) {
        
        self.descLb.attributedText = articleLink.desc!.makeAttrString(font: .NotoSans(.medium, size: 17), color: .black)
        self.pointLb.attributedText = "+ \(earnPoint) P".makeAttrString(font: .AmericanTypeWriter(.bold, size: 33), color: .black)
        let color = LineColor.init(rawValue: articleLink.color!)
        
        
        self.leftArticle.setData(point: "\(left.point) P", textColor: .black, title: left.title!, isStar: true, tag: 0)
        self.rightArticle.setData(point: "\(right.point) P", textColor: .black, title: right.title!, isStar: true, tag: 0)
        self.leftArticle.isUserInteractionEnabled = false
        self.rightArticle.isUserInteractionEnabled = false
        
        changeColor(color!)

    }
    
    func changeColor(_ LineColor:LineColor) {
        
        func change(color:UIColor) {
            
            self.popupView.backgroundColor = color
            self.leftArticle.pointTitleLb.textColor = color
            self.rightArticle.pointTitleLb.textColor = color
            self.leftArticle.titleLb.textColor = color
            self.rightArticle.titleLb.textColor = color
            
        }
        
        switch LineColor {
        case .BLUE:
            change(color: .niceBlue)
        case .GREEN:
            change(color: .darkGrassGreen)
        case .ORANGE:
            change(color: .tangerine)
        case .RED:
            change(color: .scarlet)
        }
        
        

        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

protocol PairedPopupDelegate {
    func moveToNext(sender:UIButton)
}

class ArticleSubmitView:BasePopUpView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    class HashtagCollectionViewCell:UICollectionViewCell {
        
        let lbl = UILabel()
        
        override var isSelected: Bool {
            didSet {
                self.backgroundColor = isSelected ? UIColor.black : UIColor.init(white: 216/255, alpha: 1)
                self.lbl.textColor = isSelected ? UIColor.white : .black
            }
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setUI()
        }
        
        private func setUI() {
            self.addSubview(lbl)
            lbl.snp.makeConstraints { (make) in
               make.height.equalTo(30)
                make.leading.equalTo(5)
                make.trailing.equalTo(-5)
                make.top.equalTo(5)
                make.bottom.equalTo(-5)
            }
            self.setBorder(color: .black, width: 1.5, cornerRadius: 8)
            self.backgroundColor = UIColor.init(white: 216/255, alpha: 1)
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize.init(width: 100, height: 40)
//    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item)
        selectedHashTag = indexPath.item
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HashtagCollectionViewCell", for: indexPath) as? HashtagCollectionViewCell {
            
            
            if Standard.shared.getLocalized() == .KOREAN {
                
                cell.lbl.attributedText = hashTags[indexPath.item].makeAttrString(font: .AmericanTypeWriter(.regular, size: DeviceSize.width > 320 ? 18 : 16), color: .black)
            }else{
                
                cell.lbl.attributedText = hashTags[indexPath.item].makeAttrString(font: .AmericanTypeWriter(.regular, size: DeviceSize.width > 320 ? 16 : 14), color: .black)
            }
            
            
            
            
            return cell
        }else{
            return UICollectionViewCell()
        }
    }
    
    

    let hashTags = ["hash1".localized, "hash2".localized, "hash3".localized, "hash4".localized, "hash5".localized]
    let topStarView = UILabel()
    let centerInfoView = UIStackView()
    let descLb = UILabel()
    let hashTagBtnView = UIView()
    let coLayout = CenterAlignedCollectionViewFlowLayout()
    lazy var collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: coLayout)
    let publishButton = BottomButton()
    var hashBtns:[HashTagBtn] = []
    let centerLabel = UILabel()
    var delegate:ArticleSubmitDelegate?
    private var selectedHashTag:Int?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        collectionView.delegate = self
        collectionView.dataSource = self
        coLayout.estimatedItemSize = CGSize.init(width: 100, height: 40)
        coLayout.itemSize = CGSize.init(width: 50, height: 40)
        collectionView.collectionViewLayout = coLayout
        collectionView.backgroundColor = .sunnyYellow
        collectionView.register(HashtagCollectionViewCell.self, forCellWithReuseIdentifier: "HashtagCollectionViewCell")
        setUI()
        
    }
    
    
    func setData(article:Article, correctCount:Int, questionCount:Int) {
        
        self.popupView.setBorder(color: .black, width: 2.5)
        var point = 0

        switch questionCount {

        case 1:
            topStarView.attributedText = "★".makeAttrString(font: .NotoSans(.bold, size: 45), color: .black)
            point = 100

        case 2:
            if correctCount == 1{
                topStarView.attributedText = "★  ☆".makeAttrString(font: .NotoSans(.bold, size: 45), color: .black)
                point = 150
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
//            article.point = point
            
            if let saved = RealmArticle.shared.getAll().filter({$0.id == article.id}).first {
                saved.point = point
            }
            
        }
        
        let pointString = "\n\(point) P".makeAttrString(font: .AmericanTypeWriter(.bold, size: 49), color: .black)
        let articleString = correctCount != questionCount ? "factcheckdialog_title".localized.makeAttrString(font: .AmericanTypeWriter(.bold, size: DeviceSize.width > 320 ? 26 : 20), color: .black) : "factcheckdialog_perfecttitle".localized.makeAttrString(font: .AmericanTypeWriter(.bold, size: DeviceSize.width > 320 ? 30 : 20), color: .black)
        let aString = "".makeAttrString(font: .AmericanTypeWriter(.bold, size: 36), color: .black)
        aString.append(articleString)
        aString.append(pointString)
        
        self.centerLabel.numberOfLines = 4
        self.centerLabel.adjustsFontSizeToFitWidth = true
        self.centerLabel.attributedText = aString
        
        collectionView.reloadData()

        
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
//
//        for i in 0...hashTags.count - 1 {
//
//            let hashbtn = HashTagBtn()
//            hashbtn.setTitle("\(hashTags[i])", for: .normal)
//            hashbtn.tag = i
//            hashbtn.addTarget(self, action: #selector(touchHashtag(sender:)), for: .touchUpInside)
//            hashBtns.append(hashbtn)
////            hashTagBtnView.addSubview(hashbtn)
//        }
        
        leftWingImv.snp.makeConstraints { (make) in
            make.width.equalTo(50)
            make.top.equalToSuperview()
        }
        rightWingImv.snp.makeConstraints { (make) in
            make.width.equalTo(50)
            make.top.equalToSuperview()
        }
        centerLabel.numberOfLines = 0
        centerLabel.textAlignment = .center
    
        leftWingImv.contentMode = .top
        rightWingImv.contentMode = .top
        
        descLb.snp.makeConstraints { (make) in
            make.top.equalTo(centerInfoView.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
        }
//        descLb.setBorder(color: .black, width: 1)
        descLb.text = "factcheckdialog_hashguide".localized
        descLb.textAlignment = .center
        descLb.numberOfLines = 2
        descLb.adjustsFontSizeToFitWidth = true
        
        hashTagBtnView.snp.makeConstraints { (make) in
            make.top.equalTo(descLb.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(100)
        }
        
        hashTagBtnView.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.leading.equalTo(10)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
//        for i in hashb
//
//        hashBtns[0].snp.makeConstraints { (make) in
//            make.leading.equalTo(10)
//            make.top.equalToSuperview()
//            make.width.equalTo(DeviceSize.width > 320 ? 82 : 62)
//            make.height.equalTo(42)
//        }
//
//        hashBtns[2].snp.makeConstraints { (make) in
//            make.trailing.equalTo(-10)
//            make.height.equalTo(42)
//            make.top.equalToSuperview()
//            make.width.equalTo(DeviceSize.width > 320 ? 115 : 80)
//        }
//
//
//        hashBtns[1].snp.makeConstraints { (make) in
//            make.top.equalToSuperview()
//            make.height.equalTo(42)
//            make.leading.equalTo(hashBtns[0].snp.trailing).offset(10)
//            make.trailing.equalTo(hashBtns[2].snp.leading).offset(-10)
//        }
//
//        hashBtns[3].snp.makeConstraints { (make) in
//            make.top.equalTo(hashBtns[0].snp.bottom).offset(10)
//            make.width.equalTo(80)
//            make.height.equalTo(42)
//            make.leading.equalTo(DeviceSize.width > 320 ? 60 : 30)
//        }
//        hashBtns[4].snp.makeConstraints { (make) in
//            make.trailing.equalTo(DeviceSize.width > 320 ? -60 : -20)
//            make.top.equalTo(hashBtns[0].snp.bottom).offset(10)
//            make.leading.equalTo(hashBtns[3].snp.trailing).offset(10)
//            make.height.equalTo(42)
//        }
        
        publishButton.snp.makeConstraints { (make) in
            make.top.equalTo(hashTagBtnView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-20)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(43)
        }
        
//        publishButton.setTitle("PUBLISH THE ARTICLE", for: .normal)
        publishButton.setAttributedTitle("factcheckdialog_reportbtn".localized.makeAttrString(font: .NotoSans(.bold, size: DeviceSize.width > 320 ? 19 : 16), color: .white), for: .normal)

        
        
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
        self.titleLabel?.font = UIFont.AmericanTypeWriter(.regular, size: DeviceSize.width > 320 ? 19 : 15)
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
    
    func setButton(selectedButton:[String], bottomBtn:String, buttonImages:[UIImage]?) {
        
        confirmBtn.setAttributedTitle(bottomBtn.makeAttrString(font: .NotoSans(.medium, size: 20), color: .white), for: .normal)

        
        buttonView.snp.updateConstraints { (make) in
            make.height.equalTo(selectedButton.count * 70)
        }
        if let _ = buttonImages {
            self.setPopUpViewHeight(380)
        }else{
            buttonView.snp.updateConstraints { (make) in
                make.height.equalTo(selectedButton.count * 60)
            }

        }
        buttonView.isScrollEnabled = false
//        buttonView.al

        self.layoutIfNeeded()
        for i in 0...selectedButton.count - 1 {
            
            let button = UIButton()
            
            button.setAttributedTitle("  \(selectedButton[i])".makeAttrString(font: .NotoSans(.medium, size: 18), color: .black), for: .normal)
            button.setAttributedTitle("  \(selectedButton[i])".makeAttrString(font: .NotoSans(.medium, size: 18), color: .white), for: .selected)
        
            if let _btnimgs = buttonImages {
                button.setImage(_btnimgs[i], for: .normal)
                button.setImage(_btnimgs[i].tinted(with: .white), for: .selected)

            }
            button.tag = i
            button.setTitleColor(.black, for: .normal)
            button.addTarget(self, action: #selector(selectBtnTouched(sender:)), for: .touchUpInside)
            buttonView.addRow(button)

            button.snp.makeConstraints { (make) in
                make.top.equalTo(5)
                make.leading.equalTo(20)
                make.trailing.equalTo(-20)
                make.bottom.equalTo(-5)
                if let _ = buttonImages {
                    make.height.equalTo(60)
                }else{
                    make.height.equalTo(50)
                }
            }
            
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
        self.popupView.setBorder(color: .black, width: 2.5)

        timeLb.snp.makeConstraints { (make) in
            make.top.equalTo(50)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
        }
        timeLb.textAlignment = .center
        descLb.textAlignment = .center
        descLb.numberOfLines = 0
        descLb.snp.makeConstraints { (make) in
            make.top.equalTo(timeLb.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
//                make.centerY.equalToSuperview().offset(-10)
            make.leading.equalTo(32)
        }
        bottomButton.snp.makeConstraints { (make) in
//            make.top.equalTo(descLb.snp.bottom).offset(10)
            make.width.equalTo(200)
            make.height.equalTo(43)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-24)
        }
        bottomButton.setTitle("OK".localized, for: .normal)
        bottomButton.addTarget(self, action: #selector(tapButton(sender:)), for: .touchUpInside)
    }
    
    func setData(title:String, desc:String) {
        self.timeLb.attributedText = title.makeAttrString(font: .NotoSans(.bold, size: 48), color: .black)
        self.descLb.attributedText = desc.makeAttrString(font: .NotoSans(.bold, size: 18), color: .black)
        
        if title == "" {
            
            self.setPopUpViewHeight(220)

            descLb.snp.remakeConstraints { (make) in
                make.centerY.equalToSuperview().offset(-30)
                make.centerX.equalToSuperview()
                make.leading.equalTo(20)
            }
            bottomButton.snp.makeConstraints { (make) in
                //            make.top.equalTo(descLb.snp.bottom).offset(10)
                make.width.equalTo(200)
                make.height.equalTo(43)
                make.centerX.equalToSuperview()
                make.bottom.equalTo(-10)
            }
            self.layoutSubviews()
            self.layoutIfNeeded()

        }
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

final class CluePopUpView:UIView, UITextFieldDelegate {
    
    let baseView = UIView()
    let popupView = UIView()
    let titleLb = UILabel()
    let codeLb = UILabel()
    let codeTf = LeftPaddedTextField()
    let okButton = BottomButton()
    var delegate:CluePopUpViewDelegate?
    let keyboardResigner = UITapGestureRecognizer()
    override init(frame: CGRect) {
        super.init(frame: frame)
        codeTf.delegate = self
        setUI()
    }
    
    @objc func keyboardRemove(){
        codeTf.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        UIView.animate(withDuration: 0.5) {
            self.popupView.snp.updateConstraints { (make) in
                make.centerY.equalToSuperview().offset(-50)
                
            }
            self.layoutIfNeeded()
            
        }
        
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            self.popupView.snp.updateConstraints { (make) in
                make.centerY.equalToSuperview()
            }
            self.layoutIfNeeded()
            
        }
        
    }
    
    private func setUI(){
        
        keyboardResigner.addTarget(self, action: #selector(keyboardRemove))
        self.addSubview([baseView, popupView])
        self.addGestureRecognizer(keyboardResigner)
        baseView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        baseView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        
        popupView.snp.makeConstraints { (make) in
            
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
            make.leading.equalTo(30)
            make.height.equalTo(330)
        }
        popupView.addSubview([titleLb, codeLb, codeTf, okButton])
        popupView.backgroundColor = .white
        codeTf.keyboardType = .numberPad
        
        okButton.snp.makeConstraints { (make) in
            make.leading.equalTo(30)
            make.bottom.equalTo(-20)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
        }
        okButton.setTitle("OK".localized, for: .normal)
        titleLb.snp.makeConstraints { (make) in
            make.top.equalTo(20)
            make.leading.equalTo(30)
            make.centerX.equalToSuperview()
            make.height.equalTo(55)
        }
        titleLb.setBorder(color: .black, width: 1.5)
        codeLb.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalTo(40)
        }
        
        codeLb.attributedText = "CODE".localized.makeAttrString(font: .NotoSans(.medium, size: 18), color: .black)
        codeTf.snp.makeConstraints { (make) in
            make.leading.equalTo(codeLb.snp.trailing).offset(10)
            make.trailing.equalTo(-40)
            make.centerY.equalTo(codeLb.snp.centerY)
        }
        codeTf.addUnderBar()
        codeTf.font = UIFont.NotoSans(.bold, size: 31)
        
        popupView.setBorder(color: .black, width: 2.5)
        titleLb.textAlignment = .center
        okButton.addTarget(self, action: #selector(okButtonTouched(sender:)), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func okButtonTouched(sender:UIButton) {
        
        delegate?.inputCode(codeTf.text, tag: self.tag)
        self.removeFromSuperview()
    }
    
}

protocol CluePopUpViewDelegate {
    
    func inputCode(_ code:String?, tag:Int)
    
}


struct PopUp {
    
    static func callEmailPopUp(vc:UIViewController) {
        
        let popupView = EmailPopupView()
        
        if let _parent = vc.parent {
            _parent.view.addSubview(popupView)
        }else{
            vc.view.addSubview(popupView)
        }
        
        popupView.delegate = vc as? TwobuttonAlertViewDelegate
        popupView.emailTf.delegate = vc as? UITextFieldDelegate
        popupView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
    }
    
    static func callTwoButtonAlert(vc:UIViewController) {
        
        let popupView = AlertTwoButtonView()
        
        if let _parent = vc.parent {
            _parent.view.addSubview(popupView)
        }else{
            vc.view.addSubview(popupView)
        }
        
        popupView.delegate = vc as? TwobuttonAlertViewDelegate
        popupView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
    }
    
    static func callPairedPopUp(articleLink:ArticleLink, left:Article, right:Article, earnPoint:Int, vc:UIViewController) {
        
        let popupView = PairedArticleView()
        
        if let _parent = vc.parent {
            _parent.view.addSubview(popupView)
        }else{
            vc.view.addSubview(popupView)
        }
        
        popupView.delegate = vc as? PairedPopupDelegate
        popupView.setData(articleLink: articleLink, left: left, right: right, earnPoint: earnPoint)
        popupView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
    }
    
    static func levelBadgePopup(type:PopUpType, title:String, image:UIImage, tag:Int, vc:UIViewController) {
        
        let popupView = LevelBadgePopUpView()
        popupView.setData(type: type, mainImage: image, desc: title, tag: tag)
        popupView.delegate = vc as? CallBadgeDelegate
        
        if let _parent = vc.parent {
            _parent.view.addSubview(popupView)
        }else{
            vc.view.addSubview(popupView)
        }
        
        popupView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
    }
    
    static func callSubmitView(article:Article, tag:Int, correctCount:Int, questionCount:Int, vc:UIViewController) {
        
        let popupView = ArticleSubmitView()
        popupView.delegate = vc as? ArticleSubmitDelegate
        popupView.setData(article: article, correctCount: correctCount, questionCount: questionCount)
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
        popUpView.setData(title: time, desc: desc)
        popUpView.delegate = vc as? AlerPopupViewDelegate
        popUpView.tag = tag
        
        popUpView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
    }
    
    static func call(mainTitle:String, selectButtonTitles:[String], bottomButtonTitle:String, bottomButtonType:Int,
                     _ vc:UIViewController, buttonImages:[UIImage]?) {
        
        let popUpView = SelectPopUpView()
        
        vc.view.addSubview(popUpView)
        popUpView.titleLb.setNotoText(mainTitle, color: .white, size: 20, textAlignment: .center)
        popUpView.delegate = vc as? SelectPopupDelegate
        
        
        popUpView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        if let _btnImgs = buttonImages {
            popUpView.setButton(selectedButton: selectButtonTitles, bottomBtn: bottomButtonTitle, buttonImages: _btnImgs)

        }else{
            popUpView.setButton(selectedButton: selectButtonTitles, bottomBtn: bottomButtonTitle, buttonImages: nil)

        }
                
        popUpView.bottomButtonType(bottomButtonType)
        popUpView.popupView.setBorder(color: .black, width: 5)
        
    }
}

extension UIImage {
    func tinted(with color: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer { UIGraphicsEndImageContext() }
        color.set()
        withRenderingMode(.alwaysTemplate)
            .draw(in: CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
