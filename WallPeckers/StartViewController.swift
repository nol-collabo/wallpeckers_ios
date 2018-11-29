//
//  StartViewController.swift
//  WallPeckers
//
//  Created by Seongchan Kang on 26/11/2018.
//  Copyright © 2018 KimJimin and Company. All rights reserved.
//

import UIKit
import SnapKit

class StartViewController: UIViewController {

    
    let imageView = UIImageView()
    let playButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        
        // Do any additional setup after loading the view.
    }
    
    private func setUI() {
        
        self.view.addSubview([imageView, playButton])
        
        playButton.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.leading.equalTo(50)
            make.centerX.equalToSuperview()
            make.height.equalTo(80)
        }
        playButton.backgroundColor = .red
        playButton.addTarget(self, action: #selector(playBtnTouched(sender:)), for: .touchUpInside)
        imageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeArea.top).offset(50)
            make.width.height.equalTo(300)
        }
        
    }
    
    @objc func playBtnTouched(sender:UIButton) {
        
        PopUp.call(selectButtonTitles: ["a","b","c"], bottomButtonTitle: "확인", self)
        
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


extension StartViewController:SelectPopupDelegate {
    func bottomButtonTouched(sender: UIButton) {
        print(sender.currentTitle)
    }
    
    func selectButtonTouched(tag: Int) {
        print(tag)
    }
    
    
    
    
}
