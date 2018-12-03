//
//  AfterRegisterViewController.swift
//  WallPeckers
//
//  Created by Seongchan Kang on 30/11/2018.
//  Copyright © 2018 KimJimin and Company. All rights reserved.
//

import UIKit

class AfterRegisterViewController: UIViewController {

    
    let mainProfileView = UIView()
    let titleLb = UILabel()
    let profileImageView = UIImageView()
    let nameLb = UILabel()
    let myPagebtn = BottomButton()
    let pressCodeTf = UITextField()
    let pressCodeLb = UILabel()
    let confirmBtn = BottomButton()
    var userInfo:User? {
        didSet {
            
            guard let _userInfo = userInfo else {return}
            nameLb.text = _userInfo.name
            profileImageView.image = UIImage.init(data: _userInfo.profileImage!)
       
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        getUserData()
        addAction()
        // Do any additional setup after loading the view.
    }
    
    func addAction() {
        myPagebtn.addTarget(self, action: #selector(moveToMaPage(sender:)), for: .touchUpInside)
        confirmBtn.addTarget(self, action: #selector(moveToNext(sender:)), for: .touchUpInside)
    }
    
    func setUI() {
        
        self.view.addSubview([mainProfileView, pressCodeLb, pressCodeTf, confirmBtn])
        
        mainProfileView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeArea.top).offset(20)
            make.centerX.equalToSuperview()
            make.leading.equalTo(30)
            make.height.equalTo(300)
        }
        mainProfileView.setBorder(color: .black, width: 5)
        
        mainProfileView.addSubview([titleLb, profileImageView, nameLb, myPagebtn])
        
        titleLb.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(10)
            make.height.equalTo(30)
        }
        profileImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLb.snp.bottom).offset(10)
            make.width.equalTo(80)
            make.height.equalTo(120)
        }
        nameLb.snp.makeConstraints { (make) in
            make.top.equalTo(profileImageView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(20)
        }
        myPagebtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.leading.equalTo(10)
            make.height.equalTo(30)
            make.bottom.equalTo(-20)
        }
        
        pressCodeTf.snp.makeConstraints { (make) in
            make.top.equalTo(mainProfileView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.leading.equalTo(35)
            make.height.equalTo(30)
        }
        pressCodeLb.snp.makeConstraints { (make) in
            make.top.equalTo(pressCodeTf.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
        }
        pressCodeTf.placeholder = "PRESS CODE"
        pressCodeTf.textAlignment = .center
        pressCodeLb.setText("프레스 코드를 입력하고 확인을 누르세요", size: 10, textAlignment: .center)
        confirmBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.safeArea.bottom).offset(-30)
            make.centerX.equalToSuperview()
            make.leading.equalTo(50)
        }
        confirmBtn.setTitle("확인", for: .normal)
        myPagebtn.setTitle("마이페이지", for: .normal)
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
    

    
    func getUserData() {

        self.userInfo = realm.objects(User.self).last
        
    }

}


extension AfterRegisterViewController:UITextFieldDelegate {
    
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
