//
//  PublishViewController.swift
//  WallPeckers
//
//  Created by Seongchan Kang on 26/12/2018.
//  Copyright © 2018 KimJimin and Company. All rights reserved.
//

import UIKit

class PublishViewController: UIViewController {
    
    let baseView = BaseVerticalScrollView()
    let headerView = UIImageView()
    let articlesView = UIView()
    let descLb = UILabel()
    let editButton = BottomButton()
    let underLine1 = UIView()
    let underLine2 = UIView()
    let sendButton = BottomButton()
    let desc2Lb = UILabel()
    let myPageButton = BottomButton()
    let startButton = BottomButton()
    let headlineView = HeadlineView()
    let feature1View = HeadlineView()
    let feature2View = HeadlineView()
    var defaultHeadlines:[Int] = Array((RealmUser.shared.getUserData()?.publishedArticles)!)
    var delegate:EditHeadlineProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let selected = delegate?.headlines {
            defaultHeadlines = selected
        }
        setHeadline()
    }
    
    func setHeadline() {
        
        if let headLine = RealmArticle.shared.get(Standard.shared.getLocalized()).filter({$0.id == defaultHeadlines[0]}).first {
            
            headlineView.setData(header: "Headline", thumnail: headLine.result!)
            
            if defaultHeadlines.count == 1 {
                
            }else if defaultHeadlines.count == 2 {
                if let feature1 = RealmArticle.shared.get(Standard.shared.getLocalized()).filter({$0.id == defaultHeadlines[1]}).first {
                    feature1View.setData(header: "Feature1", thumnail: feature1.result!)
                    feature2View.setData(header: "Feature2", thumnail: "")
                    
                }
            }else {
                if let feature1 = RealmArticle.shared.get(Standard.shared.getLocalized()).filter({$0.id == defaultHeadlines[1]}).first, let feature2 = RealmArticle.shared.get(Standard.shared.getLocalized()).filter({$0.id == defaultHeadlines[2]}).first {
                    feature1View.setData(header: "Feature1", thumnail: feature1.result!)
                    feature2View.setData(header: "Feature2", thumnail: feature2.result!)
                }
            }
        }
        
    }
    
    func setUI() {
        self.navigationController?.isNavigationBarHidden = true
        baseView.setScrollView(vc: self)
        self.baseView.backgroundColor = .basicBackground
        self.baseView.contentView.backgroundColor = .basicBackground
        self.view.backgroundColor = .basicBackground
        baseView.contentView.addSubview([headerView, articlesView, descLb, editButton, underLine1, underLine2, sendButton, myPageButton, startButton, desc2Lb])
        headerView.snp.makeConstraints { (make) in
        
            make.top.equalTo(30)
            make.leading.equalTo(16)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            
        }
        
        headerView.image = UIImage.init(named: "logoSetWallpeckers06")
        underLine1.snp.makeConstraints { (make) in
            make.top.equalTo(headerView.snp.bottom).offset(10)
            make.leading.equalTo(16)
            make.centerX.equalToSuperview()
            make.height.equalTo(1)
        }
        underLine1.backgroundColor = .black
        
        articlesView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(underLine1.snp.bottom).offset(10)
            make.leading.equalTo(16)
        }
        
        articlesView.addSubview([headlineView, feature1View, feature2View])
        
        headlineView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(150)
        }
        feature1View.snp.makeConstraints { (make) in
            make.top.equalTo(headlineView.snp.bottom).offset(4)
            make.leading.equalToSuperview()
            make.width.equalTo(headlineView.snp.width).multipliedBy(0.48)
            make.height.equalTo(150)
            make.bottom.equalToSuperview()
        }
        feature2View.snp.makeConstraints { (make) in
            make.top.equalTo(headlineView.snp.bottom).offset(4)
            make.trailing.equalToSuperview()
            make.leading.equalTo(feature1View.snp.trailing).offset(-10)
            make.width.equalTo(feature1View.snp.width)
            make.height.equalTo(150)

        }
        
        descLb.snp.makeConstraints { (make) in
            make.top.equalTo(articlesView.snp.bottom).offset(20)
            make.leading.equalTo(10)
            make.centerX.equalToSuperview()
        }
        
        descLb.attributedText = "Select a Headline & 2 Featured Articles.".makeAttrString(font: .NotoSans(.bold, size: 18), color: .white)
        desc2Lb.adjustsFontSizeToFitWidth = true
        descLb.adjustsFontSizeToFitWidth = true
        desc2Lb.attributedText = "You can send your newspaper via e-mail.".makeAttrString(font: .NotoSans(.bold, size: 18), color: .white)
        
        editButton.snp.makeConstraints { (make) in
            make.top.equalTo(descLb.snp.bottom).offset(20)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(55)
            make.centerX.equalToSuperview()

        }
        editButton.setBackgroundColor(color: .sunnyYellow, forState: .normal)
        sendButton.setBackgroundColor(color: .sunnyYellow, forState: .normal)
        
        editButton.setBorder(color: .black, width: 1.5)
        sendButton.setBorder(color: .black, width: 1.5)
        underLine2.snp.makeConstraints { (make) in
            make.top.equalTo(editButton.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
            make.leading.equalTo(16)
            make.height.equalTo(1)
        }
        underLine2.backgroundColor = .black
        
        sendButton.snp.makeConstraints { (make) in
            make.top.equalTo(underLine2.snp.bottom).offset(25)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(55)
            make.centerX.equalToSuperview()
        }
        
        desc2Lb.snp.makeConstraints { (make) in
            make.top.equalTo(sendButton.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.leading.equalTo(10)
        }
        
        myPageButton.snp.makeConstraints { (make) in
            make.top.equalTo(desc2Lb.snp.bottom).offset(20)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(55)
            make.centerX.equalToSuperview()
        }
        
        startButton.snp.makeConstraints { (make) in
            make.top.equalTo(myPageButton.snp.bottom).offset(10)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(55)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-20)
        }
        editButton.addTarget(self, action: #selector(moveToEdit(sender:)), for: .touchUpInside)
        myPageButton.addTarget(self, action: #selector(moveToMyPage(sender:)), for: .touchUpInside)
        startButton.addTarget(self, action: #selector(moveToStart(sender:)), for: .touchUpInside)
        
    }
    
    @objc func moveToEdit(sender:UIButton) {
        
        sender.isUserInteractionEnabled = false
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditHeadlineViewController") as? EditHeadlineViewController else {return}
        sender.isUserInteractionEnabled = true
        vc.defaultHeadlines = defaultHeadlines
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc func moveToMyPage(sender:UIButton){
        sender.isUserInteractionEnabled = false
        guard let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyPage") as? UINavigationController else {return}
        sender.isUserInteractionEnabled = true
        
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func moveToStart(sender:UIButton) {
        
        sender.isUserInteractionEnabled = false
        guard let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainStart") as? UINavigationController else {return}
        sender.isUserInteractionEnabled = true
        self.present(vc, animated: true, completion: nil)
    }
    
}

protocol EditHeadlineProtocol {
    
    var headlines:[Int]? {get}
    
}

class HeadlineView:UIView {
    
    let titleLb = UILabel()
    let underLine = UIView()
    let thumnailLb = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    private func setUI(){
        
        self.setBorder(color: .black, width: 1.5)
        
        self.addSubview([titleLb, underLine, thumnailLb])
        
        titleLb.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(10)
            make.height.equalTo(20)
        }
        underLine.snp.makeConstraints { (make) in
            make.top.equalTo(titleLb.snp.bottom).offset(3)
            make.leading.equalTo(7)
            make.centerX.equalToSuperview()
            make.height.equalTo(2)
        }
        underLine.backgroundColor = .black
        
        thumnailLb.snp.makeConstraints { (make) in
            make.top.equalTo(underLine.snp.bottom).offset(5)
            make.leading.equalTo(20)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-10)
        }
        
        thumnailLb.numberOfLines = 0
        
    }
    
    func setData(header:String, thumnail:String) {
        
        self.titleLb.attributedText = header.makeAttrString(font: .NotoSans(.bold, size: 18), color: .black)
        self.thumnailLb.attributedText = thumnail.makeAttrString(font: .NotoSans(.bold, size: 15), color: .black)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
