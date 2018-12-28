//
//  HashTagGraphView.swift
//  WallPeckers
//
//  Created by Seongchan Kang on 28/12/2018.
//  Copyright © 2018 KimJimin and Company. All rights reserved.
//

import Foundation
import UIKit


final class HashTagGraphView:UIView {
    
    let titleLb = UILabel()
    let underLine1 = UIView()
    let firstView = GraphView()
    let secondView = GraphView()
    let thirdView = GraphView()
    let fourthView = GraphView()
    let fifthView = GraphView()
    let underLine2 = UIView()
    let hashTitleLb1 = UILabel()
    let hashTitleLb2 = UILabel()
    let hashTitleLb3 = UILabel()
    let hashTitleLb4 = UILabel()
    let hashTitleLb5 = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    func setUI() {
        
        firstView.tag = 0
        secondView.tag = 1
        thirdView.tag = 2
        fourthView.tag = 3
        fifthView.tag = 4
        
        self.setBorder(color: .black, width: 1.5)
        self.addSubview([titleLb, underLine1, underLine2, firstView, secondView, thirdView, fourthView, fifthView, hashTitleLb1, hashTitleLb2, hashTitleLb3, hashTitleLb4, hashTitleLb5])
        
        titleLb.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(20)
        }
        titleLb.attributedText = "HASHTAG".localized.makeAttrString(font: .NotoSans(.bold, size: 18), color: .black)
        
        underLine1.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.leading.equalTo(5)
            make.top.equalTo(titleLb.snp.bottom).offset(10)
            make.height.equalTo(1.5)
        }
        
        underLine2.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(2)
            make.bottom.equalTo(-40)
        }
        underLine2.backgroundColor = .black
        underLine1.backgroundColor = .black
        hashTitleLb1.setNotoText("hash1".localized, size: 12, textAlignment: .center)
        hashTitleLb2.setNotoText("hash2".localized, size: 12, textAlignment: .center)
        hashTitleLb3.setNotoText("hash3".localized, size: 12, textAlignment: .center)
        hashTitleLb4.setNotoText("hash4".localized, size: 12, textAlignment: .center)
        hashTitleLb5.setNotoText("hash5".localized, size: 12, textAlignment: .center)
        
        
        firstView.snp.makeConstraints { (make) in
            
            make.leading.equalTo(underLine2.snp.leading)
            make.bottom.equalTo(underLine2.snp.top).offset(1)
            make.width.equalTo(underLine2.snp.width).multipliedBy(0.2)
            make.height.equalTo(180)
            make.top.equalTo(underLine1.snp.bottom).offset(20)
        }
        
        hashTitleLb1.snp.makeConstraints { (make) in
            make.centerX.equalTo(firstView.snp.centerX)
            make.top.equalTo(firstView.snp.bottom).offset(10)
        }
        
        secondView.snp.makeConstraints { (make) in
            make.leading.equalTo(firstView.snp.trailing)
            make.bottom.equalTo(underLine2.snp.top).offset(1)
            make.width.equalTo(underLine2.snp.width).multipliedBy(0.2)
            make.height.equalTo(180)
            make.top.equalTo(underLine1.snp.bottom).offset(20)
            
        }
        
        hashTitleLb2.snp.makeConstraints { (make) in
            make.centerX.equalTo(secondView.snp.centerX)
            make.top.equalTo(firstView.snp.bottom).offset(10)
        }
        thirdView.snp.makeConstraints { (make) in
            make.leading.equalTo(secondView.snp.trailing)
            make.bottom.equalTo(underLine2.snp.top).offset(1)
            make.width.equalTo(underLine2.snp.width).multipliedBy(0.2)
            make.height.equalTo(180)
            make.top.equalTo(underLine1.snp.bottom).offset(20)
            
        }
        
        hashTitleLb3.snp.makeConstraints { (make) in
            make.centerX.equalTo(thirdView.snp.centerX)
            make.top.equalTo(firstView.snp.bottom).offset(10)
        }
        fourthView.snp.makeConstraints { (make) in
            make.leading.equalTo(thirdView.snp.trailing)
            make.bottom.equalTo(underLine2.snp.top).offset(1)
            make.width.equalTo(underLine2.snp.width).multipliedBy(0.2)
            make.height.equalTo(180)
            make.top.equalTo(underLine1.snp.bottom).offset(20)
            
        }
        
        hashTitleLb4.snp.makeConstraints { (make) in
            make.centerX.equalTo(fourthView.snp.centerX)
            make.top.equalTo(firstView.snp.bottom).offset(10)
        }
        fifthView.snp.makeConstraints { (make) in
            make.top.equalTo(underLine1.snp.bottom).offset(20)
            make.leading.equalTo(fourthView.snp.trailing)
            make.bottom.equalTo(underLine2.snp.top).offset(1)
            make.width.equalTo(underLine2.snp.width).multipliedBy(0.2)
            make.height.equalTo(180)
        }
        
        hashTitleLb5.snp.makeConstraints { (make) in
            make.centerX.equalTo(fifthView.snp.centerX)
            make.top.equalTo(firstView.snp.bottom).offset(10)
        }
        
    }
    
    func initAnimation() {
        for i in [firstView, secondView, thirdView, fourthView, fifthView] {
            
            i.graphV.snp.updateConstraints { (make) in
                make.height.equalTo(0)
            }
            self.layoutIfNeeded()
        }
    }
    
    func startAnimation(heights:[Int]) {
        
        
        
        UIView.animate(withDuration: 5) {
            self.firstView.graphV.snp.updateConstraints { (make) in
                make.height.equalTo(heights[0])
            }
            
            self.secondView.graphV.snp.updateConstraints { (make) in
                make.height.equalTo(heights[1])
            }
            
            self.thirdView.graphV.snp.updateConstraints { (make) in
                make.height.equalTo(heights[2])
            }
            
            self.fourthView.graphV.snp.updateConstraints { (make) in
                make.height.equalTo(heights[3])
            }
            
            self.fifthView.graphV.snp.updateConstraints { (make) in
                make.height.equalTo(heights[4])
            }
            
            self.layoutIfNeeded()
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
