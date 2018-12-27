//
//  RegisterViewController.swift
//  WallPeckers
//
//  Created by Seongchan Kang on 29/11/2018.
//  Copyright © 2018 KimJimin and Company. All rights reserved.
//

import UIKit
import RealmSwift
import Photos
//import King

let realm = try! Realm()
let DEVICEHEIGHT = UIWindow().bounds.height

class RegisterViewController: UIViewController {
    
    let scrollView = BaseVerticalScrollView()
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
    let keyboardResigner = UITapGestureRecognizer()
    let imagePicker = UIImagePickerController()
    var myImage:Data?
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
    
    
    var ages = realm.objects(Age.self)
    var localAges = realm.objects(LocalAge.self)
    
    let selectedLanguage = Standard.shared.getLocalized()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        keyboardResigner.addTarget(self, action: #selector(removeKeyboard))
        view.addGestureRecognizer(keyboardResigner)
        ageSelectPickerView.delegate = self
        ageSelectPickerView.dataSource = self
        nameTf.delegate = self
        picketViewGesture.addTarget(self, action: #selector(callPickerView(sender:)))
        ageSelectIndicatedLb.addGestureRecognizer(picketViewGesture)
        cameraBtn.addTarget(self, action: #selector(callProfileImageOption(sender:)), for: .touchUpInside)
        setUI()
      
        switch  selectedLanguage {
        case .ENGLISH:
            localAges = realm.objects(LocalAge.self).filter("language = 2")
        case .GERMAN:
           localAges = realm.objects(LocalAge.self).filter("language = 3")
        case .KOREAN:
            ages = realm.objects(Age.self)
        }
    }
    
    @objc func removeKeyboard() {
        nameTf.resignFirstResponder()
        myName = nameTf.text
        ageSelectPickerView.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.allButtonUserIteraction(true)
    }
    
    func checkPermission(completion:@escaping ((String)->())) {
        
        
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            print("Access is granted by user")
            completion("authorized")
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({
                (newStatus) in
                print("status is \(newStatus)")
                if newStatus ==  PHAuthorizationStatus.authorized {
                    /* do stuff here */
                    completion("notDetermined")

                    print("success")
                }
            })
            print("It is not determined until now")
        case .restricted:
            // same same
            completion("restricted")

            print("User do not have access to photo album.")
        case .denied:
            // same same
            completion("denied")

            print("User has denied the permission.")
        }
    }
    
    func checkPermission() {
        
        
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            print("Access is granted by user")
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({
                (newStatus) in
                print("status is \(newStatus)")
                if newStatus ==  PHAuthorizationStatus.authorized {
                    /* do stuff here */
                    
                    print("success")
                }
            })
            print("It is not determined until now")
        case .restricted:
            // same same
            
            print("User do not have access to photo album.")
        case .denied:
            // same same
            
            print("User has denied the permission.")
        }
    }
    
    func setUI() {
        
        
        
        view.addSubview([topLb, profileImv, cameraBtn, nameLb, ageLb, nameTf, registBtn, ageSelectPickerView, descLb, ageSelectIndicatedLb])
        view.backgroundColor = .basicBackground
        topLb.setNotoText("\("registration_toptitle".localized)\n\("registration_undertoptitle".localized)", color: .black, size: 25, textAlignment: .center, font: .medium)
        
        topLb.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeArea.top).offset(40)
            make.centerX.equalToSuperview()
        }
        
        profileImv.snp.makeConstraints { (make) in
            make.top.equalTo(topLb.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.width.equalTo(DEVICEHEIGHT > 600 ? 150 : 100)
            make.height.equalTo(DEVICEHEIGHT > 600 ? 180 : 120)
        }
        profileImv.setBorder(color: .black, width: 3.5)
        cameraBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(profileImv.snp.trailing)
            make.centerY.equalTo(profileImv.snp.bottom)
            make.width.equalTo(DEVICEHEIGHT > 600 ? 60 : 40)
            make.height.equalTo(DEVICEHEIGHT > 600 ? 50 : 30)
        }
        
//        profileImv.backgroundColor = .blue
        cameraBtn.setImage(UIImage.init(named: "profile_btn")!, for: .normal)
        
        nameLb.setNotoText("registration_penname".localized, color: .black, size: 14, textAlignment: .right)
        ageLb.setNotoText("registration_age".localized, size: 14, textAlignment: .right)
        nameLb.adjustsFontSizeToFitWidth = true
        ageLb.adjustsFontSizeToFitWidth = true
        nameLb.snp.makeConstraints { (make) in
            make.top.equalTo(cameraBtn.snp.bottom).offset(DEVICEHEIGHT > 600 ? 30 : 20)
            make.leading.equalTo(20)
            make.width.equalTo(80)
            make.height.equalTo(30)
        }
        nameTf.snp.makeConstraints { (make) in
            make.leading.equalTo(nameLb.snp.trailing).offset(10)
            make.centerY.equalTo(nameLb.snp.centerY)
            make.trailing.equalTo(-50)
            make.height.equalTo(30)
        }

        nameTf.keyboardType = .default
        nameTf.autocorrectionType = .no
        nameTf.addUnderBar()
        
        descLb.setNotoText("registration_namehint".localized, size: 10, textAlignment: .left)
        
        descLb.snp.makeConstraints { (make) in
            make.top.equalTo(nameTf.snp.bottom).offset(1)
            make.leading.equalTo(nameTf.snp.leading)
            make.height.equalTo(20)
        }
        
        ageLb.snp.makeConstraints { (make) in
            make.leading.equalTo(nameLb.snp.leading)
            make.top.equalTo(nameLb.snp.bottom).offset(30)
            make.height.equalTo(30)
            make.width.equalTo(80)

        }
        ageSelectPickerView.isHidden = true
        ageSelectIndicatedLb.snp.makeConstraints { (make) in
            make.leading.equalTo(nameTf.snp.leading)
            make.trailing.equalTo(-50)
            make.centerY.equalTo(ageLb.snp.centerY)
            make.height.equalTo(30)
        }
        ageSelectIndicatedLb.setNotoText("registration_defaultage".localized, color: .black, size: 20, textAlignment: .left, font: .medium)
        ageSelectIndicatedLb.adjustsFontSizeToFitWidth = true
        
        ageSelectIndicatedLb.isUserInteractionEnabled = true
        registBtn.isHidden = true
        ageSelectPickerView.snp.makeConstraints { (make) in
            make.leading.equalTo(nameTf.snp.leading)
            make.width.equalTo(nameTf.snp.width)
            make.top.equalTo(ageSelectIndicatedLb.snp.bottom)
            make.height.equalTo(DEVICEHEIGHT > 600 ? 100 : 70)
        }
        
        profileImv.image = UIImage.init(named: "basic_profile")!
        
        ageSelectPickerView.addUnderBar()
        ageSelectIndicatedLb.addUnderBar()
        registBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.safeArea.bottom).offset(-20)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(200)
        }
        
        registBtn.setAttributedTitle("registration_registbtn".localized.makeAttrString(font: .NotoSans(.medium, size: 25), color: .white), for: .normal)
        registBtn.addTarget(self, action: #selector(moveToNext(sender:)), for: .touchUpInside)
    }
    
    @objc func moveToNext(sender:UIButton) {
        
        sender.isUserInteractionEnabled = false
        
        
        guard let myName = nameTf.text else {return}

        
        let user = User()
        
        
        user.name = myName
        user.age = myAge ?? 0
        user.profileImage = self.myImage ?? UIImage.init(named: "basicProfileImage")?.pngData()
        
        try! realm.write {
            realm.add(user)
        }
         
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "AfterRegisterViewController") as? AfterRegisterViewController else {return}
        
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    @objc func callPickerView(sender:UITapGestureRecognizer) {
        
        self.ageSelectPickerView.isHidden = !(self.ageSelectPickerView.isHidden)
        
    }
    
    @objc func callProfileImageOption(sender:UIButton) {

        imagePicker.delegate = self
        PopUp.call(mainTitle: "registrationdialog_title".localized, selectButtonTitles: ["registrationdialog_camera".localized, "registrationdialog_album".localized, "registrationdialog_noprofile".localized], bottomButtonTitle: "CANCEL".localized, bottomButtonType: 0, self)
    }
    
}

extension RegisterViewController:UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {

            self.myImage = image.jpegData(compressionQuality: 0.5)
            self.profileImv.image = image
        }
        
        
        picker.dismiss(animated: true, completion: nil)
    }
}

class BottomButton:UIButton {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .black
        self.titleLabel?.font = UIFont.NotoSans(.bold, size: 20)
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
        
        if selectedLanguage == .KOREAN {
            
        return ages[row].age
        }else{
            return localAges[row].age
        }
        

        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if selectedLanguage == .KOREAN {
            ageSelectIndicatedLb.setNotoText(ages[row].age!, color: .black, size: 25, textAlignment: .left, font: .medium)

        }else{
            ageSelectIndicatedLb.setNotoText(localAges[row].age!, color: .black, size: 25, textAlignment: .left, font: .medium)
        }
            myAge = row
    }
}

extension RegisterViewController:UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        print(UIWindow().bounds.height)
        

        if DEVICEHEIGHT < 800 {
            UIView.animate(withDuration: 0.2) {
                self.view.center = .init(x: self.view.center.x, y: self.view.center.y - 80)
                
            }
        }

    }
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        
        if DEVICEHEIGHT < 800 {
            UIView.animate(withDuration: 0.2) {
                self.view.center = .init(x: self.view.center.x, y: self.view.center.y + 80)
            }
        }
        


    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        myName = textField.text
        return true
    }
    
    
    
}

extension RegisterViewController:SelectPopupDelegate {
    func bottomButtonTouched(sender: UIButton) {

        self.removePopUpView()

    }
    
    func selectButtonTouched(tag: Int) {
        
        switch tag {
        case 0:
            imagePicker.sourceType = .camera
            checkPermission()
//            checkPermission { (result) in
//                if result == "authorized" {
                self.present(self.imagePicker, animated: true, completion: nil)
//                }
//            }
        case 1:
            imagePicker.sourceType = .photoLibrary
            checkPermission()

//            checkPermission { (result) in
//                if result == "authorized" {
                    self.present(self.imagePicker, animated: true, completion: nil)
//                }
//            }
        case 2:
            print("DEFAULT")
        default:
            break
        }
        
        self.removePopUpView()

//        print(tag)
    }
    
    
}

extension UILabel {
    
    
    
    func setNotoText(_ text:String, color:UIColor = .black, size:CGFloat, textAlignment:NSTextAlignment, font:NotoSansFontSize = NotoSansFontSize.medium) {
                
        self.attributedText = text.localized.makeAttrString(font: UIFont.init(name: font.rawValue, size: size)!, color: color)
        self.textAlignment = textAlignment
        self.numberOfLines = 0
    }
    
    func setAmericanTyperWriterText(_ text:String, color:UIColor = .black, size:CGFloat, textAlignment:NSTextAlignment, font:AmericanTypeWriterFontSize = AmericanTypeWriterFontSize.regular) {
        
        self.attributedText = text.localized.makeAttrString(font: UIFont.init(name: font.rawValue, size: size)!, color: color)
        self.textAlignment = textAlignment
        self.numberOfLines = 0
    }

}

extension String {
    
    func makeAttrString(font:UIFont, color:UIColor) -> NSMutableAttributedString {
        
        let descTitle = NSMutableAttributedString.init(string:self)
        
        descTitle.addAttributes([NSAttributedString.Key.foregroundColor:color, NSAttributedString.Key.font:font], range: NSRange.init(location: 0, length: descTitle.length))
        
        return descTitle
    }
    
    var localized: String {
        
        let countryCode = Standard.shared.getLocalized()
        
        let path = Bundle.main.path(forResource: countryCode.rawValue, ofType: "lproj")
        let bundleName = Bundle(path: path!)
        return NSLocalizedString(self, tableName: nil, bundle: bundleName!, value: "", comment: "")    }
}

enum NotoSansFontSize:String {
    
    case bold = "NotoKR-Black"
    case regular = "NotoKR-Regular"
    case medium = "NotoKR-Medium"
    case thin = "NotoKR-Thin"
    
}

enum AmericanTypeWriterFontSize:String {
    
    case bold = "AmericanTypewriter-Bold"
    case regular = "AmericanTypewriter"
    case light = "AmericanTypewriter-Light"
    
}
