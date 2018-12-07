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
    
    
    
    var timerView:NavigationCustomView?
    let backButton = UIButton()
    let articleTitleLb = UILabel()
    var sectionId:Int = 0
    var articles:Results<Article>?
    var localArticles:Results<LocalArticle>? {
        didSet {
            print(localArticles)
            
            articles.map({
                
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
    
    func setData(localData:Results<LocalArticle>?, articles:Results<Article>?, articleBtns:[ArticleSelectButton]) {
        
        self.localArticles = localData
        self.articles = articles
        self.articleButtons = articleBtns
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        Standard.shared.delegate = self
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
            make.centerX.equalToSuperview()
            make.width.height.equalTo(93)
        }
        articleButtons[3].snp.makeConstraints { (make) in
            make.top.equalTo(articleButtons[1].snp.bottom).offset(30)
            make.width.height.equalTo(93)
            make.trailing.equalTo( articleButtons[4].snp.leading).offset(-25)
        }
        articleButtons[5].snp.makeConstraints { (make) in
            make.top.equalTo(articleButtons[1].snp.bottom).offset(30)
            make.width.height.equalTo(93)
            make.leading.equalTo( articleButtons[4].snp.trailing).offset(25)
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

        // Do any additional setup after loading the view.
    }
    
    @objc func back(sender:UIButton) {
        
        sender.isUserInteractionEnabled = false
        
        self.navigationController?.popViewController(animated: false)
        
        sender.isUserInteractionEnabled = true
        
    }
    
    func setButton() {
        
        
        print(articleButtons)
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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

protocol ArticleSelectDelegate {
    func tapArticle(sender:ArticleSelectButton)
}
