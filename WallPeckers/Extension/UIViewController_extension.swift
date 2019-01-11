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
    
    func setStatusbarColor(_ color:UIColor) {
        
        if let statusBar = UIApplication.shared.value(forKey: "statusBar") as? UIView {
            statusBar.backgroundColor = color
        }
        
        
    }
    
    func findTimerView() -> NavigationCustomView {
        if let vv = self.view.subviews.filter({
            
            $0 is GameNavigationBar
            
        }).first as? GameNavigationBar {
            if let _timerView = vv.subviews.filter({
                
                $0.tag == 99
                
            }).first as? NavigationCustomView {
//                self.timerView = _timerView
                
                return _timerView
            }
        }else{
            return NavigationCustomView()
        }
        return NavigationCustomView()

    }
    
    
    func  findScoreView() -> NavigationCustomView {
        
        if let vv = self.view.subviews.filter({
            
            $0 is GameNavigationBar
            
        }).first as? GameNavigationBar {
            if let _timerView = vv.subviews.filter({
                
                $0.tag == 77
                
            }).first as? NavigationCustomView {
                //                self.timerView = _timerView
                
                return _timerView
            }
        }else{
            return NavigationCustomView()
        }
        return NavigationCustomView()
        
    }
    
    func setCustomNavigationBar() {
        
        let navBar = GameNavigationBar()

        navBar.delegate = self as? GameNavigationBarDelegate
        Standard.shared.delegate = self as? GamePlayTimeDelegate

        self.navigationController?.isNavigationBarHidden = true
    
        self.view.addSubview(navBar)
        navBar.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeArea.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        
    }
    
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
