//
//  MyPageSectionView.swift
//  WallPeckers
//
//  Created by Seongchan Kang on 28/12/2018.
//  Copyright © 2018 KimJimin and Company. All rights reserved.
//

import Foundation
import UIKit
import AloeStackView

final class MyPageSectionView:UIView, ThumnailDelegate { //마이페이지 뷰컨트롤러에서 나오는 항목들에 대한 뷰
    
    
    let germanLevels:[String] = ["Prakti-\nkant*in", "Volon-\ntär*in", "Journa-\nlist*in", "Redak-\nteur*in", "Chefredak-\nteur*in"]
    
    func moveToNext(id: Int) {
        delegate?.moveToCompleteArticle(id: id)
    }
    private let titleLb = UILabel()
    private let contentView = UIView()
    var delegate:SectionViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    private func setUI() {
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
        
        titleLb.setNotoText(content.rawValue.localized, color: .black, size: 20, textAlignment: .center)
        
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
            
            _ = [politicBadgeV, economyBadgeV, generalBadgeV].map({firstRowStackView.addArrangedSubview($0)})
            _ = [artBadgeV, sportsBadgeV, peopleBadgeV].map({secondRowStackView.addArrangedSubview($0)})
            
            self.contentView.addSubview([firstRowStackView, secondRowStackView])
            
            firstRowStackView.snp.makeConstraints { (make) in
                make.top.equalToSuperview()
                make.leading.equalTo(10)
                make.trailing.equalTo(-10)
                make.height.equalTo(110)
            }
            secondRowStackView.snp.makeConstraints { (make) in
                make.leading.equalTo(10)
                make.trailing.equalTo(-10)
                make.bottom.equalTo(-10)
                make.height.equalTo(110)
                make.top.equalTo(firstRowStackView.snp.bottom).offset(15)
            }
            firstRowStackView.axis = .horizontal
            secondRowStackView.axis = .horizontal
            firstRowStackView.distribution = .fillEqually
            secondRowStackView.distribution = .fillEqually
            firstRowStackView.spacing = 15
            secondRowStackView.spacing = 15
            
            if let _ = delegate?.completedBadges.filter({$0 == 1}).first {
                politicBadgeV.setData(badgeImage: "politicBadge", badgeTitle: "Politics".localized, tag: 1, isCompleted: true)
            }else{
                politicBadgeV.setData(badgeImage: "politicBadge", badgeTitle: "Politics".localized, tag: 1)
            }
            
            if let _ = delegate?.completedBadges.filter({$0 == 2}).first {
                economyBadgeV.setData(badgeImage: "economyBadge", badgeTitle:                 Standard.shared.getLocalized() == .KOREAN
                    ? "Economy".localized.replacingOccurrences(of: "\n", with: "") : "Economy".localized, tag: 2, isCompleted: true)
            }else{
                economyBadgeV.setData(badgeImage: "economyBadge", badgeTitle:                 Standard.shared.getLocalized() == .KOREAN
                    ? "Economy".localized.replacingOccurrences(of: "\n", with: "") : "Economy".localized, tag: 2, isCompleted: false)
            }
            if let _ = delegate?.completedBadges.filter({$0 == 3}).first {
                generalBadgeV.setData(badgeImage: "generalBadge", badgeTitle: "General".localized, tag: 3, isCompleted: true)
                
            }else{
                generalBadgeV.setData(badgeImage: "generalBadge", badgeTitle: "General".localized, tag: 3)
            }
            if let _ = delegate?.completedBadges.filter({$0 == 4}).first {
                artBadgeV.setData(badgeImage: "artcultureBadge", badgeTitle: "Art".localized, tag: 4, isCompleted: true)
            }else{
                artBadgeV.setData(badgeImage: "artcultureBadge", badgeTitle: "Art".localized, tag: 4)
            }
            if let _ = delegate?.completedBadges.filter({$0 == 5}).first {
                sportsBadgeV.setData(badgeImage: "sportsBadge", badgeTitle: "Sports".localized, tag: 5, isCompleted: true)
            }else{
                sportsBadgeV.setData(badgeImage: "sportsBadge", badgeTitle: "Sports".localized, tag: 5)
            }
            if let _ = delegate?.completedBadges.filter({$0 == 6}).first {
                peopleBadgeV.setData(badgeImage: "peopleBadge", badgeTitle: "People".localized, tag: 6, isCompleted: true)
            }else{
                peopleBadgeV.setData(badgeImage: "peopleBadge", badgeTitle: "People".localized, tag: 6)
                
            }
            
        case .Level:
            
            guard let myLevel = delegate?.myLevel else {return}
            let baseView = UIView()
            let levelImageView = UIImageView()
            let position1Lb = UILabel()
            let position2Lb = UILabel()
            let position3Lb = UILabel()
            let position4Lb = UILabel()
            let position5Lb = UILabel()
            
            self.contentView.addSubview(baseView)
            
            baseView.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
            baseView.addSubview([levelImageView, position1Lb, position2Lb, position3Lb, position4Lb, position5Lb])
            
            levelImageView.snp.makeConstraints { (make) in
                make.top.equalToSuperview().offset(10)
                make.width.equalTo(280)
                make.height.equalTo(130)
                make.centerX.equalToSuperview()
                make.bottom.equalTo(-30)
            }
            
            position1Lb.snp.makeConstraints { (make) in
                make.leading.equalTo(levelImageView.snp.leading)
                make.top.equalTo(levelImageView.snp.bottom)
                make.width.equalTo(45)
            }
            
            position2Lb.snp.makeConstraints { (make) in
                make.leading.equalTo(position1Lb.snp.trailing).offset(0)
                make.top.equalTo(levelImageView.snp.bottom).offset(-20)
                make.width.equalTo(70)
                
            }
            position3Lb.snp.makeConstraints { (make) in
                
                make.centerX.equalTo(levelImageView.snp.centerX).offset(-3)
                make.top.equalTo(levelImageView.snp.bottom).offset(-45)
                make.width.equalTo(66)
            }
            position4Lb.snp.makeConstraints { (make) in
                make.leading.equalTo(position3Lb.snp.trailing).offset(-10)
                make.top.equalTo(levelImageView.snp.bottom).offset(-65)
                make.width.equalTo(66)
            }
            position5Lb.snp.makeConstraints { (make) in
                make.trailing.equalTo(levelImageView.snp.trailing).offset(-3)
                make.top.equalTo(levelImageView.snp.bottom).offset(-90)
                make.width.equalTo(66)
            }
            
            
            
            let levels = RealmLevel.shared.get(Standard.shared.getLocalized()).sorted(by: {$0.id < $1.id})
            
            if Standard.shared.getLocalized() == .GERMAN {
                position1Lb.setAmericanTyperWriterText(germanLevels[0], color: .brownGrey, size: 12, textAlignment: .center, font: .bold)
                position2Lb.setAmericanTyperWriterText(germanLevels[1], color: .brownGrey, size: 12, textAlignment: .center, font: .bold)
                position3Lb.setAmericanTyperWriterText(germanLevels[2], color: .brownGrey, size: 12, textAlignment: .center, font: .bold)
                position4Lb.setAmericanTyperWriterText(germanLevels[3], color: .brownGrey, size: 12, textAlignment: .center, font: .bold)
                position5Lb.setAmericanTyperWriterText(germanLevels[4], color: .brownGrey, size: 12, textAlignment: .center, font: .bold)
            }else{
                position1Lb.setAmericanTyperWriterText(levels[0].grade!, color: .brownGrey, size: 12, textAlignment: .center, font: .bold)
                position2Lb.setAmericanTyperWriterText(levels[1].grade!, color: .brownGrey, size: 12, textAlignment: .center, font: .bold)
                position3Lb.setAmericanTyperWriterText(levels[2].grade!, color: .brownGrey, size: 12, textAlignment: .center, font: .bold)
                position4Lb.setAmericanTyperWriterText(levels[3].grade!, color: .brownGrey, size: 12, textAlignment: .center, font: .bold)
                position5Lb.setAmericanTyperWriterText(levels[4].grade!, color: .brownGrey, size: 12, textAlignment: .center, font: .bold)
            }
           
            
            for i in [position1Lb, position2Lb, position3Lb, position4Lb, position5Lb] {
                i.numberOfLines = 2
                i.adjustsFontSizeToFitWidth = true
            }
            
            levelImageView.contentMode = .scaleAspectFit
            
            
            
            if let myScore = RealmUser.shared.getUserData()?.score {
                
                if myScore < 2000 {
                    levelImageView.image = UIImage.init(named: "levelRe45")
                    position1Lb.textColor = .black
                }else if myScore < 4000 {
                    levelImageView.image = UIImage.init(named: "levelRe46")
                    position2Lb.textColor = .black
                    
                }else if myScore < 8000 {
                    levelImageView.image = UIImage.init(named: "levelRe47")
                    position3Lb.textColor = .black
                    
                }else if myScore < 12000 {
                    levelImageView.image = UIImage.init(named: "levelRe48")
                    position4Lb.textColor = .black
                    
                }else{
                    levelImageView.image = UIImage.init(named: "levelRe49")
                    position5Lb.textColor = .black
                    
                }
            }
            
            print(myLevel)

        case .Score:
            
            let starImv = UIImageView.init(image: UIImage.init(named: "ArticleStar")!)
            let pointLb = UILabel()
            
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
            pointLb.attributedText = "\(point)P".makeAttrString(font: .NotoSans(.bold, size: 28), color: .black)
            pointLb.accessibilityIdentifier = "point"
            
        case .CREDIBILITY:
            let emptyView = UIView()
            let fulfillView = UIView()
            let percentLb = UILabel()
            guard let percent = delegate?.credibility else {return}
            
            self.contentView.addSubview([emptyView, fulfillView, percentLb])
            
            emptyView.snp.makeConstraints { (make) in
                
                make.top.equalTo(10)
                make.height.equalTo(34)
                make.width.equalTo(240)
                make.bottom.equalTo(-20)
                make.centerX.equalToSuperview()
            }
            
            fulfillView.snp.makeConstraints { (make) in
                make.leading.bottom.top.equalTo(emptyView)
                make.width.equalTo(240 * Double(Double(percent) / 100))
            }
            emptyView.setBorder(color: .black, width: 1.5)
            emptyView.backgroundColor = .white
            fulfillView.setBorder(color: .black, width: 1.5)
            
            fulfillView.backgroundColor = .sunnyYellow
            
            percentLb.snp.makeConstraints { (make) in
                make.center.equalTo(emptyView.snp.center)
            }
            percentLb.attributedText = "\(percent)%".makeAttrString(font: UIFont.NotoSans(.bold, size: 16), color: .black)
            
            
            
        case .COMPLETEDARTICLE:
            
            let articleStackView = AloeStackView()
            articleStackView.backgroundColor = .basicBackground
            articleStackView.separatorHeight = 0
            self.contentView.addSubview(articleStackView)
            
            
            guard let completedArticle = delegate?.completedArticle else {return}
            
            var heights:CGFloat = 0
            for i in 0...completedArticle.count - 1 {
                
                let vv = CompleteArticleThumnailView()
                vv.delegate = self
                vv.setData(article: completedArticle[i])
                articleStackView.addRow(vv)
                vv.titleLb.setNeedsLayout()
                vv.titleLb.lineBreakMode = NSLineBreakMode.byWordWrapping

                let hhh = heightForView(text: completedArticle[i].title!, font: .NotoSans(.bold, size: 18), width: DeviceSize.width - 50)
                 heights += hhh + 110

                self.layoutIfNeeded()
            }
            articleStackView.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
                
                make.height.equalTo(heights)
            }
            self.layoutIfNeeded()
            self.layoutSubviews()
            articleStackView.isScrollEnabled = false
        }
    }
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
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
    func moveToCompleteArticle(id:Int)
    
}

enum ContentType:String {
    
    case Score = "ARTICLE POINTS"
    case Level = "MY LEVEL"
    case Badge = "MY BADGES"
    case CREDIBILITY = "ARTICLE CREDIBILITY"
    case COMPLETEDARTICLE = "COMPLETED ARTICLES"
}

enum TopicSection:Int {
    case Politics, Economy, General, Art, Sports, People
}

enum HashSection:Int {
    case hash1, hash2, hash3, hash4, hash5
}
