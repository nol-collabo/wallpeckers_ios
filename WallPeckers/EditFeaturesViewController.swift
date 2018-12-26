//
//  EditFeaturesViewController.swift
//  WallPeckers
//
//  Created by Seongchan Kang on 26/12/2018.
//  Copyright © 2018 KimJimin and Company. All rights reserved.
//

import UIKit

class EditFeaturesViewController: UIViewController {

    let backButton = BottomButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        
        // Do any additional setup after loading the view.
    }
    
    func setUI() {
        self.view.addSubview(backButton)
        
        backButton.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.height.equalTo(100)
        }
        
        backButton.addTarget(self, action: #selector(moveBack(sender:)), for: .touchUpInside)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @objc func moveBack(sender:UIButton) {
        
        if let vc = self.navigationController?.viewControllers.filter({$0 is PublishViewController}).first as? PublishViewController {
            
            vc.delegate = self
            
            self.navigationController?.popToViewController(vc, animated: true)
            
        }
        
    }

}

extension EditFeaturesViewController:EditHeadlineProtocol {
    var headlines: [Int]? {
        get {
            return [1,2,5] // 수정된 헤드라인 보여주면됨
        }
    }
    
    
}
