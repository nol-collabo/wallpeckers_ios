//
//  ArticleChooseViewController.swift
//  WallPeckers
//
//  Created by Seongchan Kang on 07/12/2018.
//  Copyright © 2018 KimJimin and Company. All rights reserved.
//

import UIKit

class ArticleChooseViewController: UIViewController, GameNavigationBarDelegate, GamePlayTimeDelegate, AlerPopupViewDelegate {
    func tapBottomButton(sender: AlertPopUpView) {
        if sender.tag == 1 {
            
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ResultViewController") as? ResultViewController else {return}
            
            sender.removeFromSuperview()

            self.navigationController?.pushViewController(vc, animated: true)
            
                
            print("MOVE TO NEXT")
        }else {
            sender.removeFromSuperview()
        }
    }
    
    func checkPlayTime(_ time: Int) {
        timerView?.updateTime(time)
        if time == 0 { //완료 됐을떄
            
            PopUp.callAlert(time: "00:00", desc: "완료", vc: self, tag: 1)
            print("END!")
            
        }else if time == 60 { // 1분 남았을 때
            PopUp.callAlert(time: "01:00", desc: "1분", vc: self, tag: 2)
            
            print("1minute!")
            
        }
    }
    
    
    
    var timerView:NavigationCustomView?
    let backButton = UIButton()
    let articleTitleLb = UILabel()

    
    func touchMoveToMyPage(sender: UIButton) {
        sender.isUserInteractionEnabled = false
        
        guard let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyPageViewController") as? MyPageViewController else {return}
        sender.isUserInteractionEnabled = true
        
        self.present(vc, animated: true, completion: nil)
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        Standard.shared.delegate = self
        self.setCustomNavigationBar()
        self.timerView = self.findTimerView()
        self.view.backgroundColor = .basicBackground
        backButton.setImage(UIImage.init(named: "backButton")!, for: .normal)
        self.view.addSubview(backButton)
        self.view.addSubview(articleTitleLb)
        backButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(40)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeArea.bottom).offset(-40)
        }
        
        articleTitleLb.setNotoText("CHOOSE A ARTICLE", color: .black, size: 24, textAlignment: .center, font: .medium)
        
        articleTitleLb.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeArea.top).offset(90)
            make.height.equalTo(35)
            make.centerX.equalToSuperview()
        }
        
        backButton.addTarget(self, action: #selector(back(sender:)), for: .touchUpInside)

        // Do any additional setup after loading the view.
    }
    
    @objc func back(sender:UIButton) {
        
        sender.isUserInteractionEnabled = false
        
        self.navigationController?.popViewController(animated: false)
        
        sender.isUserInteractionEnabled = true
        
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
