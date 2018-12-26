//
//  EditHeadlineViewController.swift
//  WallPeckers
//
//  Created by Seongchan Kang on 26/12/2018.
//  Copyright © 2018 KimJimin and Company. All rights reserved.
//

import UIKit

class EditHeadlineViewController: UIViewController {

    let backBtn = BottomButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        self.view.addSubview(backBtn)
        
        backBtn.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.height.equalTo(190)
        }
        backBtn.addTarget(self, action: #selector(moveBack(sender:)), for: .touchUpInside)
        
        // Do any additional setup after loading the view.
    }
    
    @objc func moveBack(sender:UIButton) {
        

        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditFeaturesViewController") as? EditFeaturesViewController else {return}
        

        self.navigationController?.pushViewController(vc, animated: true)
        
//        if let vc = self.navigationController?.viewControllers.filter({$0 is PublishViewController}).first as? PublishViewController {
//
////            vc.delegate = self
//
//            self.navigationController?.popToViewController(vc, animated: true)
//
//        }
        
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

