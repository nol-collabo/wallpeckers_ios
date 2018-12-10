//
//  ArticleChooseViewController.swift
//  WallPeckers
//
//  Created by Seongchan Kang on 07/12/2018.
//  Copyright © 2018 KimJimin and Company. All rights reserved.
//

import UIKit
import RealmSwift
import Realm

class ArticleChooseViewController: UIViewController, GameNavigationBarDelegate, GamePlayTimeDelegate, AlerPopupViewDelegate, ArticleSelectDelegate {
    func tapArticle(sender: ArticleSelectButton) {
        print(sender.tag)
    }
    
    func tapBottomButton(sender: AlertPopUpView) {
        if sender.tag == 1 {
            
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ResultViewController") as? ResultViewController else {return}
            
            sender.removeFromSuperview()

            self.navigationController?.pushViewController(vc, animated: true)
            
                
            print("MOVE TO NEXT")
        }else {
            sender.removeFromSuperview()
        }
    }
    
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
    
    
    var links:[ArticleLinkLine] = []
    var timerView:NavigationCustomView?
    let backButton = UIButton()
    let articleTitleLb = UILabel()
    var sectionId:Int = 0
    var articles:Results<Article>?
    var articleLinks:Results<ArticleLink>?
    var localArticleLinks:Results<LocalArticleLink>?
    var localArticles:Results<LocalArticle>? {
        didSet {
            
            _ = articles.map({
                
                article in
                
                article.filter("article = \(localArticles)")
            })
        }
    }
    
    
    var articleButtons:[ArticleSelectButton] = []
    
    func touchMoveToMyPage(sender: UIButton) {
        sender.isUserInteractionEnabled = false
        
        guard let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyPageViewController") as? MyPageViewController else {return}
        sender.isUserInteractionEnabled = true
        
        self.present(vc, animated: true, completion: nil)
        
    }
    
    func setData(localData:Results<LocalArticle>?, articles:Results<Article>?, articleBtns:[ArticleSelectButton], articleLinks:Results<ArticleLink>) {
        
        self.localArticles = localData
        self.articles = articles
        self.articleButtons = articleBtns
        self.articleLinks = articleLinks
        
    }
    
    func drawLine() {
        
        var ids:[Int] = []
        for ar in articles! {
             ids.append(ar.id)
        }
  
        var filtered:[ArticleLink] = []
        
        for al in self.articleLinks! {
            
            for id in ids {
                
                if al.articles.contains(id) {
                    filtered.append(al)
                }
            }
        }
        
        let removeDuplicated = Array(Set(filtered)).sorted(by: {
            
            $0.id < $1.id
        })
        
        for i in removeDuplicated {
            
            let line = ArticleLinkLine()
            let color = LineColor.init(rawValue: i.color!)
            line.setLine(color: color!, vc: self)
            
            if let left = articleButtons.filter({
                $0.tag == i.articles[0]
            }).first, let right = articleButtons.filter({
                $0.tag == i.articles[1]
            }).first {
                line.linkButton(leftButton: left, rightButton: right, vc: self)
                links.append(line)
            }
            
        
            
        }
    
    
    
        
//        links = removeDuplicated
        print(removeDuplicated)

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        Standard.shared.delegate = self
        setUI()

        // Do any additional setup after loading the view.
    }
    
    func setUI() {
        self.setCustomNavigationBar()
        self.timerView = self.findTimerView()
        self.view.backgroundColor = .basicBackground
        backButton.setImage(UIImage.init(named: "backButton")!, for: .normal)
        self.view.addSubview(backButton)
        self.view.addSubview(articleTitleLb)
        backButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(40)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeArea.bottom).offset(-40)
        }
        
        
        articleTitleLb.setNotoText("CHOOSE A ARTICLE", color: .black, size: 24, textAlignment: .center, font: .medium)
        
        print(articleButtons.count)
        
        articleTitleLb.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeArea.top).offset(90)
            make.height.equalTo(35)
            make.centerX.equalToSuperview()
        }
        
        for i in articleButtons {
            self.view.addSubview(i)
            //            print(i.)
            
            print(i.tag)
            i.delegate = self
        }
        
        articleButtons[1].snp.makeConstraints { (make) in
            make.top.equalTo(articleTitleLb.snp.bottom).offset(35)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(93)
        }

        articleButtons[0].snp.makeConstraints { (make) in
            make.top.equalTo(articleTitleLb.snp.bottom).offset(35)
            make.width.height.equalTo(93)
            make.trailing.equalTo( articleButtons[1].snp.leading).offset(-25)
            
        }
        articleButtons[2].snp.makeConstraints { (make) in
            make.top.equalTo(articleTitleLb.snp.bottom).offset(35)
            make.width.height.equalTo(93)
            make.leading.equalTo( articleButtons[1].snp.trailing).offset(25)
        }
        articleButtons[4].snp.makeConstraints { (make) in
            make.top.equalTo(articleButtons[1].snp.bottom).offset(30)
            make.width.height.equalTo(93)
            make.centerX.equalToSuperview()
        }
        articleButtons[3].snp.makeConstraints { (make) in
            make.top.equalTo(articleButtons[1].snp.bottom).offset(30)
            make.width.height.equalTo(93)
            make.trailing.equalTo( articleButtons[4].snp.leading).offset(-25)
        }
        articleButtons[5].snp.makeConstraints { (make) in
            make.top.equalTo(articleButtons[1].snp.bottom).offset(30)
            make.width.height.equalTo(93)
            make.leading.equalTo(articleButtons[4].snp.trailing).offset(25)
        }
        articleButtons[7].snp.makeConstraints { (make) in
            make.top.equalTo(articleButtons[4].snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(93)
        }
        articleButtons[6].snp.makeConstraints { (make) in
            make.top.equalTo(articleButtons[4].snp.bottom).offset(30)
            make.width.height.equalTo(93)
            make.trailing.equalTo(articleButtons[7].snp.leading).offset(-25)
            
        }
        
        articleButtons[8].snp.makeConstraints { (make) in
            make.top.equalTo(articleButtons[4].snp.bottom).offset(30)
            make.width.height.equalTo(93)
            make.leading.equalTo(articleButtons[7].snp.trailing).offset(25)
            
        }
        
        backButton.addTarget(self, action: #selector(back(sender:)), for: .touchUpInside)
        
        drawLine()
    }
    
    @objc func back(sender:UIButton) {
        
        sender.isUserInteractionEnabled = false
        
        self.navigationController?.popViewController(animated: false)
        
        sender.isUserInteractionEnabled = true
        
    }


}

class ArticleSelectButton:UIView {
    
    let pointTitleLb = UILabel()
    let starImageView = UIImageView()
    let titleLb = UILabel()
    let tapGesture = UITapGestureRecognizer()
    var delegate:ArticleSelectDelegate?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addGestureRecognizer(tapGesture)
        tapGesture.addTarget(self, action: #selector(tap(sender:)))
        setUI()
    }
    
    func setUI() {
        self.addSubview([pointTitleLb, starImageView, titleLb])
        pointTitleLb.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(5)
            make.height.equalTo(30)
        }
        starImageView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.height.equalTo(25)
        }
        titleLb.snp.makeConstraints { (make) in
            make.leading.bottom.trailing.equalToSuperview()
            make.height.equalTo(30)
        }
        
    }
    
    func setData(point:String, textColor:UIColor, title:String, isStar:Bool, tag:Int, backgroundColor:UIColor = .white, borderColor:UIColor = .black) {
        self.pointTitleLb.setNotoText(point, color: textColor, size: 26, textAlignment: .center, font: .bold)
        self.titleLb.setNotoText(title, color: textColor, size: 12, textAlignment: .center, font: .bold)
        self.starImageView.isHidden = !isStar
        self.backgroundColor = backgroundColor
        self.tag = tag
        self.setBorder(color: borderColor, width: 4.5)
    }
    
    @objc func tap(sender:UITapGestureRecognizer) {
        delegate?.tapArticle(sender: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class ArticleLinkLine:UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func linkButton(leftButton:ArticleSelectButton, rightButton:ArticleSelectButton, vc:UIViewController) {
        
        self.snp.makeConstraints { (make) in
         
            
            if leftButton.tag - rightButton.tag == -1 {
                make.centerY.equalTo(leftButton.snp.centerY)
                make.height.equalTo(30)
                make.leading.equalTo(leftButton.snp.trailing)
                make.trailing.equalTo(rightButton.snp.leading)
            }else{
                make.centerX.equalTo(leftButton.snp.centerX)
                make.width.equalTo(30)
                make.top.equalTo(leftButton.snp.bottom)
                make.bottom.equalTo(rightButton.snp.top)
            }

        }
    }
    
    func setLine(color:LineColor, vc:UIViewController) {

        vc.view.addSubview(self)

        switch color {
        
        case .BLUE:
            self.backgroundColor = UIColor.blue
        case .GREEN:
            self.backgroundColor = .green
        case .ORANGE:
            self.backgroundColor = .orange
        case .RED:
            self.backgroundColor = .red
        }
        
       
    
        
        
    }
    
}

protocol ArticleSelectDelegate {
    func tapArticle(sender:ArticleSelectButton)
}

enum LineColor:String {
    
    case BLUE, RED, ORANGE, GREEN
    
}
