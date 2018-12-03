//
//  GameMainViewController.swift
//  WallPeckers
//
//  Created by Seongchan Kang on 03/12/2018.
//  Copyright © 2018 KimJimin and Company. All rights reserved.
//

import UIKit

class GameMainViewController: UIViewController, GameNavigationBarDelegate, GamePlayTimeDelegate {
    
    
    var timerView:NavigationCustomView?
    
    func checkPlayTime(_ time: Int) {

        timerView?.updateTime(time)
        
        if time == 0 { //완료 됐을떄

            print("END!")

        }else if time == 60 { // 1분 남았을 때

            print("1minute!")

        }
    }

    func touchMoveToMyPage(sender: UIButton) {
        sender.isUserInteractionEnabled = false
        
        guard let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyPageViewController") as? MyPageViewController else {return}
        sender.isUserInteractionEnabled = true
        
        self.present(vc, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setCustomNavigationBar()
        self.timerView = self.findTimerView()

        Standard.shared.startTimer(gameMode: .short)

    }
    
    func findTimerView() {
        if let vv = self.view.subviews.filter({
            
            $0 is GameNavigationBar
            
        }).first as? GameNavigationBar {
            if let _timerView = vv.subviews.filter({
                
                $0.tag == 99
                
            }).first as? NavigationCustomView {
                self.timerView = _timerView
            }
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

class GameNavigationBar:UIView {
    
    let timerView = NavigationCustomView()
    let myPageBtn = BottomButton()
    let scoreView = NavigationCustomView()
    var delegate:GameNavigationBarDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        self.backgroundColor = .red
        setUI()
    }
    
    
    func setUI() {
        
        self.addSubview([timerView, myPageBtn, scoreView])
        
        timerView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.width.equalTo(120)
            make.height.equalTo(50)
            make.leading.equalTo(10)
        }
        myPageBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(50)
            make.centerY.equalToSuperview()
        }
        
        scoreView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.width.equalTo(120)
            make.height.equalTo(50)
            make.trailing.equalTo(-10)
        }
        
        timerView.tag = 99
        
//        scoreView.updateTime(<#T##time: Int##Int#>)
        myPageBtn.setTitle("마이페이지", for: .normal)
        myPageBtn.addTarget(self, action: #selector(moveToMyPage(sender:)), for: .touchUpInside)
        
    }
    

    
    @objc func moveToMyPage(sender:UIButton) {
        delegate?.touchMoveToMyPage(sender: sender)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

protocol GameNavigationBarDelegate {
    
    func touchMoveToMyPage(sender:UIButton)
    
}

class NavigationCustomView:UIView {
    
    let topLeftImageView = UIImageView()
    let textLb = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    private func setUI() {
        
        self.addSubview([textLb, topLeftImageView])
        
        
        textLb.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.leading.top.equalTo(10)
            make.width.equalTo(100)
            make.height.equalTo(50)
        }
        
        topLeftImageView.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview()
            make.width.height.equalTo(50)
        }
        
    }
    
    func setData(text:String, image:UIImage) {
        
    }
    
    func updateTime(_ time:Int) {
        self.textLb.setText("\(time)", size: 12, textAlignment: .center)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}

