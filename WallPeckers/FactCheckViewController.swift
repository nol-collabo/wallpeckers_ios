//
//  FactCheckViewController.swift
//  WallPeckers
//
//  Created by Kang Seongchan on 13/12/2018.
//  Copyright © 2018 KimJimin and Company. All rights reserved.
//

import UIKit
import Realm
import RealmSwift
import AloeStackView

class FactCheckViewController: GameTransitionBaseViewController {

    let aStackView = AloeStackView()
    var checkData:[FactCheck]?
    var article:Article?
    let submitButton = BottomButton()
    let backButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let _data = checkData {
            print(_data)
            setStack()
        }
    }
    
    func setUI() {
        
        type = GameViewType.factCheck
        
        self.view.addSubview(aStackView)
        
        aStackView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeArea.top).offset(60)
            make.bottom.equalTo(view.safeArea.bottom).offset(-30)
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            
        }
        
        self.view.backgroundColor = .basicBackground
        
        backButton.setImage(UIImage.init(named: "backButton"), for: .normal)
        submitButton.setTitle("SUBMIT", for: .normal)
        backButton.addTarget(self, action: #selector(touchBackButton(sender:)), for: .touchUpInside)
        submitButton.addTarget(self, action: #selector(touchSubmitButton(sender:)), for: UIControl.Event.touchUpInside)
    }
    
    func setStack() {
        aStackView.backgroundColor = .basicBackground
        
        let articleView = ArticleView()
        articleView.forFactCheck()
        
        articleView.setData(article: article!, point: "300")
        
        aStackView.addRow(articleView)
        
        aStackView.addRow(submitButton)
        submitButton.snp.makeConstraints { (make) in
            make.width.equalTo(200)
            make.height.equalTo(50)
            make.center.equalToSuperview()
        }
        aStackView.addRow(backButton)
        
    }
    
    @objc func touchSubmitButton(sender:UIButton) {
        
    }
    
    @objc func touchBackButton(sender:UIButton) {
        sender.isUserInteractionEnabled = false
        
        guard let vc = self.findBeforeVc(type: .clue) else {return}
        
        delegate?.moveTo(fromVc: self, toVc: vc, sendData: nil, direction: .backward)
        
        sender.isUserInteractionEnabled = true
    }
    

    func setData(_ data:[FactCheck], article:Article) {
        
        self.checkData = data
        self.article = article
    }
}

class BubbleView:UIView {
    
    
}
