//
//  EditHeadlineViewController.swift
//  WallPeckers
//
//  Created by Seongchan Kang on 26/12/2018.
//  Copyright © 2018 KimJimin and Company. All rights reserved.
//

import UIKit
import AloeStackView

class EditHeadlineViewController: UIViewController {

    let dismissBtn = UIButton()
    let titleLb = UILabel()
    let headLineLb = UILabel()
    let arrowLb = UILabel()
    let featuredLb = UILabel()
    let aStackView = AloeStackView()
    let nextButton = BottomButton()
    var defaultHeadlines:[Int] = []
//    var selectedHeadLine = 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
      
    }
    
    func setUI() {
        dismissBtn.setImage(UIImage.init(named: "dismissButton")!, for: .normal)
        
        
        self.view.addSubview([titleLb, dismissBtn, headLineLb, arrowLb, featuredLb, aStackView, nextButton])
        self.view.backgroundColor = .basicBackground
        dismissBtn.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeArea.top)
            make.trailing.equalToSuperview()
            make.width.height.equalTo(40)
        }
        
        titleLb.snp.makeConstraints { (make) in
            make.top.equalTo(dismissBtn.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        titleLb.setNotoText("Edit My Newspaper", color: .black, size: 20, textAlignment: .center, font: .bold)
        
        
        arrowLb.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLb.snp.bottom).offset(20)
            make.width.height.equalTo(24)

        }
        arrowLb.setNotoText(">", color: .init(white: 155/255, alpha: 1), size: 20, textAlignment: .center, font: .bold)
        
        headLineLb.snp.makeConstraints { (make) in
            make.trailing.equalTo(arrowLb.snp.leading)
            make.top.equalTo(titleLb.snp.bottom).offset(20)
            make.width.equalTo(140)
        }
        headLineLb.numberOfLines = 2
        
        featuredLb.snp.makeConstraints { (make) in
            make.centerY.equalTo(headLineLb.snp.centerY)
            make.leading.equalTo(arrowLb.snp.trailing)
            make.width.equalTo(140)
        }
        
        aStackView.setBorder(color: .black, width: 1.5)
        aStackView.separatorColor = .clear
        aStackView.snp.makeConstraints { (make) in
            make.leading.equalTo(15)
            make.centerX.equalToSuperview()
            make.top.equalTo(arrowLb.snp.bottom).offset(30)
            make.height.equalTo(DeviceSize.width > 320 ? 400 : 300)
        }
        
        for ca in RealmArticle.shared.get(Standard.shared.getLocalized()).filter({$0.isCompleted}) {
            
            let tv = CompleteArticleThumnailView()
            
            tv.backgroundColor = .white
            tv.setDataForPublish(article: ca)
            tv.delegate = self
            
            if tv.tag == defaultHeadlines[0] {
                tv.selectButton.isSelected = true
            }
            
            aStackView.addRow(tv)
            
        }
        
        nextButton.snp.makeConstraints { (make) in
            make.top.equalTo(aStackView.snp.bottom).offset(20)
            make.leading.equalTo(50)
            make.height.equalTo(55)
            make.centerX.equalToSuperview()
        }
        
        nextButton.addTarget(self, action: #selector(moveNext(sender:)), for: .touchUpInside)
        nextButton.setTitle("NEXT", for: .normal)
        dismissBtn.addTarget(self, action: #selector(touchDismiss(sender:)), for: .touchUpInside)
        
        
    }
    
    @objc func touchDismiss(sender:UIButton) {
    
        sender.isUserInteractionEnabled = false
        
        self.navigationController?.popViewController(animated: true)
        
        sender.isUserInteractionEnabled = true
        
    }
    
    @objc func moveNext(sender:UIButton) {
        

        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditFeaturesViewController") as? EditFeaturesViewController else {return}
        
        vc.defaultHeadlines = defaultHeadlines
        
        self.navigationController?.pushViewController(vc, animated: true)
        
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

extension EditHeadlineViewController:ThumnailDelegate {
    func moveToNext(id: Int) {
        print(id)
    }
    
    func selectNewspaper(id: Int) {
        
        if let sv = self.aStackView.getAllRows() as? [CompleteArticleThumnailView] {
            _ = sv.map({
                
                if $0.tag != id {
                    $0.selectButton.isSelected = false
                }
            })
        }
        defaultHeadlines[0] = id
        print(id)
    }
    
    
    
}
