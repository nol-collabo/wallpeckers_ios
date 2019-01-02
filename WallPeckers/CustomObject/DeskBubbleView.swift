//
//  DeskBubbleView.swift
//  WallPeckers
//
//  Created by Seongchan Kang on 28/12/2018.
//  Copyright © 2018 KimJimin and Company. All rights reserved.
//

import Foundation
import UIKit

final class DeskBubbleView:UIView {
    
    let bubbleBaseView = UIImageView()
    let clueDescLb = UILabel()
    let profileView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    private func setUI() {
        self.addSubview([profileView, bubbleBaseView, clueDescLb])
        bubbleBaseView.image = UIImage.init(named: "balloon")
        profileView.snp.makeConstraints { (make) in
            make.top.leading.bottom.equalToSuperview()
            make.width.equalTo(63)
            make.height.equalTo(87)
        }
        bubbleBaseView.snp.makeConstraints { (make) in
            make.leading.equalTo(profileView.snp.trailing)
            make.top.equalTo(3)
            make.bottom.equalTo(-3)
            make.trailing.equalTo(-10)
        }
        clueDescLb.snp.makeConstraints { (make) in
            make.leading.equalTo(profileView.snp.trailing).offset(30)
            make.top.equalTo(bubbleBaseView.snp.top).offset(3)
            make.trailing.equalTo(bubbleBaseView.snp.trailing).offset(-20)
            make.bottom.equalTo(-10)
        }
        clueDescLb.numberOfLines = 0
        
    }
    
    func setData(region:String, wrongParts:[String]) {
        
        var sss = "factcheck_deskrecheck".localized
        
        if wrongParts.count == 0 {
            sss = "factcheck_deskperfect".localized
        }else {
            for i in 0...wrongParts.count - 1 {
                
                if i == wrongParts.count - 1 {
                    
                    sss.append("\(wrongParts[i].localized)")
                    
                }else{
                    sss.append("\(wrongParts[i].localized), ")
                }
                
            }
        }
        
        
        clueDescLb.attributedText = sss.makeAttrString(font: .NotoSans(.medium, size: 14), color: .black)
        clueDescLb.numberOfLines = 0
        
        print(wrongParts)
        print("~~~###")
        profileView.image = UIImage.init(named: region == "GERMANY" ? "germanDeskProfile" : "koreanDeskProfile")
    }
    
    func setDataForCompleteArticle(region:String, desc:String) {
        profileView.image = UIImage.init(named: region == "GERMANY" ? "germanDeskProfile" : "koreanDeskProfile")
        bubbleBaseView.image = UIImage.init(named: "blueLeftBallon")
        clueDescLb.attributedText = desc.makeAttrString(font: .NotoSans(.medium, size: 14), color: .white)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
