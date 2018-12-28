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
    let selectButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        collectionView.delegate = self
        collectionView.dataSource = self
        coLayout.estimatedItemSize = CGSize.init(width: 100, height: 20)
        coLayout.itemSize = CGSize.init(width: 100, height: 20)
        collectionView.collectionViewLayout = coLayout
        collectionView.register(HashtagCollectionViewCell.self, forCellWithReuseIdentifier: "HashtagCollectionViewCell")
        
    }
    
    func setData(article:Article) {
        
        if let hash1 = TopicSection.init(rawValue: article.section - 1), let hash2 = article.word, let hash4 = HashSection.init(rawValue: article.selectedHashtag), let hash5 = article.hashes {
            
            let aa = hash5.components(separatedBy: "/").index(after: article.selectedHashtag - 1)
            
            hashTags = ["#" + "\(hash1)".localized, "#\(hash2)", "\(hash4)".localized, article.isPairedArticle ? "\(article.point) P X 2" :  "\(article.point) P", "\(aa)%"]
            
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
            
            let aa = hash5.components(separatedBy: "/").index(after: article.selectedHashtag - 1)
            
            hashTags = ["#" + "\(hash1)".localized, "#\(hash2)", "\(hash4)".localized, article.isPairedArticle ? "\(article.point) P X 2" :  "\(article.point) P", "\(aa)%"]
            
        }
        
        self.titleLb.attributedText = article.title!.makeAttrString(font: .NotoSans(.bold, size: 17), color: .black)
        self.tag = article.id
        collectionView.backgroundColor = .white
        collectionView.reloadData()
        
    }
    
    @objc func selectArticle(sender:UIButton) {
        
        
        sender.isSelected = true
        
        delegate?.selectNewspaper!(id: self.tag)
        
    }
    
    
    private func setUI() {
        
        self.backgroundColor = .basicBackground
        self.addSubview([titleLb, hashView, underLine])
        
        titleLb.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.leading.equalTo(10)
            make.trailing.equalTo(-30)
        }
        titleLb.numberOfLines = 0
        hashView.snp.makeConstraints { (make) in
            make.leading.equalTo(10)
            make.top.equalTo(titleLb.snp.bottom).offset(10)
            make.height.equalTo(50)
            make.bottom.equalTo(-5)
            make.trailing.equalTo(-10)
        }
        hashView.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.top.leading.bottom.equalToSuperview()
            make.trailing.equalTo(-30)
        }
        collectionView.backgroundColor = .basicBackground
        underLine.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.height.equalTo(1.5)
            make.leading.equalTo(7)
            make.centerX.equalToSuperview()
        }
        self.layoutSubviews()
        self.layoutIfNeeded()
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

