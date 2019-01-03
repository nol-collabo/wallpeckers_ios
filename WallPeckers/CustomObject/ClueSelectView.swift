//
//  ClueSelectView.swift
//  WallPeckers
//
//  Created by Seongchan Kang on 28/12/2018.
//  Copyright © 2018 KimJimin and Company. All rights reserved.
//

import Foundation
import UIKit

final class ClueSelectView:UIView {
    
    let clueButton = UIButton()
    let clueLb = UILabel()
    let infoLb = UILabel()
    var delegate:ClueSelectDelegate?
    var clue:Clue?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    func setData(five:Five_W_One_Hs, clue:Clue) {
        
        self.clue = clue
        clueButton.setAttributedTitle("\(clue.type!.localized)".makeAttrString(font: .NotoSans(.bold, size: 20), color: .black), for: .normal)
        
        if !five.given {
            clueLb.text = ""
            infoLb.isHidden = false
            clueButton.backgroundColor = .white
        }else {
            clueButton.backgroundColor = .basicBackground
            clueLb.text = clue.desc
            clueButton.isUserInteractionEnabled = false
            infoLb.isHidden = true
        }
        
        
    }
    
    func indicatedWhenBeforeChecked(_ fact:FactCheck) {
        
        clueLb.text = RealmClue.shared.getLocalClue(id: fact.selectedClue, language: Standard.shared.getLocalized())?.desc
        clueButton.backgroundColor = .sunnyYellow
    }
    
    @objc func callCodePopUp(sender:Clue, tag:Int) {
        
        //        print(sender.clueButton.currentTitle)
        delegate?.touchButton(sender: clue!, tag:self.tag)
        
    }
    
    private func setUI() {
        
        self.addSubview([clueButton, clueLb, infoLb])
        
        clueButton.snp.makeConstraints { (make) in
            make.top.equalTo(4)
            make.leading.equalTo(20)
            make.width.equalTo(100)
            make.height.equalTo(34)
        }
        
        clueButton.backgroundColor = .white
        clueButton.setBorder(color: .black, width: 1)
        clueButton.layer.shadowColor = UIColor.black.cgColor
        clueButton.layer.shadowOpacity = 1
        clueButton.layer.shadowRadius = 5
        
        infoLb.snp.makeConstraints { (make) in
            make.leading.equalTo(clueButton.snp.trailing).offset(10)
            make.centerY.equalTo(clueButton.snp.centerY)
            make.trailing.equalTo(-2)
        }
        clueLb.snp.makeConstraints { (make) in
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.top.equalTo(clueButton.snp.bottom).offset(10)
            make.bottom.equalTo(-10)
        }
        clueButton.addTarget(self, action: #selector(callCodePopUp(sender:tag:)), for: .touchUpInside)
        clueLb.numberOfLines = 0
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

protocol ClueSelectDelegate {
    func touchButton(sender:Clue, tag:Int)
}
