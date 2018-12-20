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

    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        
        // Do any additional setup after loading the view.
    }
    
    func setUI(){
        
        self.view.addSubview([titleImageView, descLb, newStartBtn, continueBtn, nextBtn, goetheView, nolgongView])
        self.view.backgroundColor = .basicBackground
        titleImageView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeArea.top).offset(33)
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview()
            make.height.equalTo(150)
        }
        descLb.snp.makeConstraints { (make) in
            make.top.equalTo(titleImageView.snp.bottom).offset(10)
            make.leading.equalTo(10)
            make.centerX.equalToSuperview()
        }
        descLb.numberOfLines = 0
        
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
        
        newStartBtn.snp.makeConstraints { (make) in
            make.top.equalTo(descLb.snp.bottom).offset(200)
            make.leading.equalTo(30)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
        }
        newStartBtn.setAttributedTitle("Start a New Game".makeAttrString(font: .NotoSans(.medium, size: 21), color: .black), for: .normal)
        continueBtn.setAttributedTitle("Continue the last game".makeAttrString(font: .NotoSans(.medium, size: 21), color: .black), for: .normal)
        
        continueBtn.snp.makeConstraints { (make) in
            make.top.equalTo(newStartBtn.snp.bottom).offset(30)
            make.leading.equalTo(30)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
        }
        
        newStartBtn.setBackgroundColor(color: .sunnyYellow, forState: .selected)
        newStartBtn.setBackgroundColor(color: .sunnyYellow, forState: .highlighted)
        continueBtn.setBackgroundColor(color: .sunnyYellow, forState: .selected)
        continueBtn.setBackgroundColor(color: .sunnyYellow, forState: .highlighted)

        newStartBtn.addTarget(self, action: #selector(moveToNewStart(sender:)), for: .touchUpInside)
        continueBtn.addTarget(self, action: #selector(moveToContinue(sender:)), for: .touchUpInside)
        
        titleImageView.image = UIImage.init(named: "MainTitleImv")!
        titleImageView.contentMode = .scaleAspectFit
        goetheView.image = UIImage.init(named: "goethe")
        nolgongView.image = UIImage.init(named: "nolgong")
        
    }
    
    @objc func moveToNewStart(sender:UIButton) {
        sender.isSelected = !(sender.isSelected)
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "AfterRegisterViewController") as? AfterRegisterViewController else {return}
        RealmUser.shared.initializedUserInfo()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func moveToContinue(sender:UIButton) {
        sender.isSelected = !(sender.isSelected)
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "AfterRegisterViewController") as? AfterRegisterViewController else {return}
        self.navigationController?.pushViewController(vc, animated: true)
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
