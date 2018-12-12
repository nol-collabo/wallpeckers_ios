//
//  NavigationCustomView.swift
//  WallPeckers
//
//  Created by Seongchan Kang on 12/12/2018.
//  Copyright © 2018 KimJimin and Company. All rights reserved.
//

import Foundation
import SnapKit

class NavigationCustomView:UIView {
    
    let backgroundImageView = UIImageView()
    let textLb = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    private func setUI() {
        
        self.addSubview([backgroundImageView, textLb])
        
        backgroundImageView.snp.makeConstraints { (make) in
            
            make.edges.equalToSuperview()
            
        }
        
        textLb.snp.makeConstraints { (make) in
            make.trailing.equalTo(-8)
            make.bottom.equalTo(-2)
            
        }
        
    }
    
    func setData(text:String, backgroundimage:UIImage) {
        backgroundImageView.image = backgroundimage
    }
    
    func updateTime(_ time:Int) {
        
        let (_, m, s) = secondsToHoursMinutesSeconds(seconds: time)
        
        self.textLb.setNotoText("\(m):\(s)", size: 14, textAlignment: .center)
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class GameNavigationBar:UIView {
    
    let timerView = NavigationCustomView()
    let myPageBtn = BottomButton()
    let scoreView = NavigationCustomView()
    var delegate:GameNavigationBarDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //        self.backgroundColor = .red
        setUI()
    }
    
    
    func setUI() {
        
        self.addSubview([timerView, myPageBtn, scoreView])
        self.backgroundColor = .basicBackground
        timerView.snp.makeConstraints { (make) in
            make.top.equalTo(16)
            make.width.equalTo(72)
            make.height.equalTo(33)
            make.leading.equalTo(18)
        }
        myPageBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalTo(82)
            make.height.equalTo(20)
            make.top.equalTo(29)
            
        }
        myPageBtn.setBorder(color: .black, width: 1, cornerRadius: 3)
        
        scoreView.snp.makeConstraints { (make) in
            make.top.equalTo(13)
            make.width.equalTo(86)
            make.height.equalTo(36)
            make.trailing.equalTo(-19)
        }
        
        timerView.tag = 99
        timerView.setData(text: "", backgroundimage: UIImage.init(named: "timeSectionView")!)
        scoreView.setData(text: "", backgroundimage: UIImage.init(named: "scoreSectionView")!)
        
        myPageBtn.setAttributedTitle("MY PAGE".makeAttrString(font: .NotoSans(.medium, size: 14), color: .white), for: .normal)
        myPageBtn.addTarget(self, action: #selector(moveToMyPage(sender:)), for: .touchUpInside)
        
    }
    
    
    
    @objc func moveToMyPage(sender:UIButton) {
        delegate?.touchMoveToMyPage(sender: sender)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

protocol GameNavigationBarDelegate {
    
    func touchMoveToMyPage(sender:UIButton)
    
}
