//
//  CompleteArticleThumnailView.swift
//  WallPeckers
//
//  Created by Seongchan Kang on 28/12/2018.
//  Copyright © 2018 KimJimin and Company. All rights reserved.
//

import Foundation
import UIKit
import AloeStackView

final class CompleteArticleThumnailView:UIView, Tappable, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    class HashtagCollectionViewCell:UICollectionViewCell {
        
        
        let lbl = UILabel()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.addSubview(lbl)
            lbl.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let _hashTags = hashTags {
            return _hashTags.count
        }else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HashtagCollectionViewCell", for: indexPath) as? HashtagCollectionViewCell {
            
            if let _hash = hashTags {
                cell.lbl.attributedText = "\(_hash[indexPath.row])".makeAttrString(font: .NotoSans(.medium, size: 14), color: UIColor.deepSkyBlue)
                return cell
            }else{
                return UICollectionViewCell()
            }
        }else{
            return UICollectionViewCell()
        }
    }
    
    func didTapView() {
        delegate?.moveToNext(id: self.tag)
    }
    
    
    let titleLb = UILabel()
    var delegate:ThumnailDelegate?
    let coLayout = UICollectionViewLeftAlignedLayout()
    lazy var collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: coLayout)
    let hashView = UIView()
    let underLine = UIView()
    var hashTags:[String]?
    let rightArrowImv = UIImageView.init(image: UIImage.init(named: "right_arrow")!)
    let selectButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = true
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .always
        } else {
            // Fallback on earlier versions
        }
        coLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        coLayout.itemSize = UICollectionViewFlowLayout.automaticSize
        coLayout.minimumLineSpacing = 0
//        coLayout.itemSize = CGSize.init(width: 100, height: 30)
        collectionView.collectionViewLayout = coLayout
        
        collectionView.isScrollEnabled = false
        collectionView.register(HashtagCollectionViewCell.self, forCellWithReuseIdentifier: "HashtagCollectionViewCell")
        
    }
    
    
    
    func setData(article:Article) {
        
        if let hash1 = TopicSection.init(rawValue: article.section - 1), let hash2 = article.word, let hash4 = HashSection.init(rawValue: article.selectedHashtag), let hash5 = article.hashes {
            
            var region:String {
                
                switch Standard.shared.getLocalized() {
                    
                case .ENGLISH:
                    return article.region! == "GERMANY" ? "GERMANY" : "KOREA"

                case .GERMAN:
                    return article.region! == "GERMANY" ? "DEUTSCHLAND" : "KOREA"

                case .KOREAN:
                    return article.region! == "GERMANY" ? "독일" : "한국"
                }
            }
            
            hashTags = ["#" + "\(hash1)".localized.replacingOccurrences(of: "\n", with: ""), "#\(hash2)", "#\(region)", "\(hash4)".localized, article.isPairedArticle ? "#\(article.point)P X2" :  "#\(article.point) P"]
            
        }
        
        self.titleLb.attributedText = article.title!.makeAttrString(font: .NotoSans(.bold, size: 17), color: .black)
        self.tag = article.id
        
        collectionView.reloadData()
        
    }
    
    func setDataForPublish(article:Article) {
        
        self.backgroundColor = .white
        
        
        selectButton.addTarget(self, action: #selector(selectArticle(sender:)), for: .touchUpInside)
        self.addSubview(selectButton)
        
        selectButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
            make.trailing.equalTo(-10)
        }
        selectButton.setBackgroundColor(color: .white, forState: .normal)
        selectButton.setBackgroundColor(color: .sunnyYellow, forState: .selected)
        selectButton.setBackgroundColor(color: .init(white: 155/255, alpha: 1), forState: .disabled)
        
        selectButton.setBorder(color: .init(white: 155/255, alpha: 1), width: 1, cornerRadius: 12)
        
        if let hash1 = TopicSection.init(rawValue: article.section - 1), let hash2 = article.word, let hash4 = HashSection.init(rawValue: article.selectedHashtag), let hash5 = article.hashes {

            var region:String {
                
                switch Standard.shared.getLocalized() {
                    
                case .ENGLISH:
                    return article.region! == "GERMANY" ? "GERMANY" : "KOREA"
                    
                case .GERMAN:
                    return article.region! == "GERMANY" ? "DEUTSCHLAND" : "KOREA"
                    
                case .KOREAN:
                    return article.region! == "GERMANY" ? "독일" : "한국"
                }
            }
            
            
            hashTags = ["#" + "\(hash1)".localized.replacingOccurrences(of: "\n", with: ""), "#\(hash2)", "#\(region)", "\(hash4)".localized, article.isPairedArticle ? "#\(article.point)P X2" :  "#\(article.point) P"]
            
        }
        
        self.titleLb.attributedText = article.title!.makeAttrString(font: .NotoSans(.bold, size: 17), color: .black)
        self.tag = article.id
        collectionView.backgroundColor = .white
        collectionView.reloadData()
//        collectionView.
        
    }
    
    @objc func selectArticle(sender:UIButton) {
        
        
        sender.isSelected = true
        
        delegate?.selectNewspaper!(id: self.tag)
        
    }
    
    
    private func setUI() {
        
        self.backgroundColor = .basicBackground
        self.addSubview([titleLb, collectionView, underLine, rightArrowImv])
        
        titleLb.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.leading.equalTo(10)
            make.trailing.equalTo(-30)
        }
        rightArrowImv.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
            make.width.height.equalTo(20)
        }
        rightArrowImv.contentMode = .center
        titleLb.numberOfLines = 0

        collectionView.snp.makeConstraints { (make) in
           
            make.top.equalTo(titleLb.snp.bottom).offset(10)
            make.leading.equalTo(10)
            
//            make.height.equalTo(90)
            make.bottom.equalTo(-10)
            make.trailing.equalTo(-35)
            
        }
        collectionView.backgroundColor = .basicBackground
        underLine.snp.makeConstraints { (make) in
            make.top.equalTo(collectionView.snp.bottom).offset(5)
            make.height.equalTo(1.5)
            make.leading.equalTo(7)
            make.centerX.equalToSuperview()
        }
        collectionView.reloadData()
        
        underLine.backgroundColor = .black
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

@objc protocol ThumnailDelegate {
    func moveToNext(id:Int)
    @objc optional func selectNewspaper(id:Int)
}

