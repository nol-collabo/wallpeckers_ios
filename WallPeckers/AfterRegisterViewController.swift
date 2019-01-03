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
    let enPressCodes:[String] = ["berlin", "wall", "2", "5", "60","peace", "sunshine", "treaty", "agreement", "relations", "highway", "travel", "cow", "march", "border", "evolution", "threat", "deal", "monday", "immediately", "leeway", "emotion", "heroes", "resistance", "revival" ,"joy", "tie", "dream","freedom","bullet", "blood","love", "basement", "memories", "escape"]
    let dePressCodes:[String] = ["dmz", "dorasan", "2", "5", "60", "frieden", "sonnenschein", "vereinbarung", "einigung", "beziehungen", "weg", "reise", "rinder", "marsch", "grenze", "entwicklung", "bedrohung", "handel", "montag", "sofort", "spalt", "ergriffenheit", "helden", "widerstand", "wiederbelebung" ,"begeisterung", "gleichstand", "traum","freiheit","kugel", "blut","liebe", "keller", "gedenken", "flucht"]
    
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
            make.height.equalTo(DEVICEHEIGHT > 600 ? 410 : 320)

        }
        
        
        pressCodeTf.snp.makeConstraints { (make) in
            make.top.equalTo(mainProfileView.snp.bottom).offset(DeviceSize.width > 320 ? 46 : 26)
            make.centerX.equalToSuperview()
            make.leading.equalTo(35)
            make.height.equalTo(30)
        }
        
        pressCodeTf.autocorrectionType = .no

        pressCodeLb.snp.makeConstraints { (make) in
            make.top.equalTo(pressCodeTf.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
            make.leading.equalTo(10)
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
        
        if let _inputCode = pressCodeTf.text {
            switch Standard.shared.getLocalized() {
                
            case .ENGLISH, .KOREAN:
                if !enPressCodes.contains(_inputCode.lowercased()) {
                    pressCodeTf.text = ""
                    pressCodeLb.attributedText = "inputkey_errorguide".localized.makeAttrString(font: .NotoSans(.medium, size: 16), color: .red)
                    return
                }
            case .GERMAN:
                if !dePressCodes.contains(_inputCode.lowercased()) {
                    pressCodeTf.text = ""
                    pressCodeLb.attributedText = "inputkey_errorguide".localized.makeAttrString(font: .NotoSans(.medium, size: 16), color: .red)
                    return
                }
            }

            UserDefaults.standard.set(true, forKey: "Playing")
            
            if UserDefaults.standard.bool(forKey: "Tutorial") {
                guard let vc = UIStoryboard.init(name: "Game", bundle: nil).instantiateViewController(withIdentifier: "GameNav") as? UINavigationController else {return}

                if let gvc = vc.viewControllers.first as? GameViewController {
                    gvc.inputCode = _inputCode
                }
                
                self.present(vc, animated: true, completion: nil)
                
            }else{
                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "TutorialViewController") as? TutorialViewController else {return}
                
                CustomAPI.getSessionID(passcode: _inputCode) { (sessionId) in
                    
                    UserDefaults.standard.set(sessionId, forKey: "sessionId")
                    
                    vc.inputCode = _inputCode
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
            }
            
        }
        
        

    }
    

}


extension AfterRegisterViewController:UITextFieldDelegate, TwobuttonAlertViewDelegate {
    func tapOk(sender: Any) {
        RealmUser.shared.initializedUserInfo()
        moveToGame()
    }
    

    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
            UIView.animate(withDuration: 0.2) {
                self.view.center = .init(x: self.view.center.x, y: self.view.center.y - 120)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
            UIView.animate(withDuration: 0.2) {
                self.view.center = .init(x: self.view.center.x, y: self.view.center.y + 120)
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
