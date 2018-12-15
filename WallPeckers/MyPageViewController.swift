//
//  MyPageViewController.swift
//  WallPeckers
//
//  Created by Seongchan Kang on 03/12/2018.
//  Copyright © 2018 KimJimin and Company. All rights reserved.
//

import UIKit
import SnapKit
import AloeStackView

class MyPageViewController: UIViewController, SectionViewDelegate {
    
    var completedArticle: [Article]?
    var credibility: Int?
    var myLevel: Int?
    var completedBadges: [Int] = []
    var currentPoint: Int? // 내 점수
    let profileBaseView = UIView()
    let dismissBtn = UIButton()
    let profileView = MyProfileView()
    let scoreView = MyPageSectionView()
    let levelView = MyPageSectionView()
    let badgeView = MyPageSectionView()
    let credView = MyPageSectionView()
    let completedArticleView = MyPageSectionView()
    let aStackView = AloeStackView()
    var fromResult:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scoreView.delegate = self
        badgeView.delegate = self
        levelView.delegate = self
        //내 점수
        currentPoint = 100
        myLevel = 10
        
        if let _currentPoint = currentPoint {
            if _currentPoint > 0 {
                credView.delegate = self
                completedArticleView.delegate = self
            }
        }

        
        //내 뱃지, 정치부터 완료된거에 1,2,3,4,5,6 넣으면 됨
        completedBadges.append(1)
        completedBadges.append(2)
        print(completedBadges)
        
        setUI()

        // Do any additional setup after loading the view.
    }
    
    func setUI() {
        view.addSubview(aStackView)
        view.addSubview(dismissBtn)
        view.backgroundColor = .basicBackground
        
        dismissBtn.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeArea.top)
            make.trailing.equalToSuperview()
            make.width.height.equalTo(40)
        }
        dismissBtn.setImage(UIImage.init(named: "dismissButton")!, for: .normal)
//        dismissBtn.backgroundColor = .blue
        aStackView.snp.makeConstraints { (make) in
           make.top.equalTo(dismissBtn.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeArea.bottom)
        }
        scoreView.setData(content: .Score)
        levelView.setData(content: .Level)
        badgeView.setData(content: .Badge)
        
        
        aStackView.addRows([profileBaseView, scoreView])
        
        profileBaseView.addSubview(profileView)
        profileView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(DEVICEHEIGHT > 600 ? 64 : 32)
            make.height.equalTo(DEVICEHEIGHT > 600 ? 370 : 280)
            
        }
        
        profileView.setData(userData: RealmUser.shared.getUserData()!, level: "intern", camera: true, nameEdit: true, myPage: false)
        
        if fromResult { // 결과창에서 볼때 보이는 두개
            credView.setData(content: .CREDIBILITY)
            completedArticleView.setData(content: .COMPLETEDARTICLE)
            aStackView.addRows([credView, completedArticleView])
        }
        
        aStackView.addRows([levelView, badgeView])
        
        aStackView.backgroundColor = .basicBackground
        profileView.snp.makeConstraints { (make) in

            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalTo(DeviceSize.width * 0.5)
            make.height.equalTo(DEVICEHEIGHT > 600 ? 370 : 280)
            
        }

        dismissBtn.addTarget(self, action: #selector(dismissTouched(sender:)), for: .touchUpInside)

    }
    
    @objc func dismissTouched(sender:UIButton) {
        sender.isUserInteractionEnabled = false
        self.dismiss(animated: true) {
            sender.isUserInteractionEnabled = true
        }
    }
}



class MyPageSectionView:UIView {
    
    private let titleLb = UILabel()
    private let contentView = UIView()
    var delegate:SectionViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    func setUI() {
        contentView.accessibilityIdentifier = "ContentView"
        self.addSubview([titleLb, contentView])
        
        titleLb.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.leading.equalTo(10)
            make.top.equalTo(10)
            make.height.equalTo(40)
        }
        titleLb.addUnderBar()
        self.setBorder(color: .black, width: 1.5)
        contentView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLb.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func setData(content:ContentType) {
        
        titleLb.setNotoText(content.rawValue, color: .black, size: 20, textAlignment: .center)

        switch content {
        case .Badge:
            
            let firstRowStackView = UIStackView()
            let secondRowStackView = UIStackView()
            let politicBadgeV = BadgeView()
            let economyBadgeV = BadgeView()
            let generalBadgeV = BadgeView()
            let artBadgeV = BadgeView()
            let sportsBadgeV = BadgeView()
            let peopleBadgeV = BadgeView()
            
            for v in [politicBadgeV, economyBadgeV, generalBadgeV] {
                
                firstRowStackView.addArrangedSubview(v)
                
            }
            
            for v in [artBadgeV, sportsBadgeV, peopleBadgeV] {
                
                secondRowStackView.addArrangedSubview(v)
                
            }
            
            self.contentView.addSubview([firstRowStackView, secondRowStackView])
            
            firstRowStackView.snp.makeConstraints { (make) in
                make.top.equalToSuperview()
                make.leading.equalTo(10)
                make.trailing.equalTo(-10)
                make.height.equalTo(100)
            }
            secondRowStackView.snp.makeConstraints { (make) in
                make.leading.equalTo(10)
                make.trailing.equalTo(-10)
                make.bottom.equalTo(-10)
                make.height.equalTo(100)
                make.top.equalTo(firstRowStackView.snp.bottom).offset(15)
            }
            firstRowStackView.axis = .horizontal
            secondRowStackView.axis = .horizontal
            firstRowStackView.distribution = .fillEqually
            secondRowStackView.distribution = .fillEqually
            firstRowStackView.spacing = 15
            secondRowStackView.spacing = 15
            

            if let _ = delegate?.completedBadges.filter({$0 == 1}).first {
                politicBadgeV.setData(badgeImage: "politicBadge", badgeTitle: "politic", tag: 1, isCompleted: true)

            }else{
                politicBadgeV.setData(badgeImage: "politicBadge", badgeTitle: "politic", tag: 1)
            }
            
            if let _ = delegate?.completedBadges.filter({$0 == 2}).first {
                economyBadgeV.setData(badgeImage: "economyBadge", badgeTitle: "ecomony", tag: 2, isCompleted: true)

            }else{
                economyBadgeV.setData(badgeImage: "economyBadge", badgeTitle: "ecomony", tag: 2)
            }
            
            if let _ = delegate?.completedBadges.filter({$0 == 3}).first {
                generalBadgeV.setData(badgeImage: "generalBadge", badgeTitle: "general", tag: 3, isCompleted: true)

            }else{
                generalBadgeV.setData(badgeImage: "generalBadge", badgeTitle: "general", tag: 3)

            }
            
            if let _ = delegate?.completedBadges.filter({$0 == 4}).first {
                artBadgeV.setData(badgeImage: "artcultureBadge", badgeTitle: "art", tag: 4, isCompleted: true)

            }else{
                artBadgeV.setData(badgeImage: "artcultureBadge", badgeTitle: "art", tag: 4)

            }
            if let _ = delegate?.completedBadges.filter({$0 == 5}).first {
                sportsBadgeV.setData(badgeImage: "sportsBadge", badgeTitle: "sports", tag: 5, isCompleted: true)
            }else{
                sportsBadgeV.setData(badgeImage: "sportsBadge", badgeTitle: "sports", tag: 5)

            }

            if let _ = delegate?.completedBadges.filter({$0 == 6}).first {
                peopleBadgeV.setData(badgeImage: "peopleBadge", badgeTitle: "people", tag: 6, isCompleted: true)

            }else{
                peopleBadgeV.setData(badgeImage: "peopleBadge", badgeTitle: "people", tag: 6)

            }

            
            
            
            
            print(content.rawValue)
        case .Level:
            
            print(delegate?.myLevel, "MYLEVEL")
           
            print(content.rawValue)
        case .Score:
            
            let starImv = UIImageView.init(image: UIImage.init(named: "ArticleStar")!)
            let pointLb = UILabel()
            
//            delegate?.currentPoint = 600000
            self.contentView.addSubview([starImv, pointLb])
            
            starImv.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview().offset(-60)
                make.width.height.equalTo(45)
                make.top.equalTo(10)
                make.bottom.equalTo(-26)
            }
            pointLb.snp.makeConstraints { (make) in
                make.leading.equalTo(starImv.snp.trailing).offset(10)
                make.centerY.equalTo(starImv.snp.centerY)
            }
        
            guard let point = delegate?.currentPoint else {return}
            pointLb.text = "\(point) P"
            pointLb.accessibilityIdentifier = "point"
            
        case .CREDIBILITY:
            print("XX")
            
            print(delegate?.credibility)
            
        case .COMPLETEDARTICLE:
            print("CCCC")
            print(delegate?.completedArticle)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

protocol SectionViewDelegate {
    
    var currentPoint:Int? { get set }
    var completedBadges:[Int] { get set }
    var myLevel:Int? {get set}
    var credibility:Int? {get set}
    var completedArticle:[Article]? {get set}

}


enum ContentType:String {
    
    case Score = "내 점수"
    case Level = "내 레벨"
    case Badge = "내 뱃지"
    case CREDIBILITY = "신뢰도"
    case COMPLETEDARTICLE = "완성된 기사"
//    , Level, Badge
}

final class BadgeView:UIView {
    
    let badgeImageView = UIImageView()
    let badgeTitleLb = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    func setData(badgeImage:String, badgeTitle:String, tag:Int, isCompleted:Bool = false) {
        self.tag = tag
        self.badgeImageView.image = UIImage.init(named: !isCompleted ? badgeImage : "\(badgeImage)C")
        self.badgeTitleLb.attributedText = badgeTitle.makeAttrString(font: .NotoSans(.bold, size: 15), color: .black)
    }
    
    func beCompleted() {
//        self.badgeImageView.image?.description
//        self.badgeImageView.image.
    }
    
    private func setUI() {
        self.addSubview([badgeImageView, badgeTitleLb])
        
        badgeImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.width.equalTo(badgeImageView.snp.height)
        }
        badgeTitleLb.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(badgeImageView.snp.bottom).offset(5)
            make.height.equalTo(30)
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        badgeTitleLb.textAlignment = .center
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
