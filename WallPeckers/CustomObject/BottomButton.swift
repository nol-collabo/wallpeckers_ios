//
//  BottomButton.swift
//  WallPeckers
//
//  Created by Seongchan Kang on 28/12/2018.
//  Copyright © 2018 KimJimin and Company. All rights reserved.
//

import Foundation
import UIKit

class BottomButton:UIButton {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .black
        self.titleLabel?.font = UIFont.NotoSans(.bold, size: 18)
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        self.titleLabel?.textColor = .white
        if self.isEnabled {
            self.backgroundColor = .black
            
        }else{
            self.backgroundColor = .red
        }
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
