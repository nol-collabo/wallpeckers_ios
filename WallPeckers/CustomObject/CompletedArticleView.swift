//
//  CompletedArticleView.swift
//  WallPeckers
//
//  Created by Seongchan Kang on 28/12/2018.
//  Copyright © 2018 KimJimin and Company. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

final class CompletedArticleView:UIView {
    
    let titleImageView = UIImageView.init(image: UIImage.init(named: "completeArticleLogo")!)
    let underLine1 = UIView()
    let titleLb = UILabel()
    let imageContainerView = UIView()
    let layout = UICollectionViewFlowLayout()
    lazy var imageCollectionView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
    let infoLb = UILabel()
    let articleTv = UITextView()
    let underLine2 = UIView()
    let commentTitleLb = UILabel()
    let thumbImgView = UIImageView()
    let commentProfileImv = UIImageView()
    let commentTv = UITextView()
    let dFormatter = DateFormatter()
    var images:[String] = [] {
        didSet {
            print(images)
            imageCollectionView.reloadData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    func setData(article:Article, wrongClue:[Int], region:String) {
        
        dFormatter.dateFormat = "MM.dd.yyyy"
        
        
        images = Album.findImages(articleId: article.id)
        
        let dString = dFormatter.string(from: Date()).makeAttrString(font: .NotoSans(.medium, size: 19), color: .black)
        let infoAString = "".makeAttrString(font: .NotoSans(.medium, size: 19), color: .black)
        let regionString = region == "GERMANY" ? "at the Berlin Wall".localized : "completearticle_korea".localized
        let userNameString = "by \(RealmUser.shared.getUserData()?.name! ?? "User")"
        infoAString.append(dString)
        infoAString.append("\n\(regionString)".makeAttrString(font: .NotoSans(.medium, size: 19), color: .black))
        infoAString.append("\n\(userNameString)".makeAttrString(font: .NotoSans(.medium, size: 19), color: .black))
        //        thumbImgView.image =
        
        //         UIImage.init(named: "image_article_0\(article.id)")
        infoLb.attributedText = infoAString
        
        let articleString:NSMutableAttributedString = "".makeAttrString(font: .NotoSans(.medium, size: 12), color: .black)
        
        for clue in article.clues {
            
            if let a = RealmClue.shared.getLocalClue(id: clue, language: Standard.shared.getLocalized()) {
                
                if wrongClue.count > 0 {
                    
                    print(wrongClue)
                    print("VVV")
                    
                    if wrongClue.contains(a.id) {
                        articleString.append(("\(a.desc!) ".makeAttrString(font: .NotoSans(.medium, size: 19), color: .blue)))
                        
                    }else{
                        articleString.append(("\(a.desc!) ".makeAttrString(font: .NotoSans(.medium, size: 19), color: .black)))
                        
                    }
                    
                }else{
                    articleString.append(("\(a.desc!) ".makeAttrString(font: .NotoSans(.medium, size: 19), color: .black)))
                }
            }
        }
        
        let titleAstring = "".makeAttrString(font: .NotoSans(.regular, size: 13), color: .black)
        
        titleAstring.append(article.title!.makeAttrString(font: .NotoSans(.bold, size: 20), color: .black))
        titleAstring.append("\n\(article.title_sub!)".makeAttrString(font: .NotoSans(.medium, size: 14), color: .black))
        
        self.titleLb.attributedText = titleAstring
        self.articleTv.attributedText = articleString
        self.commentTv.attributedText = article.result!.makeAttrString(font: .NotoSans(.regular, size: 15), color: .black)
    }
    
    private func setUI() {
        
        self.setBorder(color: .black, width: 1.5)
        self.addSubview([titleImageView, underLine1, titleLb, imageContainerView, infoLb, articleTv, underLine2, commentTitleLb, thumbImgView, commentProfileImv, commentTv])
        titleImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(30)
            make.leading.equalTo(15)
            make.height.equalTo(45)
        }
        titleImageView.contentMode = .scaleAspectFit
        
        underLine1.snp.makeConstraints { (make) in
            make.height.equalTo(1.5)
            make.top.equalTo(titleImageView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.leading.equalTo(15)
        }
        
        titleLb.snp.makeConstraints { (make) in
            make.top.equalTo(underLine1.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.leading.equalTo(15)
            make.height.equalTo(80)
        }
        titleLb.numberOfLines = 0
        underLine1.backgroundColor = .black
        underLine2.backgroundColor = .black
        
        imageContainerView.snp.makeConstraints { (make) in
            make.leading.equalTo(15)
            make.top.equalTo(titleLb.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(190)
        }
        infoLb.snp.makeConstraints { (make) in
            make.trailing.equalTo(-15)
            make.top.equalTo(imageContainerView.snp.bottom).offset(10)
            make.leading.equalTo(15)
            make.height.equalTo(90)
        }
        
        infoLb.numberOfLines = 3
        infoLb.textAlignment = .right
        
        articleTv.snp.makeConstraints { (make) in
            make.leading.equalTo(15)
            make.top.equalTo(infoLb.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        articleTv.isScrollEnabled = false
        articleTv.isEditable = false
        articleTv.isSelectable = false
        articleTv.backgroundColor = .basicBackground
        
        underLine2.snp.makeConstraints { (make) in
            make.top.equalTo(articleTv.snp.bottom).offset(20)
            make.leading.equalTo(15)
            make.height.equalTo(1.5)
            make.centerX.equalToSuperview()
        }
        
        commentTitleLb.snp.makeConstraints { (make) in
            make.leading.equalTo(15)
            make.top.equalTo(underLine2.snp.bottom).offset(20)
            //            make.width.equalTo(120)
            make.height.equalTo(19)
        }
        commentTitleLb.attributedText = "COMMENT".localized.makeAttrString(font: .NotoSans(.bold, size: 16), color: .black)
        commentTitleLb.adjustsFontSizeToFitWidth = true
        thumbImgView.snp.makeConstraints { (make) in
            make.centerY.equalTo(commentTitleLb.snp.centerY).offset(-2)
            make.leading.equalTo(commentTitleLb.snp.trailing).offset(10)
            make.width.height.equalTo(19)
        }
        thumbImgView.image = UIImage.init(named: "thumbUp")
        
        commentProfileImv.snp.makeConstraints { (make) in
            make.leading.equalTo(15)
            make.top.equalTo(commentTitleLb.snp.bottom).offset(15)
            make.width.height.equalTo(50)
        }
        
        commentProfileImv.image = UIImage.init(named: "commentProfile")
        
        commentTv.isScrollEnabled = false
        commentTv.isEditable = false
        commentTv.isSelectable = false
        commentTv.backgroundColor = .basicBackground
        
        commentTv.snp.makeConstraints { (make) in
            make.top.equalTo(commentProfileImv.snp.top)
            make.leading.equalTo(commentProfileImv.snp.trailing).offset(15)
            make.trailing.equalTo(-10)
            make.bottom.equalTo(-10)
        }
        
        imageContainerView.addSubview(imageCollectionView)
        imageCollectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        imageCollectionView.isPagingEnabled = true
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        imageCollectionView.register(CompleteThumnailImageCell.self, forCellWithReuseIdentifier: "CompleteThumnailImageCell")
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CompletedArticleView:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CompleteThumnailImageCell", for: indexPath) as? CompleteThumnailImageCell {
            
            cell.imv.image = UIImage.init(contentsOfFile: images[indexPath.row])
//            cell.imv.image = UIImage.init(contentsOfFile: images[indexPath.row])
            return cell
            
        }else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        return CGSize.init(width: self.imageCollectionView.bounds.width - 1, height: self.imageCollectionView.bounds.height)
        
    }
    
}


class CompleteThumnailImageCell:UICollectionViewCell {
    
    let imv = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(imv)
        imv.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func setData(imageUrl:URL) {
        
        self.imv.kf.setImage(with: imageUrl, placeholder: UIImage(), options: nil, progressBlock: nil, completionHandler: nil)
        
    }
    
//    collec
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
