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
        
        print(String(format:"levelup".localized, "ddd"))

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
            
            headlineView.setData(header: "publish_titlearticle".localized, thumnail: headLine.result!)
            
            if defaultHeadlines.count == 1 {
                feature1View.setData(header: "publish_subarticle1".localized, thumnail: "")
                feature2View.setData(header: "publish_subarticle2".localized, thumnail: "")
//                feature1View.isHidden = true
//                feature2View.isHidden = true
            }else if defaultHeadlines.count == 2 {
                if let feature1 = RealmArticle.shared.get(Standard.shared.getLocalized()).filter({$0.id == defaultHeadlines[1]}).first {
                    feature1View.setData(header: "publish_subarticle1".localized, thumnail: feature1.result!)
                    feature2View.setData(header: "publish_subarticle2".localized, thumnail: "")
                    
                }
            }else {
                if let feature1 = RealmArticle.shared.get(Standard.shared.getLocalized()).filter({$0.id == defaultHeadlines[1]}).first, let feature2 = RealmArticle.shared.get(Standard.shared.getLocalized()).filter({$0.id == defaultHeadlines[2]}).first {
                    feature1View.setData(header: "publish_subarticle1".localized, thumnail: feature1.result!)
                    feature2View.setData(header: "publish_subarticle2".localized, thumnail: feature2.result!)
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
        
        descLb.attributedText = "publish_changedesc".localized.makeAttrString(font: .NotoSans(.bold, size: 18), color: .white)
        desc2Lb.adjustsFontSizeToFitWidth = true
        descLb.textAlignment = .center
        desc2Lb.textAlignment = .center
        descLb.adjustsFontSizeToFitWidth = true
        desc2Lb.attributedText = "publish_gonews_verbose".localized.makeAttrString(font: .NotoSans(.bold, size: 18), color: .white)
        
        editButton.setTitle("titlearticlechange_title".localized, for: .normal)
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
        sendButton.setTitle("publish_gonews".localized, for: .normal)
        myPageButton.setTitle("publish_gomymenubtn".localized, for: .normal)
        startButton.setTitle("publish_gohomebtn".localized, for: .normal)
        startButton.snp.makeConstraints { (make) in
            make.top.equalTo(myPageButton.snp.bottom).offset(10)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(55)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-20)
        }
        sendButton.addTarget(self, action: #selector(callSendOption(sender:)), for: .touchUpInside)
        editButton.addTarget(self, action: #selector(moveToEdit(sender:)), for: .touchUpInside)
        myPageButton.addTarget(self, action: #selector(moveToMyPage(sender:)), for: .touchUpInside)
        startButton.addTarget(self, action: #selector(moveToStart(sender:)), for: .touchUpInside)
        
    }
    
    @objc func callSendOption(sender:UIButton) {
        
        sender.isUserInteractionEnabled = false
        PopUp.call(mainTitle: "뉴스", selectButtonTitles: ["이메일", "인쇄하기"], bottomButtonTitle: "확인", bottomButtonType: 0, self, buttonImages: nil)
        sender.isUserInteractionEnabled = true
        
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
        if let mvc = vc.viewControllers[0] as? MyPageViewController {
            
            mvc.fromResult = true
        }
        
        
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func moveToStart(sender:UIButton) {
        
        sender.isUserInteractionEnabled = false
        guard let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainStart") as? UINavigationController else {return}
        sender.isUserInteractionEnabled = true
        self.present(vc, animated: true, completion: nil)
    }
    
}

extension PublishViewController:SelectPopupDelegate, AlerPopupViewDelegate {
    func tapBottomButton(sender: AlertPopUpView) {
        sender.removeFromSuperview()
    }
    
    func bottomButtonTouched(sender: UIButton) {
        self.removePopUpView()
    }
    
    func selectButtonTouched(tag: Int) {
        print(tag)
        
        
        if tag == 1 {
            
            //서버로 인쇄 관련 api 전송 시점임
            
            PopUp.callAlert(time: "", desc: "printsuccessdialog_desc".localized, vc: self, tag: 1)
            self.removePopUpView()
        }else if tag == 0 {
            //이메일 팝업 호출 시점
        }
        
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
