//
//  PublishViewController.swift
//  WallPeckers
//
//  Created by Seongchan Kang on 26/12/2018.
//  Copyright © 2018 KimJimin and Company. All rights reserved.
//

import UIKit
import SwiftyJSON

class PublishViewController: UIViewController {
    
    let circleBackBtn = UIButton()
    var fromMyPage:Bool = false
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
    var email:String?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        

//        RealmUser.shared.getUserData()?.playTime = 0
        
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
            
            headlineView.setData(header: "publish_titlearticle".localized, thumnail: headLine.title!, isHeadline: true)
            
            if defaultHeadlines.count == 1 {
                feature1View.setData(header: "publish_subarticle1".localized, thumnail: "")
                feature2View.setData(header: "publish_subarticle2".localized, thumnail: "")
                

            }else if defaultHeadlines.count == 2 {
                if let feature1 = RealmArticle.shared.get(Standard.shared.getLocalized()).filter({$0.id == defaultHeadlines[1]}).first {
                    feature1View.setData(header: "publish_subarticle3".localized, thumnail: feature1.title!)
                    feature2View.setData(header: "publish_subarticle2".localized, thumnail: "")
                    
                }
            }else {
                if let feature1 = RealmArticle.shared.get(Standard.shared.getLocalized()).filter({$0.id == defaultHeadlines[1]}).first, let feature2 = RealmArticle.shared.get(Standard.shared.getLocalized()).filter({$0.id == defaultHeadlines[2]}).first {
                    feature1View.setData(header: "publish_subarticle1".localized, thumnail: feature1.title!)
                    feature2View.setData(header: "publish_subarticle2".localized, thumnail: feature2.title!)
                }
            }
        }
        
    }
    
    private func setUI() {
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
        
            myPageButton.isHidden = fromMyPage
            startButton.isHidden = fromMyPage
        
        if fromMyPage {
            baseView.contentView.addSubview(circleBackBtn)
            circleBackBtn.addTarget(self, action: #selector(moveToMyPage(sender:)), for: .touchUpInside)
            circleBackBtn.setImage(UIImage.init(named: "backButton"), for: .normal)
            
            circleBackBtn.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.bottom.equalTo(-50)
                make.width.height.equalTo(100)
            }
        }
        
        switch Standard.shared.getLocalized() {
            
        case .ENGLISH:
            headerView.image = UIImage.init(named: "enLogo")

        case .GERMAN:
            headerView.image = UIImage.init(named: "deLogo")

        case .KOREAN:
            headerView.image = UIImage.init(named: "krLogo")

        }
        
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
        
        if defaultHeadlines.count == 3 {
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
            descLb.isHidden = false

        }else if defaultHeadlines.count == 2 {
            feature1View.snp.makeConstraints { (make) in
                make.top.equalTo(headlineView.snp.bottom).offset(4)
                make.leading.equalToSuperview()
                make.width.equalTo(headlineView.snp.width)
//                make.width.equalTo(headlineView.snp.width).multipliedBy(0.48)
                make.height.equalTo(150)
                make.bottom.equalToSuperview()
            }
            descLb.isHidden = true
        }else {
            headlineView.snp.remakeConstraints { (make) in
                make.top.left.right.equalToSuperview()
                make.height.equalTo(150)
                make.bottom.equalToSuperview()
            }
            descLb.isHidden = true

            
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
            make.top.equalTo(desc2Lb.snp.bottom).offset(30)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(55)
            make.centerX.equalToSuperview()
        }
        sendButton.setAttributedTitle("publish_gonews".localized.makeAttrString(font: .NotoSans(.bold, size: 18), color: .black), for: .normal)
        editButton.setAttributedTitle("publish_changebtn".localized.makeAttrString(font: .NotoSans(.bold, size: 18), color: .black), for: .normal)

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
        
        PopUp.callEmailPopUp(vc: self)
        
//        PopUp.call(mainTitle: "뉴스", selectButtonTitles: ["이메일", "인쇄하기"], bottomButtonTitle: "확인", bottomButtonType: 0, self, buttonImages: nil)
        sender.isUserInteractionEnabled = true
        
    }
    
    @objc func moveToEdit(sender:UIButton) {
        
        sender.isUserInteractionEnabled = false
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditHeadlineViewController") as? EditHeadlineViewController else {return}
        sender.isUserInteractionEnabled = true
        
        let totalArticle = RealmArticle.shared.get(Standard.shared.getLocalized()).filter({$0.isCompleted})

        if totalArticle.count <= 3 {
            vc.defaultHeadlines = defaultHeadlines
        }else{
            vc.defaultHeadlines = []
        }
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc func moveToMyPage(sender:UIButton){
        sender.isUserInteractionEnabled = false
        
        
        if fromMyPage {
            self.dismiss(animated: true, completion: nil)
        }else{
            guard let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyPage") as? UINavigationController else {return}
            sender.isUserInteractionEnabled = true
            if let mvc = vc.viewControllers[0] as? MyPageViewController {
                
                mvc.fromResult = true
            }
            
            
            self.present(vc, animated: true, completion: nil)
        }
        

    }
    
    @objc func moveToStart(sender:UIButton) {
        
        sender.isUserInteractionEnabled = false

        var headline = 0
        var main1 = 0
        var main2 = 0
        
        if defaultHeadlines.count == 1 {
            headline = defaultHeadlines[0]
        }
        if defaultHeadlines.count == 2 {
            headline = defaultHeadlines[0]
            main1 = defaultHeadlines[1]
        }
        if defaultHeadlines.count == 3 {
            headline = defaultHeadlines[0]
            main1 = defaultHeadlines[1]
            main2 = defaultHeadlines[2]
        }
        
        if RealmUser.shared.getUserData()?.allocatedId == 0 {
            
            guard let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainStart") as? UINavigationController else {return}

            self.present(vc, animated: true) {
                
                guard let nvc = vc.storyboard?.instantiateViewController(withIdentifier: "AfterRegisterViewController") as? AfterRegisterViewController else {return}
                
                vc.pushViewController(nvc, animated: true)
                
            }
            return
        }
    
        

        CustomAPI.updatePlayer(sessionId: UserDefaults.standard.integer(forKey: "sessionId"), email: email, headline: headline, main1: main1, main2: main2) { (result) in
            print(result)
            print("UPDATEPLAYER")
            guard let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainStart") as? UINavigationController else {return}
            
            UserDefaults.standard.set(0, forKey: "enterForeground")
            UserDefaults.standard.set(0, forKey: "enterBackground")
        
            
            try! realm.write {
                RealmUser.shared.getUserData()?.playTime = 0
            }
            
            self.present(vc, animated: true) {
                
                
                guard let nvc = vc.storyboard?.instantiateViewController(withIdentifier: "AfterRegisterViewController") as? AfterRegisterViewController else {return}

                vc.pushViewController(nvc, animated: true)
                
            }
        }
        sender.isUserInteractionEnabled = true

    }
    
}

extension PublishViewController: AlerPopupViewDelegate, TwobuttonAlertViewDelegate, UITextFieldDelegate {
    func tapOk(sender: Any) {
        print(sender)
        

        var headline:String!
        var main1:String?
        var main2:String?
        var others:[String]?
        // 여기서 서버 호출, 호출 완료되면 팝업 띄우기

        if let headlineId = RealmArticle.shared.getAll().filter({$0.id == defaultHeadlines[0]}).map({
            
            return "\($0.id).\($0.selectedPictureId).\($0.selectedHashtag)"
            
        }).first {
            headline = headlineId
        }
        
        if defaultHeadlines.count == 2 {
            if let main1Id = RealmArticle.shared.getAll().filter({$0.id == defaultHeadlines[1]}).map({
                return "\($0.id).\($0.selectedPictureId).\($0.selectedHashtag)"
            }).first {
                main1 = main1Id
            }
        }
        
        if defaultHeadlines.count == 3 {
            if let main1Id = RealmArticle.shared.getAll().filter({$0.id == defaultHeadlines[1]}).map({
                return "\($0.id).\($0.selectedPictureId).\($0.selectedHashtag)"
            }).first {
                main1 = main1Id
            }
            if let main2Id = RealmArticle.shared.getAll().filter({$0.id == defaultHeadlines[2]}).map({
                return "\($0.id).\($0.selectedPictureId).\($0.selectedHashtag)"
            }).first {
                main2 = main2Id
            }
        }
        
        others = RealmArticle.shared.getAll().filter({$0.isCompleted}).filter({!defaultHeadlines.contains($0.id)}).map({
            return "\($0.id).\($0.selectedPictureId).\($0.selectedHashtag)"
        })
        
        
//        if !email?.contains("@")
        
        if let emailAdd = sender as? String {
            
            
            if !emailAdd.contains("@") && !emailAdd.contains(".") {
                PopUp.callAlert(time: "", desc: "errorinputemail".localized, vc: self, tag: 99)
                
                
                if let epv = self.view.subviews.filter({$0 is AlertPopUpView}).first {
                    view.bringSubviewToFront(epv)
                }

                return
            }
            
            CustomAPI.makePDF(email: emailAdd, headline: headline, main1: main1, main2: main2, others: others) { (result) in
                
                let json = JSON(result)
                
                if let epv = self.parent?.view.subviews.filter({$0 is EmailPopupView}).first {
                    epv.removeFromSuperview()
                }
                
                if json["result"].stringValue == "OK" {
                    self.email = emailAdd
                    PopUp.callAlert(time: "", desc: "emailsuccessdialog_desc".localized, vc: self, tag: 99)
                }else{
                    PopUp.callAlert(time: "", desc: "erroremessage".localized, vc: self, tag: 99)
                }
                
            }
        }
        


        
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.2) {

            if let pv = self.parent?.view.subviews.filter({$0 is EmailPopupView}).first as? EmailPopupView {
                pv.popupView.center = .init(x:  pv.popupView.center.x, y: pv.popupView.center.y - 120)
            }
            
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        UIView.animate(withDuration: 0.2) {
            if let pv = self.parent?.view.subviews.filter({$0 is EmailPopupView}).first as? EmailPopupView {
                pv.popupView.center = .init(x:  pv.popupView.center.x, y: pv.popupView.center.y + 120)
            }
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func tapBottomButton(sender: AlertPopUpView) {
        sender.removeFromSuperview()
    }
    
    func bottomButtonTouched(sender: UIButton) {
        self.removePopUpView()
    }

}

protocol EditHeadlineProtocol {
    
    var headlines:[Int]? {get}
    
}
