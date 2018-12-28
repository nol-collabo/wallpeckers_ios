//
//  ArticleSelectButton.swift
//  WallPeckers
//
//  Created by Seongchan Kang on 28/12/2018.
//  Copyright © 2018 KimJimin and Company. All rights reserved.
//

import Foundation
import UIKit

final class ArticleSelectButton:UIView {
    
    let pointTitleLb = UILabel()
    let starImageView = UIImageView()
    let titleLb = UILabel()
    let tapGesture = UITapGestureRecognizer()
    var delegate:ArticleSelectDelegate?
    var borderColor:UIColor?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addGestureRecognizer(tapGesture)
        tapGesture.addTarget(self, action: #selector(tap(sender:)))
        setUI()
    }
    
    func setUI() {
        self.addSubview([pointTitleLb, starImageView, titleLb])
        pointTitleLb.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(5)
            make.height.equalTo(30)
        }
        starImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(5)
            make.width.height.equalTo(25)
        }
        titleLb.snp.makeConstraints { (make) in
            make.leading.equalTo(7)
            make.bottom.equalTo(-7)
            make.trailing.equalTo(-7)
            make.top.equalTo(starImageView.snp.bottom).offset(5)
            make.height.equalTo(30)
        }
        starImageView.image = UIImage.init(named: "YellowStar")
        
    }
    
    func setData(point:String, textColor:UIColor, title:String, isStar:Bool, tag:Int, backgroundColor:UIColor = .white, borderColor:UIColor = .black) {
        self.borderColor = borderColor
        self.pointTitleLb.setNotoText(point, color: textColor, size: 26, textAlignment: .center, font: .bold)
        self.titleLb.setNotoText(title, color: textColor, size: 12, textAlignment: .center, font: .bold)
        self.starImageView.isHidden = !isStar
        self.backgroundColor = backgroundColor
        self.tag = tag
        self.setBorder(color: borderColor, width: 4.5)
        self.titleLb.adjustsFontSizeToFitWidth = true
    }
    
    @objc func tap(sender:UITapGestureRecognizer) {
        delegate?.tapArticle(sender: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

protocol ArticleSelectDelegate {
    func tapArticle(sender:ArticleSelectButton)
}
