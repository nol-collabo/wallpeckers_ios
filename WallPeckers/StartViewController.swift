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

class StartViewController: UIViewController {

    
    let imageView = UIImageView()
    let playButton = UIButton()
    var selectedLanguage:Int?
    let user = realm.objects(User.self)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        
        print(user.count)
        
        
        
        print("CURRENTUSER")
        
        
        // Do any additional setup after loading the view.
    }
    
    private func setUI() {
        
        self.view.addSubview([imageView, playButton])
        
        playButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.safeArea.bottom).offset(-50)
            make.leading.equalTo(50)
            make.centerX.equalToSuperview()
            make.height.equalTo(80)
        }
        self.navigationController?.isNavigationBarHidden = true
        playButton.backgroundColor = .red
        playButton.addTarget(self, action: #selector(playBtnTouched(sender:)), for: .touchUpInside)
        imageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeArea.top).offset(50)
            make.width.height.equalTo(300)
        }
        
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
//            if user.count > 0 { // 유저정보 없을 떄
//                
//            }else{ // 신규유저
                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as? RegisterViewController else {return}
                
                self.navigationController?.pushViewController(vc, animated: true)
//            }
            
            
            
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
