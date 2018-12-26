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
    var selectedId:[Int] = [] {
        didSet {
            
            // 2개 이하일때 예외처리는 내일 하기
            if selectedId.count == 2 {
                nextButton.isEnabled = true
            }else{
                nextButton.isEnabled = false
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        
        // Do any additional setup after loading the view.
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
        nextButton.setBackgroundColor(color: .init(white: 155/255, alpha: 1), forState: .disabled)
        
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
            tv.selectButton.setBackgroundColor(color: .tangerine, forState: .selected)
            if tv.tag == defaultHeadlines[0] {
                tv.selectButton.isEnabled = false
            }else if tv.tag == defaultHeadlines[1] {
                tv.selectButton.isSelected = true
                selectedId.append(tv.tag)
            }else if tv.tag == defaultHeadlines[2] {
                tv.selectButton.isSelected = true
                selectedId.append(tv.tag)
            }
            
            aStackView.addRow(tv)
            
        }
        
        print(selectedId)
        print(defaultHeadlines)
        print("DASJDLKASJDKL")
        
        nextButton.snp.makeConstraints { (make) in
            make.top.equalTo(aStackView.snp.bottom).offset(20)
            make.leading.equalTo(50)
            make.height.equalTo(55)
            make.centerX.equalToSuperview()
        }
        nextButton.isEnabled = false
        //
        nextButton.addTarget(self, action: #selector(moveToNext(sender:)), for: .touchUpInside)
        nextButton.setTitle("OK", for: .normal)
        dismissBtn.addTarget(self, action: #selector(touchDismiss(sender:)), for: .touchUpInside)
        //
        
    }
    
    @objc func touchDismiss(sender:UIButton) {
        
        sender.isUserInteractionEnabled = false
        
        self.navigationController?.popViewController(animated: true)
        
        sender.isUserInteractionEnabled = true
        
    }
    
    @objc func moveToNext(sender:UIButton) {
        
        sender.isUserInteractionEnabled = false
        
        guard let vc = self.navigationController?.viewControllers.filter({$0 is PublishViewController}).first as? PublishViewController else {return}
        
        defaultHeadlines[1] = selectedId[0]
        defaultHeadlines[2] = selectedId[1]
        
        vc.delegate = self
        print(defaultHeadlines)
        
        try! realm.write {
            _ = RealmUser.shared.getUserData()?.publishedArticles.removeAll()
            _ = defaultHeadlines.map({RealmUser.shared.getUserData()?.publishedArticles.append($0)})
            
        }
        print("~~~~~")
        
        self.navigationController?.popToViewController(vc, animated: true)
        
        
    }
    
    
    
    
    
}

extension EditFeaturesViewController:ThumnailDelegate {
    func moveToNext(id: Int) {
        print(id)
    }
    
    func selectNewspaper(id: Int) {
        
        
        //하나 선택되어있을때는 아래 조건 땜에 초기화가 안됨 ~ 이건 내일 처리 ㄱ
   
        if selectedId.count == 2 {
            if let aa = self.aStackView.getAllRows().filter({$0 is CompleteArticleThumnailView}) as? [CompleteArticleThumnailView] {
                
                if let aaa = aa.filter({$0.tag == id}).first {
                    aaa.selectButton.isSelected = false
                }
                
                _ = aa.map({
                    
                    if selectedId.contains(id) {
                        
                        if $0.tag == id {
                            
                            $0.selectButton.isSelected = false
                            if let idx = selectedId.firstIndex(of: $0.tag) {
                                selectedId.remove(at: idx)
                            }
                        }
                        
                    }
                })
                
                
                
            }
            return
        }else{
            if !selectedId.contains(id) {
                selectedId.append(id)
            }
        }
        
    }
    
    
}

extension EditFeaturesViewController:EditHeadlineProtocol {
    var headlines: [Int]? {
        get {
            return defaultHeadlines
        }
    }
    
    
}
