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
        print(self.parent?.children)
        if let pvc = self.parent as? TestViewController {
            delegate?.moveToNext(sender: "hi", idx: 0)
//            pvc.horizontalView.scrollView.scrollRectToVisible(CGRect.init(x: 375, y: 0, width: 100, height: 100), animated: true)

        }
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

protocol TestContainerViewDelegate {
    
    func moveToNext(sender:Any, idx:Int)
    
}
