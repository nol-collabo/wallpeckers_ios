//
//  TopicButton.swift
//  WallPeckers
//
//  Created by Seongchan Kang on 12/12/2018.
//  Copyright © 2018 KimJimin and Company. All rights reserved.
//

import Foundation
import SnapKit

class TopicButton:UIView {
    
    let selectGesture:UITapGestureRecognizer = UITapGestureRecognizer()
    let titleImageView = UIImageView()
    let titleLb = UILabel()
    var delegate:TopicButtonDelegate?
    let starImageView = UIImageView()
    let starCountLb = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    private func setUI() {
        
        self.addGestureRecognizer(selectGesture)
        self.isUserInteractionEnabled = true
        self.backgroundColor = .white
        selectGesture.addTarget(self, action: #selector(tap))
        self.setBorder(color: .black, width: 1.5, cornerRadius: 0)
        self.addSubview([titleImageView, titleLb, starImageView, starCountLb])
        
        titleImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-10)
        }
        titleLb.snp.makeConstraints { (make) in
            make.leading.equalTo(3)
            make.trailing.equalTo(-3)
            make.height.equalTo(50)
            make.bottom.equalTo(-3)
            
        }
        
        starImageView.snp.makeConstraints { (make) in
            make.top.equalTo(5)
            make.leading.equalTo(15)
            make.width.height.equalTo(20)
        }
        starImageView.image = UIImage.init(named: "YellowStar")
        starCountLb.snp.makeConstraints { (make) in
            make.centerY.equalTo(starImageView.snp.centerY)
            make.leading.equalTo(starImageView.snp.trailing).offset(10)
            make.height.equalTo(20)
            make.trailing.equalTo(-3)
        }
        
        starImageView.isHidden = true
        starCountLb.isHidden = true
//        starCountLb.text = "asd"
        
        titleLb.numberOfLines = 0
    }
    
    func setStar(count:Int) {
        
        if count > 0 {
            starImageView.isHidden = false
            starCountLb.isHidden = false
            starCountLb.attributedText = "x \(count)".makeAttrString(font: .NotoSans(.regular, size: 15), color: .black)
        }

    }
    
    @objc func tap() {
        delegate?.tap(tag: self.tag)
    }
    
    func setData(title:String, image:UIImage, tag:Int) {
        
        self.titleLb.setNotoText(title, size: 13, textAlignment: .center)
        self.titleImageView.image = image
        self.tag = tag
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

protocol TopicButtonDelegate {
    
    func tap(tag:Int)
}

