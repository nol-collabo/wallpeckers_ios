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
    func moveToCompleteArticle(id: Int) {
        print("DELEGATE FFOFOFOFOFO", id)
        
        guard let vc = UIStoryboard.init(name: "Game", bundle: nil).instantiateViewController(withIdentifier: "CompleteArticleViewController") as? CompleteArticleViewController else {return}
        
        if let ar = RealmArticle.shared.get(Standard.shared.getLocalized()).filter({
            
            $0.id == id
        }).first {
            vc.setData(article: ar, hashTag: ar.selectedHashtag, wrongIds: Array(ar.wrongQuestionsId))
            vc.fromMyPage = true
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
   
        // id 로 완료기사로 ㄱㄱ하심
    }
    
    
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
    var titleLb = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scoreView.delegate = self
        badgeView.delegate = self
        levelView.delegate = self
        //내 점수
        currentPoint = RealmUser.shared.getUserData()?.score
//        myLevel = 10
        
        if let _currentPoint = currentPoint {
            if _currentPoint > 0 {
                credView.delegate = self
                completedArticleView.delegate = self
            }
        }

       completedArticle = RealmArticle.shared.get(Standard.shared.getLocalized()).filter({
            
            $0.isCompleted
        })
        

        if let corec = completedArticle?.map({Double($0.correctQuestionCount)}), let total = completedArticle?.map({Double($0.totalQuestionCount)}) {
            credibility = Int((corec.reduce(0, +) / total.reduce(0, +)) * 100)
            print(corec.reduce(0, +))
            print(total.reduce(0, +))
            print("HEHEHEHEH")
        }
        
        
        
        //내 뱃지, 정치부터 완료된거에 1,2,3,4,5,6 넣으면 됨
        completedBadges.append(1)
        completedBadges.append(2)
        print(completedBadges)
        
        setUI()

        // Do any additional setup after loading the view.
    }
    
    func setUI() {
        self.navigationController?.isNavigationBarHidden = true
        view.addSubview(aStackView)
        view.addSubview(dismissBtn)
        view.addSubview(titleLb)
        view.backgroundColor = .basicBackground
        
        dismissBtn.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeArea.top)
            make.trailing.equalToSuperview()
            make.width.height.equalTo(40)
        }
        
        titleLb.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(dismissBtn.snp.centerY).offset(10)
        }
        
        titleLb.attributedText = "MY PAGE".makeAttrString(font: .NotoSans(NotoSansFontSize.medium, size: 25), color: .black)
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
        
        
        //완료된 거 없으면 히든처리할 놈들
        
        if let _ = completedArticle {
            credView.setData(content: .CREDIBILITY)
            completedArticleView.setData(content: .COMPLETEDARTICLE)
            aStackView.addRows([credView, completedArticleView])
//            credView.backgroundColor = .red
        }
       
        
        //엔딩페이지에서만 보이는 신문
        
        
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



class MyPageSectionView:UIView, ThumnailDelegate {
    func moveToNext(id: Int) {
        delegate?.moveToCompleteArticle(id: id)
//        delegate.
    }
    
    
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
            pointLb.attributedText = "\(point)P".makeAttrString(font: .NotoSans(.bold, size: 28), color: .black)
            pointLb.accessibilityIdentifier = "point"
            
        case .CREDIBILITY:
            print("XX")
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
            
            for i in 0...completedArticle.count - 1 {
                
                let vv = CompleteArticleThumnailView()
                vv.delegate = self
//                vv.delegate =
                vv.setData(article: completedArticle[i])
                articleStackView.addRow(vv)
                self.layoutIfNeeded()
            }
            articleStackView.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
                make.height.equalTo(135 * completedArticle.count)
            }
            
            print(completedArticle)
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
    func moveToCompleteArticle(id:Int)

}

final class CompleteArticleThumnailView:UIView, Tappable {
    func didTapView() {
        delegate?.moveToNext(id: self.tag)
    }
    
    
    let titleLb = UILabel()
    var delegate:ThumnailDelegate?
    let hashView = UIView()
    let underLine = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    func setData(article:Article) {
        
        self.titleLb.attributedText = article.title!.makeAttrString(font: .NotoSans(.bold, size: 17), color: .black)
        self.tag = article.id
        
    }
    
    private func setUI() {
        
        self.backgroundColor = .basicBackground
        self.addSubview([titleLb, hashView, underLine])
        
        titleLb.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.leading.equalTo(10)
            make.trailing.equalTo(-30)
        }
        titleLb.numberOfLines = 0
        hashView.snp.makeConstraints { (make) in
            make.leading.equalTo(10)
            make.top.equalTo(titleLb.snp.bottom).offset(10)
            make.height.equalTo(50)
            make.bottom.equalTo(-5)
            make.trailing.equalTo(-10)
        }
        hashView.backgroundColor = .red
        
        underLine.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.height.equalTo(1.5)
            make.leading.equalTo(7)
            make.centerX.equalToSuperview()
        }
        underLine.backgroundColor = .black
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

protocol ThumnailDelegate {
    func moveToNext(id:Int)
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

class NewspaperPublishedView:UIView {
    
    let newspaperImageView = UIImageView()
    let publishButton = BottomButton()
    var delegate:PublishDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    func setUI() {
        
        self.addSubview([newspaperImageView, publishButton])
        
        newspaperImageView.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.centerX.equalToSuperview()
            make.height.equalTo(newspaperImageView.bounds.width * 2/3)
        }
        
        publishButton.snp.makeConstraints { (make) in
            make.top.equalTo(newspaperImageView.snp.bottom).offset(25)
            make.width.equalToSuperview().multipliedBy(0.6)
            make.height.equalTo(55)
        }
        
        switch Standard.shared.getLocalized() {
            
        case .ENGLISH:
            newspaperImageView.image = UIImage.init(named: "engNewsPaper")
        case .KOREAN:
            newspaperImageView.image = UIImage.init(named: "koreanNewsPaper")
        case .GERMAN:
            newspaperImageView.image = UIImage.init(named: "germanNewsPaper")
        }
    }
    
//    func setData() {
    
    @objc func moveToNext(sender:UIButton) {
        
        delegate?.moveToNext(sender: sender)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

protocol PublishDelegate {
    func moveToNext(sender:UIButton)
}
