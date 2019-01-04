//
//  NewspaperPublishedView.swift
//  WallPeckers
//
//  Created by Seongchan Kang on 28/12/2018.
//  Copyright © 2018 KimJimin and Company. All rights reserved.
//

import Foundation
import UIKit

final class NewspaperPublishedView:UIView {
    
    let newspaperImageView = UIImageView()
    let publishButton = BottomButton()
    var delegate:PublishDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    func setUI() {
        
        self.addSubview([newspaperImageView, publishButton])
        
        newspaperImageView.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.centerX.equalToSuperview()
            make.height.equalTo(240)
        }
        newspaperImageView.contentMode = .scaleAspectFit
        
        publishButton.snp.makeConstraints { (make) in
            make.top.equalTo(newspaperImageView.snp.bottom).offset(10)
            make.width.equalToSuperview().multipliedBy(0.6)
            make.height.equalTo(55)
            make.centerX.equalToSuperview()
        }
        
        switch Standard.shared.getLocalized() {
            
        case .ENGLISH:
            newspaperImageView.image = UIImage.init(named: "engNewsPaper")
        case .KOREAN:
            newspaperImageView.image = UIImage.init(named: "koreanNewsPaper")
        case .GERMAN:
            newspaperImageView.image = UIImage.init(named: "germanNewsPaper")
        }
        
        publishButton.setTitle("Printing Press".localized, for: .normal)
        publishButton.addTarget(self, action: #selector(moveToNext(sender:)), for: .touchUpInside)
    }
    
    @objc func moveToNext(sender:UIButton) {
        
        delegate?.moveToNext(sender: sender)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

protocol PublishDelegate {
    func moveToNext(sender:UIButton)
}

