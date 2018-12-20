//
//  CompleteArticleViewController.swift
//  WallPeckers
//
//  Created by Seongchan Kang on 17/12/2018.
//  Copyright © 2018 KimJimin and Company. All rights reserved.
//

import UIKit
import AloeStackView

class CompleteArticleViewController: GameTransitionBaseViewController, UIScrollViewDelegate {
    
    var bottomReached:Bool = false
    var topReached:Bool = false
    var article:Article?
    var hashTag:Int?
    var wrongIds:[Int] = []
    let aStackView = AloeStackView()
    let okButton = BottomButton()
    let titleLb = UILabel()
    var fromMyPage:Bool?
    let completeArticleView = CompletedArticleView()
    let deskView = DeskBubbleView()
    let hashView = HashTagGraphView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        
        if let _hash = hashTag, let _article = article {
            
            if let a = article?.hashes?.components(separatedBy: "/") {

                let ints = a.map({
                    
                    Int($0)!
                })
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
                    self.hashView.startAnimation(heights: ints)
                }
                
                for i in 0...ints.count - 1 {
                    
                    if let gps = self.hashView.subviews.filter({
                        
                        $0 is GraphView
                    }) as? [GraphView] {
                        
                        _ = gps.map({
                            if $0.tag == i {
                                $0.initData(percent: ints[i], myTag: _hash)
                            }
                            
                        })
                    }
                
                }
                
            }
            
            completeArticleView.setData(article: _article, wrongClue: wrongIds, region: _article.region!)
            aStackView.addRow(titleLb)
            aStackView.addRow(completeArticleView)
            aStackView.delegate = self
            
            if wrongIds.count > 0 {
                aStackView.addRow(deskView)
                deskView.setDataForCompleteArticle(region: _article.region!, desc: "some of the articles")
            }
            aStackView.addRow(hashView)
            aStackView.addRow(okButton)
        }
        
    }
    
    private func setUI() {
        
        self.view.backgroundColor = .basicBackground
        self.view.addSubview(aStackView)
        aStackView.backgroundColor = .basicBackground
        aStackView.snp.makeConstraints { (make) in
        
            if let _ = fromMyPage {
                make.top.equalTo(view.safeArea.top).offset(10)
            }else{
                make.top.equalTo(view.safeArea.top).offset(60)
            }
            
            make.bottom.equalTo(view.safeArea.bottom).offset(-40)
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            
        }
        
        titleLb.attributedText = "COMPLETED ARTICLE".makeAttrString(font: .NotoSans(.medium, size: 25), color: .black)
        titleLb.textAlignment = .center
        okButton.addTarget(self, action: #selector(moveToBack(sender:)), for: .touchUpInside)
    }
    
    @objc func moveToBack(sender:UIButton) {
        
        if let _ = fromMyPage {
            self.navigationController?.popViewController(animated: true)
        }else{
            guard let vc = self.findBeforeVc(type: .topic) else {return}
            delegate?.moveTo(fromVc: self, toVc: vc, sendData: nil, direction: .backward)
        }
    }

    func setData(article:Article, hashTag:Int, wrongIds:[Int]) {
        
        self.article = article
        self.hashTag = hashTag
        self.wrongIds = wrongIds
   
    }
    
    func hashTagGraphAnimation() {
        if let _hash = hashTag, let _article = article {
            
            if let a = _article.hashes?.components(separatedBy: "/") {
                
                let ints = a.map({Int($0)!})
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
                    self.hashView.startAnimation(heights: ints)
                }
                for i in 0...ints.count - 1 {
                    
                    if let gps = self.hashView.subviews.filter({$0 is GraphView}) as? [GraphView] {
                        
                        _ = gps.map({
                            if $0.tag == i {
                                $0.initData(percent: ints[i], myTag: _hash)
                            }
                        })
                    }
                }
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y + 1) >= (scrollView.contentSize.height - scrollView.frame.size.height) {
            //reach bottom
            if !bottomReached {
                bottomReached = true
                topReached = false
                print("BOTOM!")
                self.hashTagGraphAnimation()
                
            }
        }
        
        if (scrollView.contentOffset.y <= 0){
            if !topReached {
                topReached = true
                bottomReached = false
                self.hashView.initAnimation()
            }
        }
        
        if (scrollView.contentOffset.y > 0 && scrollView.contentOffset.y < (scrollView.contentSize.height - scrollView.frame.size.height)){
            //not top and not bottom
        }
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
    let dFormatter = DateFormatter()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    func setData(article:Article, wrongClue:[Int], region:String) {
        
        dFormatter.dateFormat = "mm.dd.yyyy"
        
        let dString = dFormatter.string(from: Date()).makeAttrString(font: .NotoSans(.medium, size: 19), color: .black)
        let infoAString = "".makeAttrString(font: .NotoSans(.medium, size: 19), color: .black)
        let regionString = region == "GERMANY" ? "at the Berlin Wall" : "at the DMZ"
        let userNameString = "by \(RealmUser.shared.getUserData()?.name! ?? "User")"
        infoAString.append(dString)
        infoAString.append("\n\(regionString)".makeAttrString(font: .NotoSans(.medium, size: 19), color: .black))
        infoAString.append("\n\(userNameString)".makeAttrString(font: .NotoSans(.medium, size: 19), color: .black))
        
        infoLb.attributedText = infoAString
        
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

class HashTagGraphView:UIView {
    
    let titleLb = UILabel()
    let underLine1 = UIView()
    let firstView = GraphView()
    let secondView = GraphView()
    let thirdView = GraphView()
    let fourthView = GraphView()
    let fifthView = GraphView()
    let underLine2 = UIView()
    let hashTitleLb1 = UILabel()
    let hashTitleLb2 = UILabel()
    let hashTitleLb3 = UILabel()
    let hashTitleLb4 = UILabel()
    let hashTitleLb5 = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    func setUI() {
        
        firstView.tag = 0
        secondView.tag = 1
        thirdView.tag = 2
        fourthView.tag = 3
        fifthView.tag = 4
        
        self.setBorder(color: .black, width: 1.5)
        self.addSubview([titleLb, underLine1, underLine2, firstView, secondView, thirdView, fourthView, fifthView])
        
        titleLb.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(20)
        }
        titleLb.attributedText = "HASHTAG".makeAttrString(font: .NotoSans(.bold, size: 18), color: .black)
        
        underLine1.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.leading.equalTo(5)
            make.top.equalTo(titleLb.snp.bottom).offset(10)
            make.height.equalTo(1.5)
        }
        
        underLine2.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(2)
            make.bottom.equalTo(-40)
        }
        underLine2.backgroundColor = .black
        underLine1.backgroundColor = .black
        
        firstView.snp.makeConstraints { (make) in

            make.leading.equalTo(underLine2.snp.leading)
            make.bottom.equalTo(underLine2.snp.top).offset(1)
            make.width.equalTo(underLine2.snp.width).multipliedBy(0.2)
            make.height.equalTo(180)
            make.top.equalTo(underLine1.snp.bottom).offset(20)
//            make.top.equalToSuperview()
        }
        secondView.snp.makeConstraints { (make) in
            make.leading.equalTo(firstView.snp.trailing)
            make.bottom.equalTo(underLine2.snp.top).offset(1)
            make.width.equalTo(underLine2.snp.width).multipliedBy(0.2)
            make.height.equalTo(180)
            make.top.equalTo(underLine1.snp.bottom).offset(20)

        }
        thirdView.snp.makeConstraints { (make) in
            make.leading.equalTo(secondView.snp.trailing)
            make.bottom.equalTo(underLine2.snp.top).offset(1)
            make.width.equalTo(underLine2.snp.width).multipliedBy(0.2)
            make.height.equalTo(180)
            make.top.equalTo(underLine1.snp.bottom).offset(20)

        }
        fourthView.snp.makeConstraints { (make) in
            make.leading.equalTo(thirdView.snp.trailing)
            make.bottom.equalTo(underLine2.snp.top).offset(1)
            make.width.equalTo(underLine2.snp.width).multipliedBy(0.2)
            make.height.equalTo(180)
            make.top.equalTo(underLine1.snp.bottom).offset(20)

        }
        fifthView.snp.makeConstraints { (make) in
            make.top.equalTo(underLine1.snp.bottom).offset(20)
            make.leading.equalTo(fourthView.snp.trailing)
            make.bottom.equalTo(underLine2.snp.top).offset(1)
            make.width.equalTo(underLine2.snp.width).multipliedBy(0.2)
            make.height.equalTo(180)
        }

    }
    
    func initAnimation() {
        for i in [firstView, secondView, thirdView, fourthView, fifthView] {
            
            i.graphV.snp.updateConstraints { (make) in
                make.height.equalTo(0)
            }
            self.layoutIfNeeded()
        }
    }
    
    func startAnimation(heights:[Int]) {
        

    
        UIView.animate(withDuration: 5) {
            self.firstView.graphV.snp.updateConstraints { (make) in
                make.height.equalTo(heights[0])
            }
            
            self.secondView.graphV.snp.updateConstraints { (make) in
                make.height.equalTo(heights[1])
            }
            
            self.thirdView.graphV.snp.updateConstraints { (make) in
                make.height.equalTo(heights[2])
            }
            
            self.fourthView.graphV.snp.updateConstraints { (make) in
                make.height.equalTo(heights[3])
            }
            
            self.fifthView.graphV.snp.updateConstraints { (make) in
                make.height.equalTo(heights[4])
            }
 
            self.layoutIfNeeded()
        }

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class GraphView:UIView {
    
    let titleLb = UILabel()
    let percentLb = UILabel()
    let graphV = UIView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    func initData(percent:Int, myTag:Int) {
        
        self.percentLb.text = "\(percent)"
        self.titleLb.text = ""
        self.titleLb.adjustsFontSizeToFitWidth = true
        self.titleLb.numberOfLines = 0
        self.titleLb.textAlignment = .center
        
        if self.tag == myTag {
            self.graphV.backgroundColor = .sunnyYellow
            self.titleLb.text = "My Tag"
        }else{
            self.graphV.backgroundColor = .white
        }
        
        if percent == 100 {
            if self.titleLb.text != "" {
                self.titleLb.text?.append("\nMostWanted")

            }else{
                self.titleLb.text?.append("MostWanted")

            }
        }
    }
    
    private func setUI() {
        self.addSubview([titleLb, percentLb, graphV])
        
        graphV.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.7)
            make.centerX.equalToSuperview()
            make.height.equalTo(0)
        }
        graphV.setBorder(color: .black, width: 1.5)
        graphV.backgroundColor = .white
        
        percentLb.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.height.equalTo(20)
            make.bottom.equalTo(graphV.snp.top).offset(-5)
        }
        titleLb.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.height.equalTo(20)
            make.bottom.equalTo(percentLb.snp.top).offset(-5)
        }

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
