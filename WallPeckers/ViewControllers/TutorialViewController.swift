//
//  TutorialViewController.swift
//  WallPeckers
//
//  Created by Seongchan Kang on 03/12/2018.
//  Copyright © 2018 KimJimin and Company. All rights reserved.
//

import UIKit
import SnapKit

let KEYWINDOW = UIApplication.shared.keyWindow
let DeviceSize = UIWindow().bounds.size

class TutorialViewController: UIViewController, TutorialViewDelegate, UIScrollViewDelegate {

    private let horizontalScrollView = BaseHorizontalScrollView()
    private let t1View = TutorialView()
    private let t2View = TutorialView()
    private let t3View = TutorialView()
    private let t4View = TutorialView()
    var images1:[UIImage]?
    var images2:[UIImage]?
    var images3:[UIImage]?
    let navView = TopDotView()
    var currentIndex = 0
    var inputCode = ""
    
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
        
        switch Standard.shared.getLocalized() {
            
        case .ENGLISH:
            images1 = [UIImage.init(named: "en1tuto1")!, UIImage.init(named: "en1tuto2")!, UIImage.init(named: "en1tuto3")!]
            images2 = [UIImage.init(named: "en2tuto1")!, UIImage.init(named: "en2tuto2")!, UIImage.init(named: "en2tuto3")!]
            images3 = [UIImage.init(named: "en3tuto1")!, UIImage.init(named: "en3tuto2")!]
        case .KOREAN:
            images1 = [UIImage.init(named: "kr1tuto1")!, UIImage.init(named: "kr1tuto2")!, UIImage.init(named: "kr1tuto3")!]
            images2 = [UIImage.init(named: "kr2tuto1")!, UIImage.init(named: "kr2tuto2")!, UIImage.init(named: "kr2tuto3")!]
            images3 = [UIImage.init(named: "kr3tuto1")!, UIImage.init(named: "kr3tuto2")!]
        case .GERMAN:
            images1 = [UIImage.init(named: "de1tuto1")!, UIImage.init(named: "de1tuto2")!, UIImage.init(named: "de1tuto3")!]
            images2 = [UIImage.init(named: "de2tuto1")!, UIImage.init(named: "de2tuto2")!, UIImage.init(named: "de2tuto3")!]
            images3 = [UIImage.init(named: "de3tuto1")!, UIImage.init(named: "de3tuto2")!]

        }
        
        
        KEYWINDOW!.addSubview(navView)
        
        
        navView.snp.makeConstraints { (make) in
            make.top.equalTo(KEYWINDOW!.safeArea.top).offset(DeviceSize.width > 320 ? 30 : 20)
            make.centerX.equalToSuperview()
            make.height.equalTo(DeviceSize.width > 320 ? 16 : 10)
        }
        
        navView.setHighlight(currentIndex: 0)

    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        
        let origin = scrollView.contentOffset.x
        let frameWith = scrollView.frame.width
        
        if origin == 0 {
            navView.setHighlight(currentIndex: 0)
        }
        else if origin <= frameWith  && origin > frameWith - 80 {
            navView.setHighlight(currentIndex: 1)
        }
        else if origin <= frameWith * 2  && origin > (frameWith * 2) - 80 {
            navView.setHighlight(currentIndex: 2)
        }
        else if origin <= frameWith * 3  && origin > (frameWith * 3) - 80 {
            navView.setHighlight(currentIndex: 3)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let _images1 = images1, let _images2 = images2, let _images3 = images3 {
            t1View.setData(title: "tutorial1_subtitle".localized, desc: "tutorial1".localized, images: _images1)
            t2View.setData(title: "tutorial2_subtitle".localized, desc: "tutorial2".localized, images:  _images2)
            t3View.setData(title: "tutorial3_subtitle".localized, desc: "tutorial3".localized, images: _images3)
        }
        
        
        t4View.setData(title: "tutorial4_subtitle".localized, desc: "tutorial4".localized, images: [UIImage.init(named: "en4tuto1")!, UIImage.init(named: "en4tuto2")!], isLast: true)
        
        t4View.delegate = self
    }
    
    func touchMove(sender: UIButton) { // 마지막 튜토리얼에서 게임페이지로 이동하는 함수
        
        sender.isUserInteractionEnabled = false
        navView.removeFromSuperview()
        
        for i in KEYWINDOW!.subviews {
            
            if i is TopDotView {
                i.removeFromSuperview()
            }
            
        }
        guard let vc = UIStoryboard.init(name: "Game", bundle: nil).instantiateViewController(withIdentifier: "GameNav") as? UINavigationController else {return}
        
    
        if let gvc = vc.viewControllers.first as? GameViewController {
            gvc.inputCode = inputCode            
        }
        
        self.present(vc, animated: true, completion: nil)
    }
}


final class TopDotView:UIView { // 튜토리얼 상단 네비게이션 화면
    
    private let stackView = UIStackView()
    private let firstView = UIView()
    private let secondView = UIView()
    private let thirdView = UIView()
    private let fourthView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    private func setUI() {
        
        self.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
    
        for v in [firstView, secondView, thirdView, fourthView] {
            stackView.addArrangedSubview(v)
            v.snp.makeConstraints { (make) in
                make.width.height.equalTo(DeviceSize.width > 320 ? 16 : 10)
            }
            v.backgroundColor = .white
            v.setBorder(color: .black, width: 3, cornerRadius: DeviceSize.width > 320 ? 8 : 5)
        }
        
        firstView.tag = 0
        secondView.tag = 1
        thirdView.tag = 2
        fourthView.tag = 3
        stackView.axis = .horizontal
        stackView.spacing = 15
        stackView.distribution = .fillEqually
    }
    
    func setHighlight(currentIndex:Int) {
        for v in [firstView, secondView, thirdView, fourthView] {
         
            
            UIView.animate(withDuration: 0.3) {
                if v.tag == currentIndex {
                    
                    v.backgroundColor = .black
                    
                }else{
                    
                    v.backgroundColor = .white
                    
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
