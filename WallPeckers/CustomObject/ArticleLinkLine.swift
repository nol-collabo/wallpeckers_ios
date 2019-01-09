//
//  ArticleLinkLine.swift
//  WallPeckers
//
//  Created by Seongchan Kang on 28/12/2018.
//  Copyright © 2018 KimJimin and Company. All rights reserved.
//

import Foundation
import UIKit

final class ArticleLinkLine:UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var leftTag:Int = 0
    var rightTag:Int = 0
    
    
    func setLine(color:LineColor, leftButton:ArticleSelectButton, rightButton:ArticleSelectButton, vc:UIViewController) {
                
        vc.view.addSubview(self)
        
        leftTag = leftButton.tag
        rightTag = rightButton.tag
        
        self.tag = tag
        
        switch color {
            
        case .BLUE:
            self.backgroundColor = UIColor.niceBlue
            leftButton.setBorder(color: .niceBlue, width: 5.5)
            rightButton.setBorder(color: .niceBlue, width: 5.5)
        case .GREEN:
            self.backgroundColor = .darkGrassGreen
            leftButton.setBorder(color: .darkGrassGreen, width: 5.5)
            rightButton.setBorder(color: .darkGrassGreen, width: 5.5)
        case .ORANGE:
            self.backgroundColor = .tangerine
            leftButton.setBorder(color: .tangerine, width: 5.5)
            rightButton.setBorder(color: .tangerine, width: 5.5)
        case .RED:
            self.backgroundColor = .scarlet
            leftButton.setBorder(color: .scarlet, width: 5.5)
            rightButton.setBorder(color: .scarlet, width: 5.5)
        }
        
        self.snp.makeConstraints { (make) in
            
            
            if leftButton.tag - rightButton.tag == -1 {
                make.centerY.equalTo(leftButton.snp.centerY)
                make.height.equalTo(10)
                make.leading.equalTo(leftButton.snp.trailing)
                make.trailing.equalTo(rightButton.snp.leading)
            }else{
                make.centerX.equalTo(leftButton.snp.centerX)
                make.width.equalTo(10)
                make.top.equalTo(leftButton.snp.bottom)
                make.bottom.equalTo(rightButton.snp.top)
            }
            
        }
        
        
        
    }
    
}
