//
//  TestViewController.swift
//  WallPeckers
//
//  Created by Seongchan Kang on 12/12/2018.
//  Copyright © 2018 KimJimin and Company. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {
    
    let horizontalView = BaseHorizontalScrollView()
    let firstVcV = UIView()
    let secondVcV = UIView()
    let thirdVcV = UIView()
    let fvc = UIStoryboard.init(name: "Test", bundle: nil).instantiateViewController(withIdentifier: "TestFirstViewController") as! TestFirstViewController
    let svc = UIStoryboard.init(name: "Test", bundle: nil).instantiateViewController(withIdentifier: "TestSecondViewController") as! TestSecondViewController
    let tvc = UIStoryboard.init(name: "Test", bundle: nil).instantiateViewController(withIdentifier: "TestThirdViewController") as! TestThirdViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()

        horizontalView.setScrollView(vc: self)
        self.setCustomNavigationBar()
        setUI()
        
//        firstVc.viewc
        // Do any additional setup after loading the view.
    }
    
    func setUI() {
        
        horizontalView.contentView.addSubview([firstVcV, secondVcV, thirdVcV])
        
        firstVcV.snp.makeConstraints { (make) in
            make.top.leading.bottom.equalToSuperview()
            make.width.equalTo(DeviceSize.width)
        }
        secondVcV.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(firstVcV.snp.trailing)
            make.width.equalTo(DeviceSize.width)
        }
        thirdVcV.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(secondVcV.snp.trailing)
            make.width.equalTo(DeviceSize.width)
            make.trailing.equalToSuperview()
        }
//        thirdVcV.backgroundColor = .red
        
        
        fvc.view.backgroundColor = .blue
        svc.view.backgroundColor = .red
        tvc.view.backgroundColor = .white
        addChild(fvc)
        addChild(svc)
        addChild(tvc)
        fvc.delegate = self
        svc.delegate = self
        firstVcV.addSubview(fvc.view)
        fvc.view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        secondVcV.addSubview(svc.view)
        svc.view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        thirdVcV.addSubview(tvc.view)
        tvc.view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        horizontalView.scrollView.isScrollEnabled = false
    }
    
}

extension TestViewController:TestContainerViewDelegate {
    func moveToNext(sender: Any, idx: Int) {
        print(sender)
        print(idx)
        
        if idx == 0 {
            svc.lbl.text = "\(sender)"
            horizontalView.scrollView.setContentOffset(CGPoint.init(x: DeviceSize.width, y: horizontalView.scrollView.contentOffset.y), animated: true)
        }else{
            fvc.button.setTitle("Welcome!", for: .normal)
            horizontalView.scrollView.setContentOffset(CGPoint.init(x: 0, y: horizontalView.scrollView.contentOffset.y), animated: true)
        }
    }
    

    
    
}
