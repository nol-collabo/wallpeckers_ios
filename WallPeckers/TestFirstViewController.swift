//
//  TestFirstViewController.swift
//  WallPeckers
//
//  Created by Seongchan Kang on 12/12/2018.
//  Copyright © 2018 KimJimin and Company. All rights reserved.
//

import UIKit

class TestFirstViewController: UIViewController {

    let button = BottomButton()
    var delegate:TestContainerViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(button)
        
        button.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.height.equalTo(100)
        }
        button.addTarget(self, action: #selector(moveToNext), for: .touchUpInside)
        
//        self.vie

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @objc func moveToNext() {
        if let pvc = self.parent as? TestViewController, let nextVc = self.parent?.children.filter({
            
            $0 is TestSecondViewController
        }).first {
            delegate?.moveToNext!(sender: "hi", currentVc: self, nextVc: nextVc)

        }
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application , you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

@objc protocol TestContainerViewDelegate {
    
    @objc optional func moveToNext(sender:Any, currentVc:UIViewController, nextVc:UIViewController)
    @objc optional func moveToBack(sender:Any, currentVc:UIViewController, nextVc:UIViewController)
    
}
