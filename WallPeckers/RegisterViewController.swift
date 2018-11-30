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
    let registBtn = BottomButton()
    let descLb = UILabel()
    let ages = ["Under 10", "10-19", "20-29", "30-39", "40-49", "50-59", "Above 60", "Select None"]
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        ageSelectPickerView.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    func setUI() {
        
        
        view.addSubview([topLb, profileImv, cameraBtn, nameLb, ageLb, nameTf, registBtn, ageSelectPickerView, descLb])
        
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
//            make.center.equalTo(profileImv.snp.bottom)
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
        ageSelectPickerView.snp.makeConstraints { (make) in
            make.leading.equalTo(nameTf.snp.leading)
            make.width.equalTo(nameTf.snp.width)
            make.top.equalTo(ageLb.snp.top)
            make.height.equalTo(80)
        }
        
        
        registBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.safeArea.bottom)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(200)
        }
        
        registBtn.setTitle("Play".localized, for: .normal)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

class BottomButton:UIButton {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .black
        self.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        self.titleLabel?.textColor = .white
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension RegisterViewController:UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        
        
        return ages[row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        
        return UILabel()
        
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
        return NSLocalizedString(self, comment: "")
    }
}


