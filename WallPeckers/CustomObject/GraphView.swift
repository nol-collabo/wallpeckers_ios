//
//  GraphView.swift
//  WallPeckers
//
//  Created by Seongchan Kang on 28/12/2018.
//  Copyright © 2018 KimJimin and Company. All rights reserved.
//

import Foundation
import UIKit

final class GraphView:UIView {
    
    let titleLb = UILabel()
    let percentLb = UILabel()
    let graphV = UIView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    func initData(percent:Int, myTag:Int, top:Bool = false) {
        self.percentLb.font = UIFont.NotoSans(.bold, size: 14)
        self.percentLb.text = "\(percent)"
        self.titleLb.text = ""
        self.titleLb.adjustsFontSizeToFitWidth = true
        self.titleLb.numberOfLines = 0
        self.titleLb.textAlignment = .center
        
        if self.tag == myTag {
            self.titleLb.font = UIFont.NotoSans(.bold, size: 12)
            self.graphV.backgroundColor = .sunnyYellow
            self.titleLb.text = "MYTAG".localized
        }else{
            self.graphV.backgroundColor = .white
        }
        
        if top {
            if self.titleLb.text != "" {
                self.titleLb.font = UIFont.NotoSans(.bold, size: 14)
                self.titleLb.text?.append("\n\("MOST".localized)")
                
            }else{
                self.titleLb.font = UIFont.NotoSans(.bold, size: 14)
                self.titleLb.text?.append("MOST".localized)
                
            }
        }
    }
    
    private func setUI() {
        self.addSubview([titleLb, percentLb, graphV])
        
        graphV.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.7)
            make.centerX.equalToSuperview()
            make.height.equalTo(0)
        }
        graphV.setBorder(color: .black, width: 1.5)
        graphV.backgroundColor = .white
        
        percentLb.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.height.equalTo(20)
            make.bottom.equalTo(graphV.snp.top).offset(-5)
        }
        titleLb.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.height.equalTo(20)
            make.bottom.equalTo(percentLb.snp.top).offset(-5)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}

