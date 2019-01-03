//
//  MyProfileView.swift
//  WallPeckers
//
//  Created by Seongchan Kang on 28/12/2018.
//  Copyright © 2018 KimJimin and Company. All rights reserved.
//

import Foundation
import UIKit

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
            make.top.equalTo(profileImageView.snp.bottom).offset(DeviceSize.width > 320 ? 20 : 10)
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
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
            make.bottom.equalTo(DeviceSize.width > 320 ? -58 : -48)
            make.top.equalTo(nameTf.snp.bottom).offset(DeviceSize.width > 320 ? 10 : 0)
        }
        
        myPagebtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.leading.equalTo(20)
            make.height.equalTo(40)
            make.top.equalTo(levelDescLb.snp.bottom).offset(10)
            make.bottom.equalTo(-10)
        }
        
        cameraBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(profileImageView.snp.trailing)
            make.centerY.equalTo(profileImageView.snp.bottom)
            make.width.equalTo(DEVICEHEIGHT > 600 ? 60 : 40)
            make.height.equalTo(DEVICEHEIGHT > 600 ? 50 : 30)
        }
        
        myPagebtn.setTitle("Go to MY PAGE".localized, for: .normal)
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
        
        textField.resignFirstResponder()
        
        return true
    }
    
}

@objc protocol MyPageDelegate {
    
    @objc optional func callProfileImageOption(sender:UIButton)
    @objc optional func isbecomeKeyboard(sender:UITextField)
    @objc optional func isresignKeyboard(sender:UITextField)
    
}
