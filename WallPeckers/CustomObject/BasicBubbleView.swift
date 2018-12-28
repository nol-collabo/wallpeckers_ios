//
//  BasicBubbleView.swift
//  WallPeckers
//
//  Created by Seongchan Kang on 28/12/2018.
//  Copyright © 2018 KimJimin and Company. All rights reserved.
//

import Foundation
import UIKit
final class BasicBubbleView:UIView {
    
    let bubbleBaseView = UIImageView()
    let clueTypeLb = UILabel()
    let clueDescLb = UILabel()
    var clue:Clue?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    private func setUI() {
        
        self.addSubview([bubbleBaseView])
        
        bubbleBaseView.snp.makeConstraints { (make) in
            make.trailing.equalTo(-20)
            make.height.equalTo(75)
            make.leading.equalTo(DeviceSize.width > 320 ? 66 : 44)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        bubbleBaseView.image = UIImage.init(named: "balloon4")
        bubbleBaseView.contentMode = .scaleAspectFit
        bubbleBaseView.addSubview([clueTypeLb, clueDescLb])
        
        clueTypeLb.snp.makeConstraints { (make) in
            make.leading.equalTo(13)
            make.top.equalTo(DeviceSize.width > 320 ? 10 : 15)
            make.height.equalTo(20)
        }
        clueDescLb.snp.makeConstraints { (make) in
            make.height.equalTo(30)
            make.leading.equalTo(13)
            make.bottom.equalTo(-10)
            make.trailing.equalTo(-20)
        }
        clueDescLb.numberOfLines = 1
        
    }
    
    func setData(clue:Clue, type:FactCorrect) {
        
        self.clue = clue
        clueTypeLb.text = self.clue?.type?.localized
        clueTypeLb.font = UIFont.NotoSans(.bold, size: 16)
        clueDescLb.font = UIFont.NotoSans(.medium, size: 16)
        clueDescLb.text = clue.desc
        self.tag = clue.id
        
        switch type {
            
        case .normal:
            bubbleBaseView.image = UIImage.init(named: "balloon4")
            
        case .correct:
            bubbleBaseView.image = UIImage.init(named: "balloonCorrect")
            clueTypeLb.textColor = .white
            clueDescLb.textColor = .white
            
        case .wrong:
            clueTypeLb.textColor = .white
            clueDescLb.textColor = .white
            bubbleBaseView.image = UIImage.init(named: "balloonFail")
            
        case .empty:
            bubbleBaseView.image = UIImage.init(named: "balloon4")
            
        }
        
    }
    
    func setDataCheck(clue:Clue, type:FactCorrect) {
        
        clueDescLb.text = clue.desc
        self.tag = clue.id
        
        switch type {
            
        case .normal:
            bubbleBaseView.image = UIImage.init(named: "balloon4")
            
        case .correct:
            bubbleBaseView.image = UIImage.init(named: "balloonCorrect")
            clueTypeLb.textColor = .white
            clueDescLb.textColor = .white
            
        case .wrong:
            clueTypeLb.textColor = .white
            clueDescLb.textColor = .white
            bubbleBaseView.image = UIImage.init(named: "balloonFail")
            
        case .empty:
            bubbleBaseView.image = UIImage.init(named: "balloon4")
            
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
