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

    let horizontalScrollView = BaseHorizontalScrollView()
    let t1View = TutorialView()
    let t2View = TutorialView()
    let t3View = TutorialView()
    let t4View = TutorialView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    
        // Do any additional setup after loading the view.
    }
    
    func setUI() {
        horizontalScrollView.setScrollView(vc: self)
        
        
        
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
        
        t1View.backgroundColor = .red
        t2View.backgroundColor = .blue
        t3View.backgroundColor = .black
        t4View.backgroundColor = .white
        t1View.setData(title: "d", image: UIImage())
        t2View.setData(title: "d", image: UIImage())
        t3View.setData(title: "d", image: UIImage())
        t4View.setData(title: "d", image: UIImage(), isLast: true)
        t4View.delegate = self

    }
    
    func touchMove(sender: UIButton) {
        sender.isUserInteractionEnabled = false
        guard let vc = UIStoryboard.init(name: "Game", bundle: nil).instantiateViewController(withIdentifier: "GameNav") as? UINavigationController else {return}
        
        self.present(vc, animated: true, completion: nil)
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
    
    let nextBtn = BottomButton()
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
        
        self.addSubview([nextBtn, descLb, descImv])
        
        nextBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(-100)
            make.centerX.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(50)
        }
        descLb.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        descLb.numberOfLines = 0
        descImv.snp.makeConstraints { (make) in
            make.top.equalTo(20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(100)
        }
        
    }
    
    func setData(title:String, image:UIImage, isLast:Bool = false) {
        
        if !isLast {
            nextBtn.isHidden = true
        }
        self.descLb.setText(title, size: 10, textAlignment: .center)
        self.descImv.image = image
        
        
    }
    
    @objc func moveToNext(sender:UIButton) {
        
        delegate?.touchMove(sender: sender)
        
        
    }
    
}

protocol TutorialViewDelegate {
    
    func touchMove(sender:UIButton)
    
}
