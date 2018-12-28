//
//  TutorialViewController.swift
//  WallPeckers
//
//  Created by Seongchan Kang on 03/12/2018.
//  Copyright © 2018 KimJimin and Company. All rights reserved.
//

import UIKit
import SnapKit


let DeviceSize = UIWindow().bounds.size

class TutorialViewController: UIViewController, TutorialViewDelegate {

    private let horizontalScrollView = BaseHorizontalScrollView()
    private let t1View = TutorialView()
    private let t2View = TutorialView()
    private let t3View = TutorialView()
    private let t4View = TutorialView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    
    }
    
    private func setUI() {
        
        horizontalScrollView.setScrollView(vc: self)
        self.view.backgroundColor = .basicBackground
        horizontalScrollView.contentView.addSubview([t1View, t2View, t3View, t4View])
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
        t1View.setData(title: "tutorial1_subtitle".localized, desc: "tutorial1".localized, image: UIImage.init(named: "tutorial1")!)
        t2View.setData(title: "tutorial2_subtitle".localized, desc: "tutorial2".localized, image:  UIImage.init(named: "tutorial2")!)
        t3View.setData(title: "tutorial3_subtitle".localized, desc: "tutorial3".localized, image: UIImage.init(named: "tutorial3")!)
        t4View.setData(title: "tutorial4_subtitle".localized, desc: "tutorial4".localized, image: UIImage.init(named: "tutorial4")!, isLast: true)

        t4View.delegate = self

    }
    
    func touchMove(sender: UIButton) {
        sender.isUserInteractionEnabled = false
        guard let vc = UIStoryboard.init(name: "Game", bundle: nil).instantiateViewController(withIdentifier: "GameNav") as? UINavigationController else {return}
        self.present(vc, animated: true, completion: nil)
    }
}
