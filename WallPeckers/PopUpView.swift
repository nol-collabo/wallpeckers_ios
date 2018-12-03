//
//  PopUpView.swift
//  WallPeckers
//
//  Created by Seongchan Kang on 26/11/2018.
//  Copyright © 2018 KimJimin and Company. All rights reserved.
//

import Foundation
import UIKit
import AloeStackView

class SelectPopUpView:UIView {
    
    let baseView = UIView()
    let popupView = UIView()
    let titleView = UIView()
    let titleLb = UILabel()
    let buttonView = AloeStackView()
    let bottomView = UIView()
    let confirmBtn = UIButton()
    var delegate:SelectPopupDelegate?
     
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    private func setUI() {
        
        self.addSubview([baseView, popupView])
        
        baseView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        baseView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        popupView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.leading.equalTo(40)
            make.height.equalTo(300)
//            make.bottom.equalToSuperview().offset(-50)
        }
        popupView.addSubview([titleView, buttonView, bottomView])
        
        titleView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.leading.equalTo(0)
            make.centerX.equalToSuperview()
            make.height.equalTo(70)
        }
        titleView.backgroundColor = .white
        popupView.backgroundColor = .white
        
        titleView.addSubview(titleLb)
        
        titleLb.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.leading.equalTo(30)
            make.height.equalTo(50)
        }
        
        titleLb.backgroundColor = .black
        
        bottomView.snp.makeConstraints { (make) in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        
        bottomView.addSubview(confirmBtn)
        
        confirmBtn.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(150)
            make.height.equalTo(30)
        }
        buttonView.snp.makeConstraints { (make) in
            make.top.equalTo(titleView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(60)
            make.bottom.equalTo(confirmBtn.snp.top).offset(-10)
        }
        
        confirmBtn.addTarget(self, action: #selector(bottomBtnTouched(sender:)), for: .touchUpInside)
        
    }
    
    func setButton(selectedButton:[String], bottomBtn:String) {
        
        confirmBtn.setTitle(bottomBtn, for: .normal)
        confirmBtn.setTitleColor(.black, for: .normal)
        
        buttonView.snp.updateConstraints { (make) in
            make.height.equalTo(selectedButton.count * 60)
        }
        for i in 0...selectedButton.count - 1 {
            
            let button = UIButton()
            
            button.setTitle(selectedButton[i], for: .normal)
            button.tag = i
//            button.setBackgroundColor(color: .gray, forState: .selected)
            button.setTitleColor(.black, for: .normal)
            button.addTarget(self, action: #selector(selectBtnTouched(sender:)), for: .touchUpInside)
            buttonView.addRow(button)

        }
        
    }
    
    @objc func bottomBtnTouched(sender:UIButton) {
        
        delegate?.bottomButtonTouched(sender: sender)

    }
    
    func clear() {
        
        for i in buttonView.subviews[0].subviews {
            i.subviews[0].backgroundColor = .white
        }
        
//        for i in buttonView.subviews.filter({
//
//            $0 is UIButton
//        }) {
//            i.backgroundColor = .white
//        }
    }
    
    @objc func selectBtnTouched(sender:UIButton) {
        clear()
        sender.isSelected = !(sender.isSelected)
        
        sender.backgroundColor = .gray
        delegate?.selectButtonTouched(tag: sender.tag)
        
        
    }
    
    func bottomButtonType(_ type:Int) {
        if type == 0 {
            confirmBtn.backgroundColor = .black
            confirmBtn.setTitleColor(.white, for: .normal)
        }else if type == 1 {
            confirmBtn.backgroundColor = .white
            confirmBtn.setTitleColor(.black, for: .normal)
            confirmBtn.setBorder(color: .black, width: 1, cornerRadius: 3)
        }else{
            
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

protocol SelectPopupDelegate {
    func bottomButtonTouched(sender:UIButton)
    func selectButtonTouched(tag:Int)
    
}


struct PopUp {
    
    static func call(mainTitle:String, selectButtonTitles:[String], bottomButtonTitle:String, bottomButtonType:Int,
                     _ vc:UIViewController) {
        
        let popUpView = SelectPopUpView()
        
        vc.view.addSubview(popUpView)
        popUpView.titleLb.setText(mainTitle, color: .white, size: 20, textAlignment: .center)
        popUpView.delegate = vc as? SelectPopupDelegate
        
        
        popUpView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        popUpView.setButton(selectedButton: selectButtonTitles, bottomBtn: bottomButtonTitle)
        popUpView.bottomButtonType(bottomButtonType)
        popUpView.popupView.setBorder(color: .black, width: 5)
        
    }
}
