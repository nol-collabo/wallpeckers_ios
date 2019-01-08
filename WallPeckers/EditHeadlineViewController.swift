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
    let scrollView = BaseVerticalScrollView()
    let dismissBtn = UIButton()
    let titleLb = UILabel()
    let headLineLb = UILabel()
    let arrowLb = UILabel()
    let featuredLb = UILabel()
    let aStackView = AloeStackView()
    let nextButton = BottomButton()
    var defaultHeadlines:[Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        
    }
    
    private func setUI() {
        
        dismissBtn.setImage(UIImage.init(named: "dismissButton")!, for: .normal)
        
        scrollView.setScrollView(vc: self)

        self.scrollView.contentView.addSubview([titleLb, dismissBtn, headLineLb, arrowLb, featuredLb, aStackView, nextButton])
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
        
        
        
        titleLb.setNotoText("titlearticlechange_title".localized, color: .black, size: 20, textAlignment: .center, font: .bold)
        
        
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
        headLineLb.attributedText = "titlearticlechange_titleselect".localized.makeAttrString(font: .NotoSans(.medium, size: 14), color: .black)
        featuredLb.attributedText = "titlearticlechange_subselect".localized.makeAttrString(font: .NotoSans(.medium, size: 14), color: .init(white: 155/255, alpha: 1))
        
        featuredLb.snp.makeConstraints { (make) in
            make.centerY.equalTo(headLineLb.snp.centerY)
            make.leading.equalTo(arrowLb.snp.trailing).offset(20)
            make.width.equalTo(140)
            make.trailing.equalTo(-10)

        }
        featuredLb.numberOfLines = 0

        aStackView.setBorder(color: .black, width: 1.5)
        aStackView.separatorColor = .clear
        aStackView.snp.makeConstraints { (make) in
            make.leading.equalTo(15)
            make.centerX.equalToSuperview()
            make.top.equalTo(arrowLb.snp.bottom).offset(30)
            make.height.equalTo(DeviceSize.width > 320 ? 400 : 300)
        }
        
        let totalArticle = RealmArticle.shared.get(Standard.shared.getLocalized()).filter({$0.isCompleted})
        
        if totalArticle.count > 3 {
            nextButton.setBackgroundColor(color: .basicBackground, forState: .disabled)
            nextButton.setBackgroundColor(color: .black, forState: .normal)
            nextButton.isEnabled = false
        }else{
            nextButton.isEnabled = true
        }
        
        for ca in totalArticle {
            
            let tv = CompleteArticleThumnailView()
            
            tv.backgroundColor = .white
            tv.setDataForPublish(article: ca)
            tv.delegate = self
            tv.rightArrowImv.isHidden = true

            if totalArticle.count <= 3 {
            
            if tv.tag == defaultHeadlines[0] {
                tv.selectButton.isSelected = true
                }
            }
            
            aStackView.addRow(tv)
            
        }
        
        nextButton.snp.makeConstraints { (make) in
            make.top.equalTo(aStackView.snp.bottom).offset(20)
            make.leading.equalTo(50)
            make.height.equalTo(55)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-20)
        }
        
        nextButton.addTarget(self, action: #selector(moveNext(sender:)), for: .touchUpInside)
        nextButton.setTitle("Next".localized, for: .normal)
        dismissBtn.addTarget(self, action: #selector(touchDismiss(sender:)), for: .touchUpInside)
        
        
    }
    
    @objc func touchDismiss(sender:UIButton) {
    
        sender.isUserInteractionEnabled = false
        
        self.navigationController?.popViewController(animated: true)
        
        sender.isUserInteractionEnabled = true
        
    }
    
    @objc func moveNext(sender:UIButton) {
        
        if (RealmArticle.shared.get(Standard.shared.getLocalized()).filter({$0.isCompleted}).count) < 2 { // 헤드라인밖에 없을때
            
            sender.isUserInteractionEnabled = false
            
            guard let vc = self.navigationController?.viewControllers.filter({$0 is PublishViewController}).first as? PublishViewController else {return}
            
            vc.delegate = self
            
            try! realm.write {
                _ = RealmUser.shared.getUserData()?.publishedArticles.removeAll()
                _ = defaultHeadlines.map({RealmUser.shared.getUserData()?.publishedArticles.append($0)})
                
            }
            self.navigationController?.popToViewController(vc, animated: true)
            
            
        }else{
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditFeaturesViewController") as? EditFeaturesViewController else {return}
            
            print(defaultHeadlines)
            print("DDDDD")
            vc.defaultHeadlines = defaultHeadlines
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

}

extension EditHeadlineViewController:ThumnailDelegate, EditHeadlineProtocol {
    var headlines: [Int]? {
        return defaultHeadlines
    }
    
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
        
        let totalArticle = RealmArticle.shared.get(Standard.shared.getLocalized()).filter({$0.isCompleted})

        if totalArticle.count <= 3 {
            defaultHeadlines[0] = id

        }else{
            defaultHeadlines.removeAll()
            defaultHeadlines.append(id)
            nextButton.isEnabled = true

        }
    }
    
    
    
}
