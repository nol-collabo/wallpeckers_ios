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
    let keyboardResigner = UITapGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        addAction()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainProfileView.setData(userData: realm.objects(User.self).last!, level: RealmUser.shared.getUserLevel(), camera: false, nameEdit: false, myPage: true)

    }
    
    func addAction() {
        mainProfileView.setAction(vc: self, #selector(moveToMaPage(sender:)))
        confirmBtn.addTarget(self, action: #selector(moveToNext(sender:)), for: .touchUpInside)
        keyboardResigner.addTarget(self, action: #selector(keyboardResign))
    }
    
    @objc func keyboardResign() {
        pressCodeTf.resignFirstResponder()
    }
    
    func setUI() {
        
        self.view.addSubview([mainProfileView, pressCodeLb, pressCodeTf, confirmBtn, pressCodeDescLb])
        self.view.backgroundColor = .basicBackground
        self.view.addGestureRecognizer(keyboardResigner)
        mainProfileView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeArea.top).offset(20)
            make.centerX.equalToSuperview()
            make.leading.equalTo(DEVICEHEIGHT > 600 ? 64 : 32)
            make.height.equalTo(DEVICEHEIGHT > 600 ? 410 : 345)

        }
        
        
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
            make.leading.equalTo(10)
//            make.height.equalTo(34)
        }
        
        pressCodeDescLb.snp.makeConstraints { (make) in
            make.top.equalTo(pressCodeLb.snp.bottom).offset(0)
            make.centerX.equalToSuperview()
            make.height.equalTo(34)
        }
        pressCodeTf.attributedPlaceholder = "inputkey_passcode".localized.makeAttrString(font: .NotoSans(.medium, size: 25), color: UIColor.init(white: 155/255, alpha: 1))
        pressCodeTf.textAlignment = .center
        pressCodeTf.addUnderBar()
        pressCodeLb.setNotoText("inputkey_codeguide".localized, size: 16, textAlignment: .center)
        pressCodeLb.numberOfLines = 1
        pressCodeLb.adjustsFontSizeToFitWidth = true
        
        confirmBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.safeArea.bottom).offset(-30)
            make.height.equalTo(55)
            make.centerX.equalToSuperview()
            make.leading.equalTo(55)
        }
        confirmBtn.setTitle("OK".localized, for: .normal)
        pressCodeTf.delegate = self
        confirmBtn.backgroundColor = .gray
        confirmBtn.isUserInteractionEnabled = false

    }
    
    @objc func moveToMaPage(sender:UIButton) {
        
        sender.isUserInteractionEnabled = false
        
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyPage") as? UINavigationController else {return}
        sender.isUserInteractionEnabled = true

        self.present(vc, animated: true, completion: nil)
        
    }
    
    @objc func moveToNext(sender:UIButton) {
        
        sender.isUserInteractionEnabled = false
        
        if let playTime = RealmUser.shared.getUserData()?.playTime {
            
            if playTime > 0 {
                
                moveToGame()

                sender.isUserInteractionEnabled = true

 
            }else{
                
                if !UserDefaults.standard.bool(forKey: "Playing") {
                    moveToGame()
                }else{
                    PopUp.callTwoButtonAlert(vc:self)
                }
                

                sender.isUserInteractionEnabled = true

                // 팝업
            }
            
        }
     
    }
    
    func moveToGame(){
        
        UserDefaults.standard.set(true, forKey: "Playing")
        
        if UserDefaults.standard.bool(forKey: "Tutorial") {
            guard let vc = UIStoryboard.init(name: "Game", bundle: nil).instantiateViewController(withIdentifier: "GameNav") as? UINavigationController else {return}
            
            self.present(vc, animated: true, completion: nil)
            
        }else{
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "TutorialViewController") as? TutorialViewController else {return}
            
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    

}


extension AfterRegisterViewController:UITextFieldDelegate, TwobuttonAlertViewDelegate {
    func tapOk(sender: UIButton) {
        RealmUser.shared.initializedUserInfo()
        moveToGame()
        sender.isUserInteractionEnabled = true

    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
//        if DEVICEHEIGHT < 600 {
            UIView.animate(withDuration: 0.2) {
                self.view.center = .init(x: self.view.center.x, y: self.view.center.y - 80)
                
//            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
//        if DEVICEHEIGHT < 600 {
            UIView.animate(withDuration: 0.2) {
                self.view.center = .init(x: self.view.center.x, y: self.view.center.y + 80)
//            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string.count > 0 {
            confirmBtn.isUserInteractionEnabled = true
            confirmBtn.backgroundColor = .black
        }else{
            confirmBtn.isUserInteractionEnabled = false
            confirmBtn.backgroundColor = .gray
        }
        return true
        
    }
}

class MyProfileView:UIView, UITextFieldDelegate {
    
    let titleLb = UILabel()
    let profileImageView = UIImageView()
    let nameTf = UITextField()
    let nameEditBtn = UIButton()
    let myPagebtn = BottomButton()
    let cameraBtn = UIButton()
    let levelDescLb = UILabel()
    var delegate:MyPageDelegate?
    
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
        titleLb.setAmericanTyperWriterText("PRESS".localized, size: 50, textAlignment: .center, font:.bold)
        
        profileImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLb.snp.bottom).offset(10)
            make.width.equalTo(DEVICEHEIGHT > 600 ? 150 : 100)
            make.height.equalTo(DEVICEHEIGHT > 600 ? 180 : 120)
        }
        
        nameTf.font = UIFont.NotoSans(.bold, size: 19)
        nameTf.delegate = self
        
        switch Standard.shared.getLocalized() {
            
        case .ENGLISH:
            self.backgroundColor = .paleOliveGreen

        case .KOREAN:
            self.backgroundColor = .babyBlue

        case .GERMAN :
            self.backgroundColor = .paleOrange

            
        }
        
        profileImageView.setBorder(color: .black, width: 3.5)
        nameTf.snp.makeConstraints { (make) in
            make.top.equalTo(profileImageView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.greaterThanOrEqualTo(50)
            make.width.lessThanOrEqualToSuperview().multipliedBy(0.8)
        }
        nameTf.textAlignment = .center
        
        nameEditBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(nameTf.snp.centerY)
            make.width.height.equalTo(13)
            make.leading.equalTo(nameTf.snp.trailing).offset(5)
        }
        

        cameraBtn.setImage(UIImage.init(named: "cameraButton")!, for: .normal)
        nameEditBtn.setImage(UIImage.init(named: "nameEditButton")!, for: .normal)
        levelDescLb.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.leading.equalTo(20)
            make.bottom.equalTo(-58)
            make.top.equalTo(nameTf.snp.bottom).offset(DeviceSize.width > 320 ? 10 : 5)
        }
        
        myPagebtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.leading.equalTo(20)
            make.height.equalTo(40)
            make.top.equalTo(levelDescLb.snp.bottom).offset(10)
        }
        
        cameraBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(profileImageView.snp.trailing)
            make.centerY.equalTo(profileImageView.snp.bottom)
            make.width.equalTo(DEVICEHEIGHT > 600 ? 60 : 40)
            make.height.equalTo(DEVICEHEIGHT > 600 ? 50 : 30)
        }
        
        myPagebtn.setTitle("MY_PAGE".localized, for: .normal)
        self.nameTf.isEnabled = false
        levelDescLb.numberOfLines = 2
        levelDescLb.textAlignment = .center
        cameraBtn.addTarget(self, action: #selector(cameraTouched(sender:)), for: .touchUpInside)
        nameEditBtn.addTarget(self, action: #selector(changeNameTouched(sender:)), for: .touchUpInside)
    
    }
    
    @objc func cameraTouched(sender:UIButton) {
        delegate?.callProfileImageOption!(sender: sender)
        
    }
    
    @objc func changeNameTouched(sender:UIButton) {
        
        nameTf.isEnabled = (!nameTf.isEnabled)
        nameTf.becomeFirstResponder()

    }
    
    func setData(userData:User, level:String?, camera:Bool, nameEdit:Bool, myPage:Bool) {
        
        
        
        self.nameTf.text = userData.name
        self.profileImageView.image = UIImage.init(data: userData.profileImage!)
        self.levelDescLb.attributedText = "\("WALLPECKERS".localized)\n\(level ?? "Intern")".makeAttrString(font: .NotoSans(.bold, size: 14), color: .black)
        self.cameraBtn.isHidden = !camera
        self.nameEditBtn.isHidden = !nameEdit
        self.myPagebtn.isHidden = !myPage

        if self.myPagebtn.isHidden {
            levelDescLb.snp.updateConstraints { (make) in
                make.bottom.equalTo(-10)
            }
            self.layoutIfNeeded()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.isbecomeKeyboard!(sender: textField)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.isresignKeyboard!(sender: textField)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        delegate?.isresignKeyboard!(sender: textField)
        
        return true
        
    }
    
}

@objc protocol MyPageDelegate {
    
    @objc optional func callProfileImageOption(sender:UIButton)
    @objc optional func isbecomeKeyboard(sender:UITextField)
    @objc optional func isresignKeyboard(sender:UITextField)
    
}
