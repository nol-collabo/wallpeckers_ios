//
//  CompleteArticleViewController.swift
//  WallPeckers
//
//  Created by Seongchan Kang on 17/12/2018.
//  Copyright © 2018 KimJimin and Company. All rights reserved.
//

import UIKit
import AloeStackView

class CompleteArticleViewController: GameTransitionBaseViewController {

    var article:Article?
    var hashTag:Int?
    let aStackView = AloeStackView()
    let okButton = BottomButton()
    let titleLb = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        
        if let _hash = hashTag, let _article = article {
            print(_hash, "_HASH")
            print(_article)
        }
        
        // Do any additional setup after loading the view.
    }
    
    func setUI() {
        
        self.view.backgroundColor = .basicBackground
        self.view.addSubview(aStackView)
        aStackView.backgroundColor = .basicBackground
        
        aStackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        titleLb.text = "COMPLETED ARTICLE"
        
        aStackView.addRow(titleLb)
        aStackView.addRow(okButton)
        okButton.addTarget(self, action: #selector(moveToBack(sender:)), for: .touchUpInside)
    
    }
    
    @objc func moveToBack(sender:UIButton) {
        
    
        guard let vc = self.findBeforeVc(type: .topic) else {return}
        
        delegate?.moveTo(fromVc: self, toVc: vc, sendData: nil, direction: .backward)
    }
    
    
    
    func setData(article:Article, hashTag:Int) {
        
        self.article = article
        self.hashTag = hashTag
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
