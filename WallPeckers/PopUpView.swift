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

var TIMERTIME:Int?


class BasePopUpView:UIView {
    
    let baseView = UIView()
    let popupView = UIView()
    var popUpViewHeight:CGFloat = 340
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview([baseView, popupView])
        
        baseView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        baseView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        popupView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.leading.equalTo(40)
            make.height.equalTo(popUpViewHeight)
        }
        popupView.backgroundColor = .white

    }
    
    func setPopUpViewHeight(_ height:CGFloat) {
        popUpViewHeight = height
        popupView.snp.remakeConstraints { (make) in
            make.center.equalToSuperview()
            make.leading.equalTo(40)
            make.height.equalTo(popUpViewHeight)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}


class ArticleSubmitView:BasePopUpView {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        
    }
    
    private func setUI() {
        
        popupView.snp.remakeConstraints { (make) in
            make.top.equalTo(60)
            make.leading.equalTo(30)
            make.height.equalTo(450)
            make.centerX.equalToSuperview()
        }
        popupView.backgroundColor = .sunnyYellow
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

class SelectPopUpView:BasePopUpView {
    

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
        
        popupView.addSubview([titleView, buttonView, bottomView])
        
        titleView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.leading.equalTo(0)
            make.centerX.equalToSuperview()
            make.height.equalTo(70)
        }
        titleView.backgroundColor = .white
        
        titleView.addSubview(titleLb)
        
        titleLb.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(20)
            make.leading.equalTo(30)
            make.height.equalTo(50)
        }
        
        titleLb.backgroundColor = .black
        
        bottomView.snp.makeConstraints { (make) in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(80)
        }
        
        bottomView.addSubview(confirmBtn)
        
        confirmBtn.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
        buttonView.snp.makeConstraints { (make) in
            make.top.equalTo(titleView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(60)
            make.bottom.equalTo(bottomView.snp.top).offset(-10)
        }
        buttonView.separatorColor = .black
        buttonView.separatorHeight = 2
        buttonView.separatorInset = .init(top: 0, left: 20, bottom: 0, right: 20)
        
        confirmBtn.addTarget(self, action: #selector(bottomBtnTouched(sender:)), for: .touchUpInside)
        
    }
    
    func setButton(selectedButton:[String], bottomBtn:String) {
        
        confirmBtn.setAttributedTitle(bottomBtn.makeAttrString(font: .NotoSans(.medium, size: 20), color: .white), for: .normal)

        
        buttonView.snp.updateConstraints { (make) in
            make.height.equalTo(selectedButton.count * 60)
        }
        for i in 0...selectedButton.count - 1 {
            
            let button = UIButton()
            
            button.setAttributedTitle(selectedButton[i].makeAttrString(font: .NotoSans(.medium, size: 18), color: .black), for: .normal)
            button.setAttributedTitle(selectedButton[i].makeAttrString(font: .NotoSans(.medium, size: 18), color: .white), for: .selected)

//            button.setTitle(, for: .normal)
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
            let a = i.subviews[0] as! UIButton
            a.isSelected = false
        }
    }
    
    @objc func selectBtnTouched(sender:UIButton) {
        clear()
        sender.isSelected = !(sender.isSelected)
        
        sender.backgroundColor = .black
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

class AlertPopUpView:BasePopUpView {
 
    let timeLb = UILabel()
    let descLb = UILabel()
    let bottomButton = BottomButton()
    var delegate:AlerPopupViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    func setUI() {
        
        self.setPopUpViewHeight(250)
        popupView.addSubview([timeLb, descLb, bottomButton])
        
        timeLb.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
        }
        descLb.snp.makeConstraints { (make) in
//            make.top.equalTo(timeLb.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-10)
            make.leading.equalTo(32)
        }
        bottomButton.snp.makeConstraints { (make) in
//            make.top.equalTo(descLb.snp.bottom).offset(10)
            make.width.equalTo(200)
            make.height.equalTo(43)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-24)
        }
        bottomButton.addTarget(self, action: #selector(tapButton(sender:)), for: .touchUpInside)
    }
    
    @objc func tapButton(sender:AlertPopUpView) {
//        self.removeFromSuperview()
        delegate?.tapBottomButton(sender: self)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

protocol AlerPopupViewDelegate {
    
    func tapBottomButton(sender:AlertPopUpView)
}


struct PopUp {
    
    static func callCluePopUp(clueType:String, tag:Int, vc:UIViewController) {
        
        let popupView = CluePopUpView()
        
//        UIWindow().window?.addSubview(popupView)
        
        
        if let _parent = vc.parent {
            _parent.view.addSubview(popupView)
        }else{
            vc.view.addSubview(popupView)

        }
        
//        if let vc.parent?.view.addSubview(popupView)
    
        popupView.delegate = vc as? CluePopUpViewDelegate
        popupView.tag = tag
        popupView.titleLb.attributedText = clueType.makeAttrString(font: .NotoSans(.medium, size: 20), color: .black)
        popupView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        
    }
    
    static func callAlert(time:String, desc:String, vc:UIViewController, tag:Int) {
        
        let popUpView = AlertPopUpView()
        
        vc.view.addSubview(popUpView)
        popUpView.timeLb.setNotoText(time, size: 12, textAlignment: .center)
        popUpView.descLb.setNotoText(desc, size: 12, textAlignment: .center)
        popUpView.delegate = vc as? AlerPopupViewDelegate
        popUpView.tag = tag
        
        popUpView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
    }
    
    static func call(mainTitle:String, selectButtonTitles:[String], bottomButtonTitle:String, bottomButtonType:Int,
                     _ vc:UIViewController) {
        
        let popUpView = SelectPopUpView()
        
        vc.view.addSubview(popUpView)
        popUpView.titleLb.setNotoText(mainTitle, color: .white, size: 20, textAlignment: .center)
        popUpView.delegate = vc as? SelectPopupDelegate
        
        
        popUpView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        popUpView.setButton(selectedButton: selectButtonTitles, bottomBtn: bottomButtonTitle)
        popUpView.bottomButtonType(bottomButtonType)
        popUpView.popupView.setBorder(color: .black, width: 5)
        
    }
}
