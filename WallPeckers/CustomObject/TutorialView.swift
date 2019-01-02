//
//  TutorialView.swift
//  WallPeckers
//
//  Created by Seongchan Kang on 28/12/2018.
//  Copyright © 2018 KimJimin and Company. All rights reserved.
//

import Foundation
import UIKit

final class TutorialView:UIView {
    
    let nextBtn = BottomButton()
    let topLb = UILabel()
    let descLb = UILabel()
    let descImv = UIImageView()
    var delegate:TutorialViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        print("XX")
        nextBtn.addTarget(self, action: #selector(moveToNext(sender:)), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        self.backgroundColor = .basicBackground
        self.addSubview([nextBtn, descLb, descImv, topLb])
        
        
        topLb.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(DEVICEHEIGHT > 600 ? 70 : 30)
            make.height.equalTo(50)
        }
        topLb.numberOfLines = 0
        descImv.contentMode = .scaleAspectFit
        
        nextBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(DEVICEHEIGHT > 600 ? -70 : -40)
            make.centerX.equalToSuperview()
            make.width.equalTo(270)
            make.height.equalTo(55)
        }
        nextBtn.setAttributedTitle("tutorial_startBtn".localized.makeAttrString(font: .NotoSans(.medium, size: 25), color: .white), for: .normal)
        descImv.snp.makeConstraints { (make) in
            make.top.equalTo(topLb.snp.bottom).offset(DeviceSize.width > 600 ? 40 : 20)
            make.centerX.equalToSuperview()
            make.leading.equalTo(20)
            make.height.equalTo(DEVICEHEIGHT > 600 ? 270 : 200)
        }
        descImv.contentMode = .scaleAspectFit
        descLb.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(descImv.snp.bottom).offset(DEVICEHEIGHT > 600 ? 50 : 30)
            make.leading.equalTo(10)
        }
        descLb.textAlignment = .center
        descLb.numberOfLines = 0
    }
    
    func setData(title:String, desc:String, images:[UIImage], isLast:Bool = false) {
        
        self.nextBtn.isHidden = !isLast
        self.topLb.setNotoText(title, size: 20, textAlignment: .center)
        self.descLb.setNotoText(desc, size: 16, textAlignment: .center)
        self.descImv.animationImages = images
        self.descImv.animationRepeatCount = 0
        self.descImv.animationDuration = 1
        self.descImv.startAnimating()
    }
    @objc func moveToNext(sender:UIButton) {
        UserDefaults.standard.set(true, forKey: "Tutorial")
        delegate?.touchMove(sender: sender)
    }
}

protocol TutorialViewDelegate {
    
    func touchMove(sender:UIButton)
    
}
