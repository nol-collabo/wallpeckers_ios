//
//  StartViewController.swift
//  WallPeckers
//
//  Created by Seongchan Kang on 26/11/2018.
//  Copyright © 2018 KimJimin and Company. All rights reserved.
//

import UIKit
import SnapKit
import RealmSwift
import SwiftyJSON

class StartViewController: UIViewController {

    let titleImv = UIImageView()
    let descScrollView = BaseHorizontalScrollView()
    let desc1View = UIImageView()
    let desc2View = UIImageView()
    let goetheView = UIImageView()
    let nolgongView = UIImageView()
    let playButton = UIButton()
    var selectedLanguage:Int?
    let user = realm.objects(User.self)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        
    }
    
    private func setUI() {
        
        self.view.addSubview([playButton, titleImv, nolgongView, goetheView])
        self.view.backgroundColor = UIColor.basicBackground
        

        self.navigationController?.isNavigationBarHidden = true
        playButton.backgroundColor = .black
        playButton.setAttributedTitle("PLAY".makeAttrString(font: .NotoSans(.bold, size: 30), color: .white), for: .normal)
        playButton.addTarget(self, action: #selector(playBtnTouched(sender:)), for: .touchUpInside)
        
        titleImv.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeArea.top).offset(33)
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview()
            make.height.equalTo(150)
        }
        titleImv.image = UIImage.init(named: "MainTitleImv")!
        titleImv.contentMode = .scaleAspectFit
        descScrollView.setScrollViewMiddle(vc: self)
        
        descScrollView.contentView.addSubview([desc2View, desc1View])
        
        desc1View.snp.makeConstraints { (make) in
            make.height.equalToSuperview()
            make.width.equalTo(DeviceSize.width)
            make.leading.top.equalToSuperview()
        }
        desc2View.snp.makeConstraints { (make) in
            make.leading.equalTo(desc1View.snp.trailing)
            make.width.equalTo(DeviceSize.width)
            make.trailing.equalToSuperview()
            make.height.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        playButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.safeArea.bottom).offset(-70)
            make.leading.equalTo(55)
            make.centerX.equalToSuperview()
            make.height.equalTo(56)
        }
        
        goetheView.snp.makeConstraints { (make) in

            make.leading.equalTo(100)
            make.width.equalTo(53)
            make.height.equalTo(25)
            make.bottom.equalTo(view.safeArea.bottom).offset(-7)
        }
        nolgongView.snp.makeConstraints { (make) in
            
            make.trailing.equalTo(-100)
            make.width.equalTo(77)
            make.height.equalTo(17)
            make.bottom.equalTo(view.safeArea.bottom).offset(-12)
        }
        
        desc1View.image = UIImage.init(named: "MainDescImv1")
        desc2View.image = UIImage.init(named: "MainDescImv2")
        goetheView.image = UIImage.init(named: "goethe")
        nolgongView.image = UIImage.init(named: "nolgong")
        
        
        
    }
    
    @objc func playBtnTouched(sender:UIButton) {
        
        PopUp.call(mainTitle: "LANGUAGE", selectButtonTitles: ["Deutch","한국어","English"], bottomButtonTitle: "확인", bottomButtonType: 0, self)
        
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


extension StartViewController:SelectPopupDelegate {
    func bottomButtonTouched(sender: UIButton) {
        
        if let _selectedLanguage = selectedLanguage {
            print(_selectedLanguage)
//
            if user.count > 0 { // 유저정보 없을 떄
                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "AfterRegisterViewController") as? AfterRegisterViewController else {return}
                
                self.navigationController?.pushViewController(vc, animated: true)

                
            }else{ // 신규유저
                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as? RegisterViewController else {return}
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
        
            
            
        }else{
            print("언어를 선택해주세요")
        }
    }
    
    func selectButtonTouched(tag: Int) {
        selectedLanguage = tag
        
        if tag == 0 {
            Standard.shared.changeLocalized(Language.GERMAN.rawValue)

        }else if tag == 1 {
            Standard.shared.changeLocalized(Language.KOREAN.rawValue)

        }else {
            Standard.shared.changeLocalized(Language.ENGLISH.rawValue)

        }

        
    }

}
