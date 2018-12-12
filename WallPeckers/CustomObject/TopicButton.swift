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
        self.addSubview([titleImageView, titleLb])
        
        titleImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-10)
        }
        titleLb.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(50)
            
        }
        
        titleLb.numberOfLines = 0
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

