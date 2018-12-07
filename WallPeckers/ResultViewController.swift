//
//  ResultViewController.swift
//  WallPeckers
//
//  Created by Seongchan Kang on 07/12/2018.
//  Copyright © 2018 KimJimin and Company. All rights reserved.
//

import UIKit
import AloeStackView

class ResultViewController: UIViewController {
    
    let aloeStackView = AloeStackView()
    let buttonView = UIView()
    let myPageButton = BottomButton()
    let startButton = BottomButton()
    let profileView = UIView()
    let resultView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .basicBackground
        self.view.addSubview(aloeStackView)
        aloeStackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        aloeStackView.addRows([resultView, profileView, buttonView])
        
        resultView.snp.makeConstraints { (make) in
            make.height.equalTo(400)
        }
        resultView.backgroundColor = .red
        profileView.snp.makeConstraints { (make) in
            make.height.equalTo(300)
        }
        buttonView.snp.makeConstraints { (make) in
            make.height.equalTo(130)
        }
//        buttonView.backgroundColor = .blue
        buttonView.addSubview([myPageButton, startButton])
        
        myPageButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.height.equalTo(60)
            make.width.equalToSuperview()
        }
        startButton.snp.makeConstraints { (make) in
            make.top.equalTo(myPageButton.snp.bottom).offset(10)
            make.height.equalTo(60)
            make.width.equalToSuperview()
        }
        
        myPageButton.setAttributedTitle("마이페이지".makeAttrString(font: .NotoSans(.medium, size: 20), color: .white), for: .normal)
        startButton.setAttributedTitle("시작 화면으로".makeAttrString(font: .NotoSans(.medium, size: 20), color: .white), for: .normal)
        myPageButton.addTarget(self, action: #selector(moveToMyPage(sender:)), for: .touchUpInside)
        startButton.addTarget(self, action: #selector(moveToMain(sender:)), for: .touchUpInside)

        
        aloeStackView.backgroundColor = .basicBackground
        // Do any additional setup after loading the view.
    }
    
    @objc func moveToMyPage(sender:UIButton) {
        guard let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyPageViewController") as? MyPageViewController else {return}
        sender.isUserInteractionEnabled = true
        
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func moveToMain(sender:UIButton) {
        guard let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AfterRegisterViewController") as? AfterRegisterViewController else {return}
        sender.isUserInteractionEnabled = true
        
        guard let nvc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainStart") as? UINavigationController else {return}
        
//        nvc.set
        
        self.present(nvc, animated: true) {
            nvc.pushViewController(vc, animated: true)

        }
//        self.present(vc, animated: true, completion: nil)
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
