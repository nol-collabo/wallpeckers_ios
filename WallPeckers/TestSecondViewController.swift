//
//  TestSecondViewController.swift
//  WallPeckers
//
//  Created by Seongchan Kang on 12/12/2018.
//  Copyright © 2018 KimJimin and Company. All rights reserved.
//

import UIKit

class TestSecondViewController: UIViewController {

    let lbl = UILabel()
    let button = BottomButton()
    var delegate:TestContainerViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview([lbl, button])
        
        lbl.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.height.equalTo(100)
        }
        lbl.textColor = .blue
        lbl.text = "GOGOGO"
        button.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.width.height.equalTo(100)

        }
        button.addTarget(self, action: #selector(moveBack), for: .touchUpInside)
    
        

        // Do any additional setup after loading the view.
    }
    
    @objc func moveBack() {
        
        if let bvc = self.parent?.children.filter({
            $0 is TestFirstViewController
        }).first {
            delegate?.moveToBack!(sender: "Back", currentVc: self, nextVc: bvc)
        }
        
//        delegate?.moveToNext(sender: "BACK", idx: 2)
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
