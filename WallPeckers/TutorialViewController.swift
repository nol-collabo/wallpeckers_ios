//
//  TutorialViewController.swift
//  WallPeckers
//
//  Created by Seongchan Kang on 03/12/2018.
//  Copyright © 2018 KimJimin and Company. All rights reserved.
//

import UIKit


let DeviceSize = UIWindow().bounds.size

class TutorialViewController: UIViewController {

    let horizontalScrollView = BaseHorizontalScrollView()
    let t1View = TutorialView()
    let t2View = TutorialView()
    let t3View = TutorialView()
    let t4View = TutorialView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.view.addSubview(horizontalScrollView)
        
        horizontalScrollView.setScrollView(vc: self)
     
        
        
        horizontalScrollView.contentView.addSubview([t1View, t2View, t3View, t4View])
//        horizontalScrollView.sc
        t1View.snp.makeConstraints { (make) in
            make.height.equalToSuperview()
            make.width.equalTo(DeviceSize.width)
            make.leading.top.equalToSuperview()
        }
        t2View.snp.makeConstraints { (make) in
            make.leading.equalTo(t1View.snp.trailing)
            make.width.equalTo(DeviceSize.width)
            make.height.equalToSuperview()
            make.top.equalToSuperview()
        }
        t3View.snp.makeConstraints { (make) in
            make.leading.equalTo(t2View.snp.trailing)
            make.width.equalTo(DeviceSize.width)
            make.height.equalToSuperview()
            make.top.equalToSuperview()
        }
        t4View.snp.makeConstraints { (make) in
            make.leading.equalTo(t3View.snp.trailing)
            make.width.equalTo(DeviceSize.width)
            make.trailing.equalToSuperview()
            make.height.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        t1View.backgroundColor = .red
        t2View.backgroundColor = .blue
        t3View.backgroundColor = .white
        t4View.backgroundColor = .black
        // Do any additional setup after loading the view.
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

class TutorialView:UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
