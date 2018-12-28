//
//  BadgeView.swift
//  WallPeckers
//
//  Created by Seongchan Kang on 28/12/2018.
//  Copyright © 2018 KimJimin and Company. All rights reserved.
//

import Foundation
import UIKit

final class BadgeView:UIView {
    
    let badgeImageView = UIImageView()
    let badgeTitleLb = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    func setData(badgeImage:String, badgeTitle:String, tag:Int, isCompleted:Bool = false) {
        self.tag = tag
        self.badgeImageView.image = UIImage.init(named: !isCompleted ? badgeImage : "\(badgeImage)C")
        self.badgeTitleLb.attributedText = badgeTitle.makeAttrString(font: .NotoSans(.bold, size: 12), color: .black)
    }
    
    private func setUI() {
        self.addSubview([badgeImageView, badgeTitleLb])
        
        badgeImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.width.equalTo(90)
            make.height.equalTo(90)
        }
        badgeTitleLb.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(badgeImageView.snp.bottom).offset(5)
            make.height.equalTo(40)
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        badgeImageView.contentMode = .scaleAspectFit
        badgeTitleLb.textAlignment = .center
        badgeTitleLb.adjustsFontSizeToFitWidth = true
        badgeTitleLb.numberOfLines = 2
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
