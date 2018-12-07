//
//  MyPageViewController.swift
//  WallPeckers
//
//  Created by Seongchan Kang on 03/12/2018.
//  Copyright © 2018 KimJimin and Company. All rights reserved.
//

import UIKit
import SnapKit
import AloeStackView

class MyPageViewController: UIViewController {

    let dismissBtn = UIButton()
    let profileView = UIView()
    let scoreView = MyPageSectionView()
    let levelView = MyPageSectionView()
    let badgeView = MyPageSectionView()
    let aStackView = AloeStackView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        
        // Do any additional setup after loading the view.
    }
    
    func setUI() {
        view.addSubview(aStackView)
        view.addSubview(dismissBtn)
        
        dismissBtn.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeArea.top)
            make.trailing.equalToSuperview()
            make.width.height.equalTo(40)
        }
        dismissBtn.backgroundColor = .blue
        aStackView.snp.makeConstraints { (make) in
           make.top.equalTo(dismissBtn.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeArea.bottom)
        }
        scoreView.setData(content: .Score)
        levelView.setData(content: .Level)
        badgeView.setData(content: .Badge)
        profileView.backgroundColor = .red
        aStackView.addRows([profileView, scoreView, levelView, badgeView])
        
        profileView.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(200)
        }
        dismissBtn.addTarget(self, action: #selector(dismissTouched(sender:)), for: .touchUpInside)

    }
    
    @objc func dismissTouched(sender:UIButton) {
        sender.isUserInteractionEnabled = false
        self.dismiss(animated: true) {
            sender.isUserInteractionEnabled = true
        }
    }
    
}



class MyPageSectionView:UIView {
    
    private let titleLb = UILabel()
    private let contentView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    func setUI() {
        
        self.addSubview([titleLb, contentView])
        
        titleLb.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.leading.equalTo(10)
            make.top.equalTo(10)
            make.height.equalTo(40)
        }
        titleLb.addUnderBar()
        
        contentView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLb.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func setData(content:ContentType) {
        
        titleLb.setNotoText(content.rawValue, color: .black, size: 20, textAlignment: .center)
//        titleLb.setText(title, color: .black, size: 20, textAlignment: .center)
        switch content {
        case .Badge:
            print(content.rawValue)
        case .Level:
            print(content.rawValue)
        case .Score:
            print(content.rawValue)
        }
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

enum ContentType:String {
    
    case Score = "내 점수"
    case Level = "내 레벨"
    case Badge = "내 뱃지"
//    , Level, Badge
}
