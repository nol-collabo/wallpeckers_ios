//
//  GameMainViewController.swift
//  WallPeckers
//
//  Created by Seongchan Kang on 03/12/2018.
//  Copyright © 2018 KimJimin and Company. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

class GameMainViewController: UIViewController, GameNavigationBarDelegate, GamePlayTimeDelegate, TopicButtonDelegate, AlerPopupViewDelegate {
    func tapBottomButton(sender: AlertPopUpView) {
        if sender.tag == 1 {

            print("MOVE TO NEXT")
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ResultViewController") as? ResultViewController else {return}
            sender.removeFromSuperview()

            self.navigationController?.pushViewController(vc, animated: true)
            
        }else {
            sender.removeFromSuperview()
        }
    }
    
 
    
    
    
    
    func tap(tag: Int) {
        print("TAG", tag)
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ArticleChooseViewController") as? ArticleChooseViewController else {return}

        vc.sectionId = tag

        var articleButtons:[ArticleSelectButton] = []
        
        switch selectedLanguage {
            
        case .ENGLISH:
            vc.setData(localData: realm.objects(LocalArticle.self).filter("language = 2"), articles: realm.objects(Article.self).filter("section = \(tag)"), articleBtns: articleButtons)

        case .GERMAN:
            vc.setData(localData: realm.objects(LocalArticle.self).filter("language = 3"), articles: realm.objects(Article.self).filter("section = \(tag)"), articleBtns: articleButtons)

        case .KOREAN:
            
            
            for article in  realm.objects(Article.self).filter("section = \(tag)") {
                
                let btn = ArticleSelectButton()
                
                btn.setData(point: "\(article.point) P", textColor: .black, title: article.word!, isStar: false, tag: article.id)
//                btn.delegate = self
                articleButtons.append(btn)
                
            }
            
            vc.setData(localData: nil, articles: realm.objects(Article.self).filter("section = \(tag)"), articleBtns: articleButtons)
        }
        
//        vc.setData(localData: <#T##Results<LocalArticle>?#>, articles: <#T##Results<Article>?#>)
//        vc
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    
    let topicTitleLb = UILabel()
    var timerView:NavigationCustomView?
    let politicsButton = TopicButton()
    let economyButton = TopicButton()
    let generalButton = TopicButton()
    let artButton = TopicButton()
    let sportsButton = TopicButton()
    let peopleButton = TopicButton()
    let selectedLanguage = Standard.shared.getLocalized()
    let sections = realm.objects(Section.self)
    var engsection = realm.objects(LocalSection.self).filter("language = 2")
    var gersection = realm.objects(LocalSection.self).filter("language = 3")
    @IBOutlet weak var containerView: UIView!
    
    func checkPlayTime(_ time: Int) {

        timerView?.updateTime(time)
        
        if time == 0 { //완료 됐을떄

            PopUp.callAlert(time: "00:00", desc: "완료", vc: self, tag: 1)
            print("END!")

        }else if time == 60 { // 1분 남았을 때
            PopUp.callAlert(time: "01:00", desc: "1분", vc: self, tag: 2)

            print("1minute!")

        }
    }

    func touchMoveToMyPage(sender: UIButton) {
        sender.isUserInteractionEnabled = false
        
        guard let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyPageViewController") as? MyPageViewController else {return}
        sender.isUserInteractionEnabled = true
        
        self.present(vc, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setUI()
        
        
        self.timerView = self.findTimerView()
     
        Standard.shared.startTimer(gameMode: .short)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Standard.shared.delegate = self

//        Standard.shared.ti
    }
    
    func setUI() {
        self.view.backgroundColor = .basicBackground
        self.setCustomNavigationBar()

        
        
        self.view.addSubview([topicTitleLb, politicsButton, economyButton, generalButton, artButton, sportsButton, peopleButton])

        
        let buttons = [politicsButton, economyButton, generalButton, artButton, sportsButton, peopleButton]
        
        switch selectedLanguage {
            
        case .ENGLISH:
            
            for i in 0...buttons.count - 1 {
                
                buttons[i].setData(title: engsection[i].title!, image: UIImage.init(named: "topic\(i + 1)")!, tag: engsection[i].id)
            }
            
        case .KOREAN:
            for i in 0...buttons.count - 1 {
                
                buttons[i].setData(title: sections[i].title!, image: UIImage.init(named: "topic\(i + 1)")!, tag: sections[i].id)
            }
        case .GERMAN:
            for i in 0...buttons.count - 1 {
                
                buttons[i].setData(title: gersection[i].title!, image: UIImage.init(named: "topic\(i + 1)")!, tag: gersection[i].id)
            }
            
        }
        
      
        politicsButton.delegate = self
        economyButton.delegate = self
        generalButton.delegate = self
        artButton.delegate = self
        sportsButton.delegate = self
        peopleButton.delegate = self

        
        topicTitleLb.setNotoText("CHOOSE A TOPIC", color: .black, size: 24, textAlignment: .center, font: .medium)
        
        topicTitleLb.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeArea.top).offset(90)
            make.height.equalTo(35)
            make.centerX.equalToSuperview()
        }
        
        economyButton.snp.makeConstraints { (make) in
            make.top.equalTo(topicTitleLb.snp.bottom).offset(34)
            make.width.equalTo(90)
            make.height.equalTo(160)
            make.centerX.equalToSuperview()
        }
        
        politicsButton.snp.makeConstraints { (make) in
            make.top.equalTo(topicTitleLb.snp.bottom).offset(34)
            make.width.equalTo(90)
            make.height.equalTo(160)
            make.trailing.equalTo(economyButton.snp.leading).offset(-25)
        }
        generalButton.snp.makeConstraints { (make) in
            make.top.equalTo(topicTitleLb.snp.bottom).offset(34)
            make.width.equalTo(90)
            make.height.equalTo(160)
            make.leading.equalTo(economyButton.snp.trailing).offset(25)
        }
        
        sportsButton.snp.makeConstraints { (make) in
            make.top.equalTo(economyButton.snp.bottom).offset(30)
            make.width.equalTo(90)
            make.height.equalTo(180)
            make.centerX.equalToSuperview()
        }
        
        artButton.snp.makeConstraints { (make) in
            make.top.equalTo(economyButton.snp.bottom).offset(30)
            make.width.equalTo(90)
            make.height.equalTo(180)
            make.trailing.equalTo(sportsButton.snp.leading).offset(-25)
        }
        
        peopleButton.snp.makeConstraints { (make) in
            make.top.equalTo(economyButton.snp.bottom).offset(30)
            make.width.equalTo(90)
            make.height.equalTo(180)
            make.leading.equalTo(sportsButton.snp.trailing).offset(25)
        }
        
        
        
    }
    
    func findTimerView() {
        if let vv = self.view.subviews.filter({
            
            $0 is GameNavigationBar
            
        }).first as? GameNavigationBar {
            if let _timerView = vv.subviews.filter({
                
                $0.tag == 99
                
            }).first as? NavigationCustomView {
                self.timerView = _timerView
            }
        }
    }
}

class GameNavigationBar:UIView {
    
    let timerView = NavigationCustomView()
    let myPageBtn = BottomButton()
    let scoreView = NavigationCustomView()
    var delegate:GameNavigationBarDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        self.backgroundColor = .red
        setUI()
    }
    
    
    func setUI() {
        
        self.addSubview([timerView, myPageBtn, scoreView])
        self.backgroundColor = .basicBackground
        timerView.snp.makeConstraints { (make) in
            make.top.equalTo(16)
            make.width.equalTo(72)
            make.height.equalTo(33)
            make.leading.equalTo(18)
        }
        myPageBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalTo(82)
            make.height.equalTo(20)
            make.top.equalTo(29)

        }
        myPageBtn.setBorder(color: .black, width: 1, cornerRadius: 3)
        
        scoreView.snp.makeConstraints { (make) in
            make.top.equalTo(13)
            make.width.equalTo(86)
            make.height.equalTo(36)
            make.trailing.equalTo(-19)
        }
        
        timerView.tag = 99
        timerView.setData(text: "", backgroundimage: UIImage.init(named: "timeSectionView")!)
        scoreView.setData(text: "", backgroundimage: UIImage.init(named: "scoreSectionView")!)

        myPageBtn.setAttributedTitle("MY PAGE".makeAttrString(font: .NotoSans(.medium, size: 14), color: .white), for: .normal)
        myPageBtn.addTarget(self, action: #selector(moveToMyPage(sender:)), for: .touchUpInside)
        
    }
    

    
    @objc func moveToMyPage(sender:UIButton) {
        delegate?.touchMoveToMyPage(sender: sender)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

protocol GameNavigationBarDelegate {
    
    func touchMoveToMyPage(sender:UIButton)
    
}

class NavigationCustomView:UIView {
    
    let backgroundImageView = UIImageView()
    let textLb = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    private func setUI() {
        
        self.addSubview([backgroundImageView, textLb])
        
        backgroundImageView.snp.makeConstraints { (make) in
            
            make.edges.equalToSuperview()
            
        }
        
        textLb.snp.makeConstraints { (make) in
//            make.center.equalToSuperview()
            make.trailing.equalTo(-8)
            make.bottom.equalTo(-2)
//            make.leading.top.equalTo(10)
//            make.width.equalTo(50)
//            make.height.equalTo(15)
        }
        

        
    }
    
    func setData(text:String, backgroundimage:UIImage) {
        backgroundImageView.image = backgroundimage
    }
    
    func updateTime(_ time:Int) {
        
//        transform.
        
        let (_, m, s) = secondsToHoursMinutesSeconds(seconds: time)
        
        self.textLb.setNotoText("\(m):\(s)", size: 14, textAlignment: .center)
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}

class TopicButton:UIView {
    
    let selectGesture:UITapGestureRecognizer = UITapGestureRecognizer()
    let titleImageView = UIImageView()
    let titleLb = UILabel()
    var delegate:TopicButtonDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    func setUI() {
        
        self.addGestureRecognizer(selectGesture)
        self.isUserInteractionEnabled = true
        self.backgroundColor = .white
        selectGesture.addTarget(self, action: #selector(tap))
        self.setBorder(color: .black, width: 1.5, cornerRadius: 0)
        self.addSubview([titleImageView, titleLb])
        
        titleImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-10)
        }
        titleLb.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(50)
        
        }
        
        titleLb.numberOfLines = 0
    }
    
    @objc func tap() {
        delegate?.tap(tag: self.tag)
    }
    
    func setData(title:String, image:UIImage, tag:Int) {
        
        self.titleLb.setNotoText(title, size: 13, textAlignment: .center)
        self.titleImageView.image = image
        self.tag = tag
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

protocol TopicButtonDelegate {
    
    func tap(tag:Int)
}
