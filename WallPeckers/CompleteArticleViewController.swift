//
//  CompleteArticleViewController.swift
//  WallPeckers
//
//  Created by Seongchan Kang on 17/12/2018.
//  Copyright © 2018 KimJimin and Company. All rights reserved.
//

import UIKit
import AloeStackView

class CompleteArticleViewController: GameTransitionBaseViewController {
    
    var article:Article?
    var hashTag:Int?
    var wrongIds:[Int] = []
    let aStackView = AloeStackView()
    let okButton = BottomButton()
    let titleLb = UILabel()
    
    let completeArticleView = CompletedArticleView()
    let deskView = DeskBubbleView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        
        if let _hash = hashTag, let _article = article {
            print(_hash, "_HASH")
            
            
            completeArticleView.setData(article: _article, wrongClue: wrongIds)
            
            aStackView.addRow(titleLb)
            aStackView.addRow(completeArticleView)
            
            
            if wrongIds.count > 0 {
                aStackView.addRow(deskView)
                deskView.setDataForCompleteArticle(region: _article.region!, desc: "some of the articles")
            }
            
            aStackView.addRow(okButton)
            
        }
        
    }
    
    func setUI() {
        
        self.view.backgroundColor = .basicBackground
        self.view.addSubview(aStackView)
        aStackView.backgroundColor = .basicBackground
        
        aStackView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeArea.top).offset(60)
            make.bottom.equalTo(view.safeArea.bottom).offset(-40)
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            
        }
        
        titleLb.text = "COMPLETED ARTICLE"
        
        okButton.addTarget(self, action: #selector(moveToBack(sender:)), for: .touchUpInside)
        
    }
    
    @objc func moveToBack(sender:UIButton) {
        
        
        guard let vc = self.findBeforeVc(type: .topic) else {return}
        
        delegate?.moveTo(fromVc: self, toVc: vc, sendData: nil, direction: .backward)
    }
    
    
    
    func setData(article:Article, hashTag:Int, wrongIds:[Int]) {
        
        self.article = article
        self.hashTag = hashTag
        self.wrongIds = wrongIds
        print(wrongIds)
        print("~~~~")
    }
    
}

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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    func setData(article:Article, wrongClue:[Int]) {
        
        let articleString:NSMutableAttributedString = "".makeAttrString(font: .NotoSans(.medium, size: 12), color: .black)

        
        for clue in article.clues {
            
            if let a = RealmClue.shared.getLocalClue(id: clue, language: Standard.shared.getLocalized()) {
    
                if wrongClue.count > 0 {
                    
                    
                    for wrong in wrongClue {
                        if a.id == wrong {
                            articleString.append(("\(a.desc!) ".makeAttrString(font: .NotoSans(.medium, size: 19), color: .blue)))
                            
                        }else{
                            articleString.append(("\(a.desc!) ".makeAttrString(font: .NotoSans(.medium, size: 19), color: .black)))
                            
                        }
                    }
                    
                }else{
                    articleString.append(("\(a.desc!) ".makeAttrString(font: .NotoSans(.medium, size: 19), color: .black)))
                    
                }
            }
        }
        
        
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
        underLine1.backgroundColor = .black
        underLine2.backgroundColor = .black
        
        imageContainerView.snp.makeConstraints { (make) in
            make.leading.equalTo(15)
            make.centerX.equalToSuperview()
            make.top.equalTo(underLine1.snp.bottom).offset(20)
            make.height.equalTo(190)
        }
        infoLb.snp.makeConstraints { (make) in
            make.trailing.equalTo(-15)
            make.top.equalTo(imageContainerView.snp.bottom).offset(10)
            make.leading.equalTo(15)
            make.height.equalTo(60)
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
            make.width.equalTo(100)
        }
        commentTitleLb.attributedText = "COMMENT".makeAttrString(font: .NotoSans(.bold, size: 16), color: .black)
        
        thumbImgView.snp.makeConstraints { (make) in
            make.centerY.equalTo(commentTitleLb.snp.centerY)
            make.leading.equalTo(commentTitleLb.snp.trailing)
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
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
