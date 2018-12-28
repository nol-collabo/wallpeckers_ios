//
//  ArticleView.swift
//  WallPeckers
//
//  Created by Seongchan Kang on 28/12/2018.
//  Copyright © 2018 KimJimin and Company. All rights reserved.
//

import Foundation
import UIKit


final class ArticleView:UIView {
    
    let pathLb = UILabel()
    let pointLb = UILabel()
    let titleLb = UILabel()
    let descLb = UILabel()
    let articleImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    func setData(article:Article, point:String) {
        
        
        
        var section = ""
        
        switch article.section {
            
        case 1:
            section = "Politics".localized
        case 2:
            section = "Economy".localized
            
        case 3:
            section = "General".localized
            
        case 4:
            section = "Art".localized
            
        case 5:
            section = "Sports".localized
            
        case 6:
            section = "People".localized
            
        default:
            break
            
        }
        
        pathLb.attributedText = "\(section) > \(article.word!)".makeAttrString(font: .NotoSans(.medium, size: 12), color: .black)
        pointLb.attributedText = "\(point)".makeAttrString(font: .NotoSans(.medium, size: 12), color: .black)
        titleLb.attributedText = article.title?.makeAttrString(font: .NotoSans(.bold, size: 20), color: .black)
        descLb.attributedText = article.title_sub?.makeAttrString(font: .NotoSans(.bold, size: 15), color: .black)
        articleImageView.image = UIImage.init(named: "image_article_0\(article.id)")
        //        articleImageView.backgroundColor = .blue
    }
    
    func forFactCheck() {
        articleImageView.isHidden = true
        descLb.snp.remakeConstraints { (make) in
            make.top.equalTo(titleLb.snp.bottom).offset(5)
            make.leading.equalTo(titleLb.snp.leading)
            make.trailing.equalTo(-5)
            make.bottom.equalToSuperview()
        }
    }
    
    private func setUI() {
        
        self.addSubview([pathLb, pointLb, titleLb, descLb, articleImageView])
        
        pathLb.snp.makeConstraints { (make) in
            make.top.leading.equalTo(5)
            //            make.width.equalTo(120)
            make.height.equalTo(30)
        }
        pointLb.snp.makeConstraints { (make) in
            make.trailing.equalTo(-10)
            make.centerY.equalTo(pathLb.snp.centerY)
            make.height.equalTo(30)
            
        }
        titleLb.snp.makeConstraints { (make) in
            make.top.equalTo(pathLb.snp.bottom).offset(5)
            make.leading.equalTo(pathLb.snp.leading)
            make.trailing.equalTo(-10)
            //            make.height.equalTo(50)
        }
        titleLb.numberOfLines = 0
        descLb.snp.makeConstraints { (make) in
            make.top.equalTo(titleLb.snp.bottom).offset(5)
            make.leading.equalTo(titleLb.snp.leading)
            make.trailing.equalTo(-5)
        }
        descLb.numberOfLines = 0
        
        articleImageView.snp.makeConstraints { (make) in
            make.leading.equalTo(titleLb.snp.leading)
            make.top.equalTo(descLb.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(190)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
