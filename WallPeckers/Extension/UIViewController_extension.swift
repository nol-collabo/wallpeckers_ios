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
    
    func setStatusbarColor(_ color:UIColor) { // 스테이터스바 색상 변경
        
        if let statusBar = UIApplication.shared.value(forKey: "statusBar") as? UIView {
            statusBar.backgroundColor = color
        }
        
        
    }
    
    func findTimerView() -> NavigationCustomView { // 상단 타이머 확인
        if let vv = self.view.subviews.filter({
            
            $0 is GameNavigationBar
            
        }).first as? GameNavigationBar {
            if let _timerView = vv.subviews.filter({
                
                $0.tag == 99
                
            }).first as? NavigationCustomView {
                
                return _timerView
            }
        }else{
            return NavigationCustomView()
        }
        return NavigationCustomView()

    }
    
    
    func  findScoreView() -> NavigationCustomView { // 상단 점수 뷰 확인
        
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
    
    func setCustomNavigationBar() { // 상단 네비게이션바 커스텀
        
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
    
    func allButtonUserIteraction(_ bool:Bool) { // 버튼 유저인터랙션
        
        let btns = self.view.subviews.filter({
            
            $0 is UIButton
        }) as? [UIButton]
        
    
       _ = btns?.map({
        
        $0.isUserInteractionEnabled = bool
        
       })
        
        
        
        
    }
    
    var findPopUpView:SelectPopUpView? { // 현재 뷰의 팝업뷰를 찾는 함수
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
    
    func removePopUpView() { // 현재 뷰의 팝업뷰 제거
        
        if let pView = self.view.subviews.filter({
            
            $0 is SelectPopUpView
            
        }).first as? SelectPopUpView {
            pView.removeFromSuperview()
        }
        
    }
}
