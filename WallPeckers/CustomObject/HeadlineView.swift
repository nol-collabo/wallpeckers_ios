//
//  HeadlineView.swift
//  WallPeckers
//
//  Created by Seongchan Kang on 28/12/2018.
//  Copyright © 2018 KimJimin and Company. All rights reserved.
//

import Foundation
import UIKit

class HeadlineView:UIView {
    
    let titleLb = UILabel()
    let underLine = UIView()
    let thumnailLb = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    private func setUI(){
        
        self.setBorder(color: .black, width: 1.5)
        
        self.addSubview([titleLb, underLine, thumnailLb])
        
        titleLb.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(10)
            make.height.equalTo(20)
        }
        underLine.snp.makeConstraints { (make) in
            make.top.equalTo(titleLb.snp.bottom).offset(3)
            make.leading.equalTo(7)
            make.centerX.equalToSuperview()
            make.height.equalTo(2)
        }
        underLine.backgroundColor = .black
        
        thumnailLb.snp.makeConstraints { (make) in
            make.top.equalTo(underLine.snp.bottom).offset(5)
            make.leading.equalTo(20)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-10)
        }
        
        thumnailLb.numberOfLines = 0
        
    }
    
    func setData(header:String, thumnail:String, isHeadline:Bool = false) {
        
        self.titleLb.attributedText = header.makeAttrString(font: .NotoSans(.bold, size: 20), color: .black)
        self.thumnailLb.attributedText = thumnail.makeAttrString(font: .NotoSans(.bold, size: isHeadline ? 22 : 18), color: .black)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

