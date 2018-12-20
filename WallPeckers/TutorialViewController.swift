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
    
        // Do any additional setup after loading the view.
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
        t1View.setData(title: "WHO, WHEN, WHERE,\nWHAT, HOW and WHY?", desc: "As the Wall stood strong,\nit became a part of everyday\nand you forgot WHY.\nThe WALLPECKERS\n- the journalist of the Wall -\nask WHY and find the truth.", image: UIImage.init(named: "tutorial1")!)
        t2View.setData(title: "From the DMZ to the Berlin Wall", desc: "Cover issues about\nthe Korean DMZ, still standing 65 years\nand the Berlin Wall, demolished in 1989.\nWrite as many articles as you can\nincluding PAIRED ones. ", image:  UIImage.init(named: "tutorial2")!)
        t3View.setData(title: "INTO THE PRESSROOM", desc: "Collect clues by 5W1H\naround you in the pressroom\nand enter the CODE of them.\nGet a FACT-CHECK\nby the desk of WALLPECKERS\nand publish the article.", image: UIImage.init(named: "tutorial3")!)
        t4View.setData(title: "GOAL", desc: "You have 20 minutes\nto complete & publish the articles.\nMaximize your article points\nto be the journalist of the day!", image: UIImage.init(named: "tutorial4")!, isLast: true)

        t4View.delegate = self

    }
    
    func touchMove(sender: UIButton) {
        sender.isUserInteractionEnabled = false
        guard let vc = UIStoryboard.init(name: "Game", bundle: nil).instantiateViewController(withIdentifier: "GameNav") as? UINavigationController else {return}
        self.present(vc, animated: true, completion: nil)
    }
}

final class TutorialView:UIView {
    
    let nextBtn = BottomButton()
    let topLb = UILabel()
    let descLb = UILabel()
    let descImv = UIImageView()
    var delegate:TutorialViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        nextBtn.addTarget(self, action: #selector(moveToNext(sender:)), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        self.backgroundColor = .basicBackground
        self.addSubview([nextBtn, descLb, descImv, topLb])
        
        
        topLb.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(DEVICEHEIGHT > 800 ? 70 : 50)
            make.height.equalTo(50)
        }
        topLb.numberOfLines = 0
        
        nextBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(DEVICEHEIGHT > 800 ? -100 : -50)
            make.centerX.equalToSuperview()
            make.width.equalTo(270)
            make.height.equalTo(55)
        }
        nextBtn.setAttributedTitle("START".makeAttrString(font: .NotoSans(.medium, size: 25), color: .white), for: .normal)
        descImv.snp.makeConstraints { (make) in
            make.top.equalTo(topLb.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
            make.leading.equalTo(20)
            make.height.equalTo(DEVICEHEIGHT > 600 ? 270 : 200)
        }
        descLb.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(descImv.snp.bottom).offset(DEVICEHEIGHT > 600 ? 50 : 30)
            make.leading.equalTo(10)
        }
        descLb.textAlignment = .center
        descLb.numberOfLines = 0
    }
    
    func setData(title:String, desc:String, image:UIImage, isLast:Bool = false) {
        
        self.nextBtn.isHidden = !isLast
        self.topLb.setNotoText(title, size: 20, textAlignment: .center)
        self.descLb.setNotoText(desc, size: 16, textAlignment: .center)
        self.descImv.image = image
    }
    @objc func moveToNext(sender:UIButton) {
        delegate?.touchMove(sender: sender)
    }
}

protocol TutorialViewDelegate {
    
    func touchMove(sender:UIButton)
    
}
