//
//  AfterRegisterViewController.swift
//  WallPeckers
//
//  Created by Seongchan Kang on 30/11/2018.
//  Copyright © 2018 KimJimin and Company. All rights reserved.
//

import UIKit

class AfterRegisterViewController: UIViewController {

    
    
    let mainProfileView = MyProfileView()
    let pressCodeTf = UITextField()
    let pressCodeLb = UILabel()
    let confirmBtn = BottomButton()
    let pressCodeDescLb = UILabel()
    var userInfo:User?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        addAction()
        // Do any additional setup after loading the view.
    }
    
    func addAction() {
        mainProfileView.setAction(vc: self, #selector(moveToMaPage(sender:)))
        confirmBtn.addTarget(self, action: #selector(moveToNext(sender:)), for: .touchUpInside)
    }
    
    func setUI() {
        
        self.view.addSubview([mainProfileView, pressCodeLb, pressCodeTf, confirmBtn, pressCodeDescLb])
        self.view.backgroundColor = .basicBackground
        mainProfileView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeArea.top).offset(20)
            make.centerX.equalToSuperview()
            make.leading.equalTo(DEVICEHEIGHT > 600 ? 64 : 32)
            make.height.equalTo(DEVICEHEIGHT > 600 ? 370 : 280)
        
        }
        
        mainProfileView.setData(userData: realm.objects(User.self).last!, level: nil, camera: false, nameEdit: false, myPage: true)
        
        pressCodeTf.snp.makeConstraints { (make) in
            make.top.equalTo(mainProfileView.snp.bottom).offset(46)
            make.centerX.equalToSuperview()
            make.leading.equalTo(35)
            make.height.equalTo(30)
        }
        
        pressCodeTf.autocorrectionType = .no

        pressCodeLb.snp.makeConstraints { (make) in
            make.top.equalTo(pressCodeTf.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
            make.height.equalTo(34)
        }
        pressCodeDescLb.snp.makeConstraints { (make) in
            make.top.equalTo(pressCodeLb.snp.bottom).offset(0)
            make.centerX.equalToSuperview()
            make.height.equalTo(34)
        }
        pressCodeTf.attributedPlaceholder = "PRESS CODE".makeAttrString(font: .NotoSans(.medium, size: 25), color: UIColor.init(white: 155/255, alpha: 1))
        pressCodeTf.textAlignment = .center
        pressCodeTf.addUnderBar()
        pressCodeLb.setNotoText("프레스 코드를 입력하고 확인을 누르세요", size: 16, textAlignment: .center)
        pressCodeDescLb.setNotoText("You Could find out PRESS CODE on site.", color: .white, size: 12, textAlignment: .center)
        confirmBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.safeArea.bottom).offset(-30)
            make.height.equalTo(55)
            make.centerX.equalToSuperview()
            make.leading.equalTo(55)
        }
        confirmBtn.setTitle("확인", for: .normal)
//        myPagebtn.setTitle("마이페이지", for: .normal)
        pressCodeTf.delegate = self
        confirmBtn.backgroundColor = .gray
        confirmBtn.isUserInteractionEnabled = false

    }
    
    @objc func moveToMaPage(sender:UIButton) {
        
        sender.isUserInteractionEnabled = false
        
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyPageViewController") as? MyPageViewController else {return}
        sender.isUserInteractionEnabled = true

        self.present(vc, animated: true, completion: nil)
        
    }
    
    @objc func moveToNext(sender:UIButton) {
        
        sender.isUserInteractionEnabled = false
        
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "TutorialViewController") as? TutorialViewController else {return}
        
        sender.isUserInteractionEnabled = false
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

}


extension AfterRegisterViewController:UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if DEVICEHEIGHT < 800 {
            UIView.animate(withDuration: 0.2) {
                self.view.center = .init(x: self.view.center.x, y: self.view.center.y - 80)
                
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if DEVICEHEIGHT < 800 {
            UIView.animate(withDuration: 0.2) {
                self.view.center = .init(x: self.view.center.x, y: self.view.center.y + 80)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string.count > 0 {
            print("Not Empty")
            confirmBtn.isUserInteractionEnabled = true
            confirmBtn.backgroundColor = .black

        }
        return true
        
    }
}

class MyProfileView:UIView {
    
    let titleLb = UILabel()
    let profileImageView = UIImageView()
    let nameTf = LeftPaddedTextField()
    let nameEditBtn = UIButton()
    let myPagebtn = BottomButton()
    let cameraBtn = UIButton()
    let levelDescLb = UILabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    func setAction(vc:UIViewController, _ action:Selector) {
        
        self.myPagebtn.addTarget(vc, action: action, for: .touchUpInside)
    }
    
    private func setUI() {
    
        self.addSubview([titleLb, profileImageView, nameTf, nameEditBtn, myPagebtn, cameraBtn, levelDescLb])
        
        self.setBorder(color: .black, width: 3)
        
        titleLb.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(20)
            make.height.equalTo(40)
        }
        titleLb.setAeericanTypeText("PRESS", size: 50, textAlignment: .center, font:.bold)
        
        profileImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLb.snp.bottom).offset(10)
            make.width.equalTo(DEVICEHEIGHT > 600 ? 150 : 100)
            make.height.equalTo(DEVICEHEIGHT > 600 ? 180 : 120)
        }
        self.backgroundColor = .paleOliveGreen
        profileImageView.setBorder(color: .black, width: 3.5)
        nameTf.snp.makeConstraints { (make) in
            make.top.equalTo(profileImageView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            
            make.height.equalTo(20)
        }
        
        nameEditBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(nameTf.snp.centerY)
            make.width.height.equalTo(13)
            make.leading.equalTo(nameTf.snp.trailing).offset(5)
        }
        
        myPagebtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.leading.equalTo(20)
            make.height.equalTo(43)
            make.bottom.equalTo(-20)
        }
        cameraBtn.setImage(UIImage.init(named: "cameraButton")!, for: .normal)
        nameEditBtn.setImage(UIImage.init(named: "nameEditButton")!, for: .normal)
        levelDescLb.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.leading.equalTo(20)
            make.height.equalTo(43)
            make.bottom.equalTo(-20)
        }
        myPagebtn.setTitle("My Page", for: .normal)
        self.nameTf.isEnabled = false
        levelDescLb.numberOfLines = 2
        levelDescLb.textAlignment = .center
    
    }
    
    func setData(userData:User, level:String?, camera:Bool, nameEdit:Bool, myPage:Bool) {
        
        self.nameTf.text = userData.name
        self.profileImageView.image = UIImage.init(data: userData.profileImage!)
        self.levelDescLb.text = level
        self.cameraBtn.isHidden = !camera
        self.nameEditBtn.isHidden = !nameEdit
        self.myPagebtn.isHidden = !myPage
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
