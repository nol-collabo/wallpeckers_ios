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
    let pressButton = BottomButton()
    let profileView = MyProfileView()
    let resultView = UIImageView()
    let profileBaseView = UIView()
    let currentLanguage = Standard.shared.getLocalized()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .basicBackground
        self.view.addSubview(aloeStackView)
        aloeStackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        UserDefaults.standard.set(0, forKey: "enterForeground")
        UserDefaults.standard.set(0, forKey: "enterBackground")
        
        let congLb = UILabel()
        
        
        congLb.attributedText = String(format:"getPrize".localized, RealmUser.shared.getUserLevel()).makeAttrString(font: .NotoSans(.bold, size: 17), color: .black)
        congLb.textAlignment = .center
        congLb.numberOfLines = 0
        
        
        
        aloeStackView.addRows([resultView, congLb, profileBaseView, buttonView])
        
        resultView.snp.makeConstraints { (make) in
            make.height.equalTo(250)
        }
        
        resultView.animationImages = [UIImage.init(named: "en4tuto1")!, UIImage.init(named: "en4tuto2")!]
        resultView.animationDuration = 1
        resultView.animationRepeatCount = 0
        resultView.startAnimating()

        profileBaseView.addSubview(profileView)
        profileView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(DEVICEHEIGHT > 600 ? 42 : 32)
            make.height.equalTo(DEVICEHEIGHT > 600 ? 360 : 290)

        }
                
        resultView.contentMode = .scaleAspectFit
        
        profileView.setData(userData: RealmUser.shared.getUserData()!, level: RealmUser.shared.getUserLevel(), camera: false, nameEdit: false, myPage: false)
        buttonView.addSubview([pressButton, myPageButton, startButton])
        pressButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.height.equalTo(60)
            make.width.equalToSuperview().multipliedBy(0.7)
            make.centerX.equalToSuperview()

        }
        pressButton.setAttributedTitle("Printing Press".makeAttrString(font: .NotoSans(.bold, size: 18), color: .black), for: .normal)
        
        let completedArticle = RealmArticle.shared.get(Standard.shared.getLocalized()).filter({
            
            $0.isCompleted
        })
        
        pressButton.isHidden = completedArticle.count == 0
        
        pressButton.setBackgroundColor(color: .sunnyYellow, forState: .normal)
        
        myPageButton.snp.makeConstraints { (make) in
            
            if pressButton.isHidden {
                make.top.equalTo(30)
            }else{
                make.top.equalTo(pressButton.snp.bottom).offset(30)
            }
            
            make.height.equalTo(60)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.7)
        }
        startButton.snp.makeConstraints { (make) in
            make.top.equalTo(myPageButton.snp.bottom).offset(10)
            make.height.equalTo(60)
            make.width.equalToSuperview().multipliedBy(0.7)
            make.bottom.equalToSuperview().offset(-10)
            make.centerX.equalToSuperview()

        }
        
        myPageButton.setAttributedTitle("publish_gomymenubtn".localized.makeAttrString(font: .NotoSans(.medium, size: 20), color: .white), for: .normal)
        startButton.setAttributedTitle("publish_gohomebtn".localized.makeAttrString(font: .NotoSans(.medium, size: 20), color: .white), for: .normal)
        pressButton.setBorder(color: .black, width: 1.5)
        pressButton.addTarget(self, action: #selector(moveToPublish(sender:)), for: .touchUpInside)
        myPageButton.addTarget(self, action: #selector(moveToMyPage(sender:)), for: .touchUpInside)
        startButton.addTarget(self, action: #selector(moveToMain(sender:)), for: .touchUpInside)

        
        aloeStackView.backgroundColor = .basicBackground
        // Do any additional setup after loading the view.
    }
    
    @objc func moveToPublish(sender:UIButton) {
        
        let aa = RealmArticle.shared.get(Standard.shared.getLocalized()).filter({$0.isCompleted})
        
        try! realm.write {

            if (RealmUser.shared.getUserData()?.publishedArticles.count)! > 0 {
            _ = RealmUser.shared.getUserData()?.publishedArticles.removeAll()
            }

            _ = aa.map({

                if aa.count < 3 {
                    RealmUser.shared.getUserData()?.publishedArticles.append($0.id)
                }else{
                    if (RealmUser.shared.getUserData()?.publishedArticles.count)! < 3 {
                        RealmUser.shared.getUserData()?.publishedArticles.append($0.id)
                    }
                }

            })
        }

        
        
        sender.isUserInteractionEnabled = false
        
        guard let vc = UIStoryboard.init(name: "Publish", bundle: nil).instantiateViewController(withIdentifier: "Publish") as? UINavigationController else {return}
        
        
        sender.isUserInteractionEnabled = true
        self.present(vc, animated: true, completion: nil)
        
        
    }
    
    @objc func moveToMyPage(sender:UIButton) {
        guard let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyPage") as? UINavigationController else {return}
        sender.isUserInteractionEnabled = true
        print(vc.viewControllers)
        
        if let mvc = vc.viewControllers[0] as? MyPageViewController {
            
            mvc.fromResult = true
        }
        
        
        
        self.present(vc, animated: true, completion: nil)
    } 
    
    @objc func moveToMain(sender:UIButton) {

        
        guard let nvc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainStart") as? UINavigationController else {return}
        
        
        self.removeFromParent()
        
        self.present(nvc, animated: true) // 완료 후 시작 페이지로, 아래꺼 누르면 안드로이드처럼 내 프로필로 가긴 하는데 이상해서 일단 주석처리 해놓음
//        {
//            nvc.pushViewController(vc, animated: true)
//
//        }
//        self.present(vc, animated: true, completion: nil)
    }

}
