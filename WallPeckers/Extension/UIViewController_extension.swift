//
//  UIViewController_extension.swift
//  WallPeckers
//
//  Created by Seongchan Kang on 30/11/2018.
//  Copyright © 2018 KimJimin and Company. All rights reserved.
//

import Foundation
import SnapKit
import UIKit

extension UIViewController {
    
    func allButtonUserIteraction(_ bool:Bool) {
        
        let btns = self.view.subviews.filter({
            
            $0 is UIButton
        }) as? [UIButton]
        
    
       _ = btns?.map({
        
        $0.isUserInteractionEnabled = bool
        
       })
        
        
        
        
    }
    
    var findPopUpView:SelectPopUpView? {
        get {
            if let pView = self.view.subviews.filter({
                
                $0 is SelectPopUpView
                
            }).first as? SelectPopUpView {
                
                return pView
            }else{
                return nil
            }
        }
    }
    
    func removePopUpView() {
        
        if let pView = self.view.subviews.filter({
            
            $0 is SelectPopUpView
            
        }).first as? SelectPopUpView {
            pView.removeFromSuperview()
        }
        
    }
}
