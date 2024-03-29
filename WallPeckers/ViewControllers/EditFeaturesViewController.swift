//
//  EditFeaturesViewController.swift
//  WallPeckers
//
//  Created by Seongchan Kang on 26/12/2018.
//  Copyright © 2018 KimJimin and Company. All rights reserved.
//

import UIKit
import AloeStackView

class EditFeaturesViewController: UIViewController {
    
    var defaultHeadlines:[Int] = []
    let dismissBtn = UIButton()
    let titleLb = UILabel()
    let headLineLb = UILabel()
    let arrowLb = UILabel()
    let featuredLb = UILabel()
    let aStackView = AloeStackView()
    let nextButton = BottomButton()
    var firstSelected:Int = 0
    let scrollView = BaseVerticalScrollView()
    let backButton = BottomButton()
    let infoLb = UILabel()
    let topCircle = UIView()
    var selectedId:[Int] = [] {
        didSet {
            let count = RealmArticle.shared.get(Standard.shared.getLocalized()).filter({$0.isCompleted}).count
            if count >= 3 {
                if selectedId.count == 2 {
                    nextButton.isEnabled = true
                }else{
                    nextButton.isEnabled = false
                }
            }else if count == 2 {
                nextButton.isEnabled = true
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        addAction()
        // Do any additional setup after loading the view.
    }
    
    private func setUI() {
        dismissBtn.setImage(UIImage.init(named: "dismissButton")!, for: .normal)
        
        scrollView.setScrollView(vc: self)
        
        self.scrollView.contentView.addSubview([titleLb, dismissBtn, headLineLb, arrowLb, featuredLb, aStackView, infoLb, nextButton, backButton, topCircle])
        self.view.backgroundColor = .basicBackground
        dismissBtn.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
            make.width.height.equalTo(DeviceSize.width > 320 ? 40 : 30)
        }
        
        titleLb.snp.makeConstraints { (make) in
            make.top.equalTo(dismissBtn.snp.bottom).offset(DeviceSize.width > 320 ? 20 : 5)
            make.centerX.equalToSuperview()
        }
        
        titleLb.setNotoText("titlearticlechange_title".localized, color: .black, size: 20, textAlignment: .center, font: .bold)
        
        
        arrowLb.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLb.snp.bottom).offset(DeviceSize.width > 320 ? 20 : 10)
            make.width.height.equalTo(24)
            
        }
        
        
        arrowLb.setNotoText(">", color: .init(white: 155/255, alpha: 1), size: 20, textAlignment: .center, font: .bold)
        
        headLineLb.snp.makeConstraints { (make) in
            make.trailing.equalTo(arrowLb.snp.leading)
            make.top.equalTo(titleLb.snp.bottom).offset(20)
            make.width.equalTo(120)
        }
        
        topCircle.snp.makeConstraints { (make) in
            make.width.height.equalTo(10)
            make.centerX.equalTo(featuredLb.snp.centerX).offset(-25)
            make.bottom.equalTo(featuredLb.snp.top).offset(-10)
        }
        
        topCircle.backgroundColor = .tangerine
        topCircle.setBorder(color: .clear, width: 0.1, cornerRadius: 5)
        
        headLineLb.numberOfLines = 2
        headLineLb.attributedText = "titlearticlechange_titleselect".localized.makeAttrString(font: .NotoSans(.medium, size: 14), color: .init(white: 155/255, alpha: 1))
        featuredLb.attributedText = "titlearticlechange_subselect".localized.makeAttrString(font: .NotoSans(.medium, size: 14), color: .black)
        featuredLb.snp.makeConstraints { (make) in
            make.centerY.equalTo(headLineLb.snp.centerY)
            make.leading.equalTo(arrowLb.snp.trailing).offset(20)
            make.trailing.equalTo(-10)
            make.width.equalTo(120)
        }
        featuredLb.numberOfLines = 0
        nextButton.setBackgroundColor(color: .init(white: 155/255, alpha: 1), forState: .disabled)
        
        aStackView.setBorder(color: .black, width: 1.5)
        aStackView.separatorColor = .clear
        aStackView.snp.makeConstraints { (make) in
            make.leading.equalTo(15)
            make.centerX.equalToSuperview()
            make.top.equalTo(arrowLb.snp.bottom).offset(DeviceSize.width > 320 ? 30 : 10)
            make.height.equalTo(DeviceSize.width > 320 ? 400 : 300)
        }
        
        
        infoLb.snp.makeConstraints { (make) in
            make.top.equalTo(aStackView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        infoLb.attributedText = "titlearticlechange_guide".localized.makeAttrString(font: .NotoSans(.bold, size: 18), color: .black)
        infoLb.textAlignment = .center
        
        for ca in RealmArticle.shared.get(Standard.shared.getLocalized()).filter({$0.isCompleted}) {
            
            let tv = CompleteArticleThumnailView()
            
            tv.backgroundColor = .white
            tv.setDataForPublish(article: ca)
            tv.delegate = self
            tv.rightArrowImv.isHidden = true
            tv.selectButton.setBackgroundColor(color: .tangerine, forState: .selected)
            
            let totalCount = RealmArticle.shared.get(Standard.shared.getLocalized()).filter({$0.isCompleted}).count
            
            if totalCount == 3 {
                if tv.tag == defaultHeadlines[0] {
                    tv.isUserInteractionEnabled = false
                    tv.selectButton.isEnabled = false
                    tv.selected()
                }else if tv.tag == defaultHeadlines[1] {
                    tv.selectButton.isSelected = true
                    selectedId.append(tv.tag)
                }else if tv.tag == defaultHeadlines[2] {
                    tv.selectButton.isSelected = true
                    selectedId.append(tv.tag)
                }
                infoLb.isHidden = false
            }else if totalCount == 2{
                if tv.tag == defaultHeadlines[0] {
                    tv.isUserInteractionEnabled = false
                    tv.selectButton.isEnabled = false
                    tv.selected()
                }else if tv.tag == defaultHeadlines[1] {
                    tv.selectButton.isSelected = true
                    selectedId.append(tv.tag)
                }
                infoLb.isHidden = true
            }else {
                if tv.tag == defaultHeadlines[0] {
                    tv.selected()
                    tv.selectButton.isEnabled = false
                    tv.isUserInteractionEnabled = false
                }
            }
            aStackView.addRow(tv)
        }
        
        nextButton.snp.makeConstraints { (make) in
            make.top.equalTo(aStackView.snp.bottom).offset(DeviceSize.width > 320 ? 50 : 30)
            make.leading.equalTo(50)
            make.height.equalTo(DeviceSize.width > 320 ? 55 : 45)
            make.centerX.equalToSuperview()
        }
        
        backButton.snp.makeConstraints { (make) in
            make.top.equalTo(nextButton.snp.bottom).offset(10)
            make.leading.equalTo(50)
            make.height.equalTo(DeviceSize.width > 320 ? 55 : 45)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-10)
        }
        
        backButton.setTitle("BACK".localized, for: .normal)
        
        if selectedId.count == 2 {
            nextButton.isEnabled = true
        }else{
            if RealmArticle.shared.get(Standard.shared.getLocalized()).filter({$0.isCompleted}).count == 2 {
                nextButton.isEnabled = true
            }else{
                nextButton.isEnabled = false
            }
        }
        nextButton.setTitle("OK".localized, for: .normal)
        
        
        
    }
    
    private func addAction() {
        nextButton.addTarget(self, action: #selector(moveToNext(sender:)), for: .touchUpInside)
        dismissBtn.addTarget(self, action: #selector(touchDismiss(sender:)), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(moveBack(sender:)), for: UIControl.Event.touchUpInside)
    }
    
    @objc func moveBack(sender:UIButton) {
        
        sender.isUserInteractionEnabled = false
        self.navigationController?.popViewController(animated: true)
        sender.isUserInteractionEnabled = true
        
    }
    
    @objc func touchDismiss(sender:UIButton) {
        
        sender.isUserInteractionEnabled = false
        self.navigationController?.popToRootViewController(animated: true)
        sender.isUserInteractionEnabled = true
        
    }
    
    @objc func moveToNext(sender:UIButton) {
        
        sender.isUserInteractionEnabled = false
        
        guard let vc = self.navigationController?.viewControllers.filter({$0 is PublishViewController}).first as? PublishViewController else {return}
        
        let completedCount = RealmArticle.shared.get(Standard.shared.getLocalized()).filter({$0.isCompleted}).count
        
        if completedCount == 1 {
            
        }else if completedCount == 2 {
            if selectedId.count > 0 {
                defaultHeadlines[1] = selectedId[0]
            }
        }else{
            
            let totalArticle = RealmArticle.shared.get(Standard.shared.getLocalized()).filter({$0.isCompleted})
            
            if totalArticle.count <= 3 {
                defaultHeadlines[1] = selectedId[0]
                defaultHeadlines[2] = selectedId[1]
            }else{
                defaultHeadlines.append(selectedId[0])
                defaultHeadlines.append(selectedId[1])
                
            }
            
        }
        
        vc.delegate = self
        
        try! realm.write {
            _ = RealmUser.shared.getUserData()?.publishedArticles.removeAll()
            _ = defaultHeadlines.map({RealmUser.shared.getUserData()?.publishedArticles.append($0)})
        }
        
        self.navigationController?.popToViewController(vc, animated: true)
        
        
    }

}

extension EditFeaturesViewController:ThumnailDelegate {
    func moveToNext(id: Int) {
        
        if selectedId.count == 2 { // 이미 선택된 기사가 2개 일때 추가 선택 시 기존에 선택된 기사 제거하는 로직
            
            
            if let aa = self.aStackView.getAllRows().filter({$0 is CompleteArticleThumnailView}) as? [CompleteArticleThumnailView] {
                
                
                if let aaa = aa.filter({$0.tag == id}).first {
                    if !selectedId.contains(id) {
                        let before = selectedId.removeFirst()
                        
                        if let beforeV = aa.filter({$0.tag == before}).first {
                            beforeV.selectButton.isSelected = false
                        }
                        
                        aaa.selectButton.isSelected = true
                        selectedId.append(id)
                    }else{
                        aaa.selectButton.isSelected = false
                        if let idx = selectedId.firstIndex(of: id) {
                            selectedId.remove(at: idx)
                        }
                    }
                }
            }
            return
        }else{
            if let aa = self.aStackView.getAllRows().filter({$0 is CompleteArticleThumnailView}) as? [CompleteArticleThumnailView] {
                if let sv = aa.filter({$0.tag == id}).first {
                    if !selectedId.contains(id) {
                        selectedId.append(id)
                        sv.selectButton.isSelected = true
                    }else{
                        sv.selectButton.isSelected = false
                        if let idx = selectedId.firstIndex(of: id) {
                            selectedId.remove(at: idx)
                        }
                    }
                }
            }
        }
    }
    
    func selectNewspaper(id: Int) {
        
        print(id)
    }
}

extension EditFeaturesViewController:EditHeadlineProtocol {
    var headlines: [Int]? {
        get {
            return defaultHeadlines
        }
    }
}
