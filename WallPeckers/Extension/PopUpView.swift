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
    let buttonView = AloeStackView()
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
//            make.bottom.equalToSuperview().offset(-50)
        }
        popupView.addSubview([titleView, buttonView, confirmBtn])
        
        titleView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        titleView.backgroundColor = .blue
        popupView.backgroundColor = .white
        
        confirmBtn.snp.makeConstraints { (make) in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
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
            button.setTitleColor(.black, for: .normal)
            button.addTarget(self, action: #selector(selectBtnTouched(sender:)), for: .touchUpInside)
            buttonView.addRow(button)

        }
        
    }
    
    @objc func bottomBtnTouched(sender:UIButton) {
        
        delegate?.bottomButtonTouched(sender: sender)
    }
    
    @objc func selectBtnTouched(sender:UIButton) {
        
        delegate?.selectButtonTouched(tag: sender.tag)
        
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
    
    static func call(selectButtonTitles:[String], bottomButtonTitle:String, _ vc:UIViewController) {
        
        let popUpView = SelectPopUpView()
        
        vc.view.addSubview(popUpView)
        
        popUpView.delegate = vc as? SelectPopupDelegate
        
        popUpView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        popUpView.setButton(selectedButton: selectButtonTitles, bottomBtn: bottomButtonTitle)
        
        
    }
}
