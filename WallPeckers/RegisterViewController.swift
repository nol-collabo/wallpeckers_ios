//
//  RegisterViewController.swift
//  WallPeckers
//
//  Created by Seongchan Kang on 29/11/2018.
//  Copyright © 2018 KimJimin and Company. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    
    let topLb = UILabel()
    let profileImv = UIImageView()
    let cameraBtn = UIButton()
    let nameLb = UILabel()
    let ageLb = UILabel()
    let nameTf = UITextField()
    let ageSelectPickerView = UIPickerView()
    let ageSelectIndicatedLb = UILabel()
    let arrowImv = UIImageView()
    let registBtn = BottomButton()
    let descLb = UILabel()
    let picketViewGesture = UITapGestureRecognizer()
    var myName:String? {
        didSet {
            
            if myName != nil && myAge != nil {
                    registBtn.isHidden = false
            }
            
        }
    }

    var myAge:Int?{
        didSet {
            
            if myName != nil && myAge != nil {
                registBtn.isHidden = false
            }
            
        }
    }
    
    
    let ages = ["Select None", "Under 10", "10-19", "20-29", "30-39", "40-49", "50-59", "Above 60"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ageSelectPickerView.delegate = self
        ageSelectPickerView.dataSource = self
        nameTf.delegate = self
        picketViewGesture.addTarget(self, action: #selector(callPickerView(sender:)))
        ageSelectIndicatedLb.addGestureRecognizer(picketViewGesture)
        cameraBtn.addTarget(self, action: #selector(callProfileImageOption(sender:)), for: .touchUpInside)
        setUI()

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.allButtonUserIteraction(true)
    }
    
    func setUI() {
        
        
        view.addSubview([topLb, profileImv, cameraBtn, nameLb, ageLb, nameTf, registBtn, ageSelectPickerView, descLb, ageSelectIndicatedLb])
        
        topLb.setText("기자증 신청\nPRESS PASS", color: .black, size: 20, textAlignment: .center)
        
        topLb.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeArea.top).offset(20)
            make.centerX.equalToSuperview()
        }
        
        profileImv.snp.makeConstraints { (make) in
            make.top.equalTo(topLb.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(130)
        }
        cameraBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(profileImv.snp.trailing)
            make.centerY.equalTo(profileImv.snp.bottom)
            make.width.height.equalTo(50)
        }
        
        profileImv.backgroundColor = .blue
        cameraBtn.backgroundColor = .red
        
        nameLb.setText("필명", color: .black, size: 16, textAlignment: .right)
        ageLb.setText("연령대", size: 16, textAlignment: .right)
        
        nameLb.snp.makeConstraints { (make) in
            make.top.equalTo(cameraBtn.snp.bottom).offset(30)
            make.leading.equalTo(50)
            make.width.equalTo(50)
            make.height.equalTo(30)
        }
        nameTf.snp.makeConstraints { (make) in
            make.leading.equalTo(nameLb.snp.trailing).offset(10)
            make.centerY.equalTo(nameLb.snp.centerY)
            make.width.equalTo(200)
            make.height.equalTo(30)
        }

        nameTf.addUnderBar()
        
        descLb.setText("*필명:내가 쓴 기사에 사용할 이름", size: 10, textAlignment: .left)
        
        descLb.snp.makeConstraints { (make) in
            make.top.equalTo(nameTf.snp.bottom).offset(1)
            make.leading.equalTo(nameTf.snp.leading)
            make.height.equalTo(20)
        }
        
        ageLb.snp.makeConstraints { (make) in
            make.leading.equalTo(nameLb.snp.leading)
            make.top.equalTo(nameLb.snp.bottom).offset(30)
            make.height.equalTo(30)
            make.width.equalTo(50)

        }
        ageSelectPickerView.isHidden = true
        ageSelectIndicatedLb.snp.makeConstraints { (make) in
            make.leading.equalTo(nameTf.snp.leading).offset(10)
            make.width.equalTo(200)
            make.centerY.equalTo(ageLb.snp.centerY)
            make.height.equalTo(30)
        }
        ageSelectIndicatedLb.text = "hi"
        ageSelectIndicatedLb.isUserInteractionEnabled = true
        registBtn.isHidden = true
        ageSelectPickerView.snp.makeConstraints { (make) in
            make.leading.equalTo(nameTf.snp.leading)
            make.width.equalTo(nameTf.snp.width)
            make.top.equalTo(ageSelectIndicatedLb.snp.bottom)
            make.height.equalTo(100)
        }
        
        ageSelectPickerView.addUnderBar()
        ageSelectIndicatedLb.addUnderBar()
        registBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.safeArea.bottom)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(200)
        }
        
        registBtn.setTitle("Play".localized, for: .normal)
        registBtn.addTarget(self, action: #selector(moveToNext(sender:)), for: .touchUpInside)
    }
    
    @objc func moveToNext(sender:UIButton) {
        
        sender.isUserInteractionEnabled = false
        
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "AfterRegisterViewController") as? AfterRegisterViewController else {return}
        
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    @objc func callPickerView(sender:UITapGestureRecognizer) {
        
        self.ageSelectPickerView.isHidden = !(self.ageSelectPickerView.isHidden)
        
    }
    
    @objc func callProfileImageOption(sender:UIButton) {
//        sender.isUserInteractionEnabled = false
        PopUp.call(mainTitle: "사진 추가", selectButtonTitles: ["카메라", "사진첩", "기본 이미지로"], bottomButtonTitle: "취소", bottomButtonType: 1, self)
    }
    
}

class BottomButton:UIButton {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .black
        self.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        self.titleLabel?.textColor = .white
        if self.isEnabled {
            self.backgroundColor = .black

        }else{
            self.backgroundColor = .red
        }
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension RegisterViewController:UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ages.count

    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        
    
        return ages[row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        pickerView.isHidden = true
        myAge = row
        ageSelectIndicatedLb.text = ages[row]
        
    }

    
}

extension RegisterViewController:UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        myName = textField.text
        return true
    }
    
    
    
}

extension RegisterViewController:SelectPopupDelegate {
    func bottomButtonTouched(sender: UIButton) {

        self.removePopUpView()
//        print(sender)
    }
    
    func selectButtonTouched(tag: Int) {
        print(tag)
    }
    
    
}

extension UILabel {
    
    
    func setText(_ text:String, color:UIColor = .black, size:CGFloat, textAlignment:NSTextAlignment) {
        
        self.text = text.localized
        self.textColor = color
        self.font = UIFont.systemFont(ofSize: size, weight: .regular)
        self.textAlignment = textAlignment
        self.numberOfLines = 0
    }
//
//    func makeAttributeString() -> NSAttributedString {
//
////        let aString:NSMutableAttributedString = self.color
//
//
//
//    }
    
}

extension String {
    
    var localized: String {
        
        let countryCode = Standard.shared.getLocalized()
        
        let path = Bundle.main.path(forResource: countryCode, ofType: "lproj")
        let bundleName = Bundle(path: path!)
        return NSLocalizedString(self, tableName: nil, bundle: bundleName!, value: "", comment: "")    }
}


