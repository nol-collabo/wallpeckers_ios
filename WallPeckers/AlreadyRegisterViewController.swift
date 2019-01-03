//
//  AlreadyRegisterViewController.swift
//  WallPeckers
//
//  Created by Seongchan Kang on 30/11/2018.
//  Copyright © 2018 KimJimin and Company. All rights reserved.
//

import UIKit
import SnapKit


class AlreadyRegisterViewController: UIViewController {
    
    let titleImageView = UIImageView()
    let descLb = UILabel()
    let newStartBtn = UIButton()
    let continueBtn = UIButton()
    let nextBtn = BottomButton()
    let goetheView = UIImageView()
    let nolgongView = UIImageView()
    let divider = UIView()
    var startType:Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
 
    }
    
    private func setUI(){
        
        self.view.addSubview([titleImageView, descLb, newStartBtn, divider, continueBtn, nextBtn, goetheView, nolgongView])
        self.view.backgroundColor = .basicBackground
        titleImageView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeArea.top).offset(52)
            make.centerX.equalToSuperview()
            make.leading.equalTo(10)
            make.height.equalTo(50)
        }
        descLb.snp.makeConstraints { (make) in
            make.top.equalTo(titleImageView.snp.bottom).offset(53)
            make.leading.equalTo(15)
            make.centerX.equalToSuperview()
        }
        descLb.numberOfLines = 0
        descLb.textAlignment = .center
        descLb.attributedText = "selectload_desc".localized.makeAttrString(font: .NotoSans(.medium, size: 16), color: .black)
        
        goetheView.snp.makeConstraints { (make) in
            
            make.leading.equalTo(80)
            make.width.equalTo(53)
            make.height.equalTo(25)
            make.bottom.equalTo(view.safeArea.bottom).offset(-7)
        }
        nolgongView.snp.makeConstraints { (make) in
            
            make.trailing.equalTo(-80)
            make.width.equalTo(77)
            make.height.equalTo(17)
            make.bottom.equalTo(view.safeArea.bottom).offset(-12)
        }
        

        newStartBtn.setAttributedTitle("selectload_newgame".localized.makeAttrString(font: .NotoSans(.medium, size: 21), color: .black), for: .normal)
        continueBtn.setAttributedTitle("selectload_continuegame".localized.makeAttrString(font: .NotoSans(.medium, size: 21), color: .black), for: .normal)
        

        divider.backgroundColor = .black
        
        nextBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.safeArea.bottom).offset(-50)
            make.width.equalToSuperview().multipliedBy(0.7)
            make.height.equalTo(DeviceSize.width > 320 ? 60 : 40)
            make.centerX.equalToSuperview()
        }
        
        continueBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(nextBtn.snp.top).offset(-50)
            make.leading.equalTo(30)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
        }
        
        divider.snp.makeConstraints { (make) in
            make.height.equalTo(1.5)
            make.bottom.equalTo(continueBtn.snp.top).offset(-15)
            make.centerX.equalToSuperview()
            make.width.equalTo(continueBtn.snp.width)
        }
        
        
        newStartBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(divider.snp.top).offset(-15)
            make.leading.equalTo(30)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
        }
        


        
        newStartBtn.setBackgroundColor(color: .sunnyYellow, forState: .selected)
        continueBtn.setBackgroundColor(color: .sunnyYellow, forState: .selected)

        newStartBtn.addTarget(self, action: #selector(moveToNewStart(sender:)), for: .touchUpInside)
        continueBtn.addTarget(self, action: #selector(moveToContinue(sender:)), for: .touchUpInside)
        
        
        switch Standard.shared.getLocalized() {
            
        case .ENGLISH:
            titleImageView.image = UIImage.init(named: "enLogo")!

        case .GERMAN:
            titleImageView.image = UIImage.init(named: "deLogo")!

        case .KOREAN:
            titleImageView.image = UIImage.init(named: "krLogo")!
            
        }
        
        titleImageView.contentMode = .scaleAspectFit
        goetheView.image = UIImage.init(named: "goethe")
        nolgongView.image = UIImage.init(named: "nolgong")
        nextBtn.addTarget(self, action: #selector(moveToMain(sender:)), for: .touchUpInside)
        nextBtn.setAttributedTitle("OK".localized.makeAttrString(font: .NotoSans(.medium, size: 30), color: .white), for: .normal)
    }
    
    @objc func moveToMain(sender:UIButton) {
        
        sender.isUserInteractionEnabled = false
        if startType == 0 {
            sender.isUserInteractionEnabled = true
            return
        }else {
            sender.isUserInteractionEnabled = true

            if startType == 1 {
                        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "AfterRegisterViewController") as? AfterRegisterViewController else {return}
                    sender.isUserInteractionEnabled = true
                        RealmUser.shared.initializedUserInfo()
                        self.navigationController?.pushViewController(vc, animated: true)
            }else if startType == 2 {
                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "AfterRegisterViewController") as? AfterRegisterViewController else {return}
                sender.isUserInteractionEnabled = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
    }
    
    func deselectBtn() {
        for btn in [newStartBtn, continueBtn] {
            btn.isSelected = false
        }
    }
    
    @objc func moveToNewStart(sender:UIButton) {
        
        deselectBtn()
        sender.isSelected = !(sender.isSelected)
        startType = 1

    }
    
    @objc func moveToContinue(sender:UIButton) {
        deselectBtn()
        sender.isSelected = !(sender.isSelected)
        startType = 2
    }

}
