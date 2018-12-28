//
//  MyPageViewController.swift
//  WallPeckers
//
//  Created by Seongchan Kang on 03/12/2018.
//  Copyright © 2018 KimJimin and Company. All rights reserved.
//

import UIKit
import SnapKit
import AloeStackView
import Photos

class MyPageViewController: UIViewController, SectionViewDelegate, PublishDelegate {
    func moveToNext(sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
//        guard let vc = UIStoryboard.init(name: "Publish", bundle: nil).instantiateViewController(withIdentifier: "Publish") as? UINavigationController else {return}
//
//        self.present(vc, animated: true, completion: nil)
    }
    
    func moveToCompleteArticle(id: Int) {
        
        guard let vc = UIStoryboard.init(name: "Game", bundle: nil).instantiateViewController(withIdentifier: "CompleteArticleViewController") as? CompleteArticleViewController else {return}
        
        if let ar = RealmArticle.shared.get(Standard.shared.getLocalized()).filter({
            
            $0.id == id
        }).first {
            vc.setData(article: ar, hashTag: ar.selectedHashtag, wrongIds: Array(ar.wrongQuestionsId))
            vc.fromMyPage = true
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    let imagePicker = UIImagePickerController()
    let publishView = NewspaperPublishedView()
    var completedArticle: [Article]?
    var credibility: Int?
    var myLevel: Int?
    var completedBadges: [Int] = []
    var currentPoint: Int? // 내 점수
    let profileBaseView = UIView()
    let dismissBtn = UIButton()
    let profileView = MyProfileView()
    let scoreView = MyPageSectionView()
    let levelView = MyPageSectionView()
    let badgeView = MyPageSectionView()
    let credView = MyPageSectionView()
    let completedArticleView = MyPageSectionView()
    let aStackView = AloeStackView()
    var fromResult:Bool = false
    var titleLb = UILabel()
    let selectedLanguage = Standard.shared.getLocalized()
    let keyboardResigner = UITapGestureRecognizer()

    
    @objc func keyboardResign() {

        profileView.nameTf.resignFirstResponder()

    }
    
    func isBadge(tag:Int) -> Bool {
        
        return RealmArticle.shared.get(selectedLanguage).filter({$0.section == tag}).filter({$0.isCompleted}).count == 9
        
    }
    
    func addBadge(tag:Int) {
        if isBadge(tag: tag) {
            if !completedBadges.contains(tag) {
                completedBadges.append(tag)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scoreView.delegate = self
        badgeView.delegate = self
        levelView.delegate = self
        profileView.delegate = self
        keyboardResigner.addTarget(self, action: #selector(keyboardResign))
        self.view.addGestureRecognizer(keyboardResigner)

        //내 점수
        currentPoint = RealmUser.shared.getUserData()?.score
        myLevel = 10
        
        if let _currentPoint = currentPoint {
            if _currentPoint > 0 {
                credView.delegate = self
                completedArticleView.delegate = self
            }
        }

       completedArticle = RealmArticle.shared.get(Standard.shared.getLocalized()).filter({
            
            $0.isCompleted
        })
        

        if let corec = completedArticle?.map({Double($0.correctQuestionCount)}), let total = completedArticle?.map({Double($0.totalQuestionCount)}) {
            
            if corec.count > 0 {
                credibility = Int((corec.reduce(0, +) / total.reduce(0, +)) * 100)
            }
        }
        
        for i in 1...6 {
            addBadge(tag: i)
        }

        setUI()

    }
    
    func setUI() {
        self.navigationController?.isNavigationBarHidden = true
        view.addSubview(aStackView)
        view.addSubview(dismissBtn)
        view.addSubview(titleLb)
        view.backgroundColor = .basicBackground
        
        dismissBtn.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeArea.top)
            make.trailing.equalToSuperview()
            make.width.height.equalTo(40)
        }
        
        titleLb.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(dismissBtn.snp.centerY).offset(10)
        }
        
        titleLb.attributedText = "MY_PAGE".localized.makeAttrString(font: .NotoSans(NotoSansFontSize.medium, size: 25), color: .black)
        dismissBtn.setImage(UIImage.init(named: "dismissButton")!, for: .normal)
        aStackView.snp.makeConstraints { (make) in
           make.top.equalTo(dismissBtn.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeArea.bottom)
        }
        scoreView.setData(content: .Score)
        levelView.setData(content: .Level)
        badgeView.setData(content: .Badge)
        
        aStackView.addRow(profileBaseView)
        
        if let _count = completedArticle?.count {
            if _count > 0 {
                if fromResult {
                    aStackView.addRow(publishView)
                    publishView.snp.makeConstraints { (make) in
                        make.edges.equalToSuperview()
                        make.height.equalTo(320)
                    }
                    publishView.delegate = self
                }
            }
        }
        
        aStackView.addRow(scoreView)
        profileBaseView.addSubview(profileView)
 
        profileView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(DEVICEHEIGHT > 600 ? 42 : 32)
            make.height.equalTo(DEVICEHEIGHT > 600 ? 360 : 290)

        }
        
        profileView.setData(userData: RealmUser.shared.getUserData()!, level: RealmUser.shared.getUserLevel(), camera: true, nameEdit: true, myPage: false)
        
        
        //완료된 거 없으면 히든처리할 놈들
        
        if let _completedArticle = completedArticle {
            
            if _completedArticle.count > 0 {
                
                credView.setData(content: .CREDIBILITY)
                completedArticleView.setData(content: .COMPLETEDARTICLE)
                aStackView.addRows([credView, completedArticleView])
            }
        }
       
        

        //엔딩페이지에서만 보이는 신문
        
        aStackView.addRows([levelView, badgeView])
        
        aStackView.backgroundColor = .basicBackground


        dismissBtn.addTarget(self, action: #selector(dismissTouched(sender:)), for: .touchUpInside)

    }
    
    @objc func dismissTouched(sender:UIButton) {
        sender.isUserInteractionEnabled = false
        self.dismiss(animated: true) {
            sender.isUserInteractionEnabled = true
        }
    }
}

extension MyPageViewController:MyPageDelegate {
    
    
    func isbecomeKeyboard(sender: UITextField) {
        UIView.animate(withDuration: 0.2) {
            self.view.center = .init(x: self.view.center.x, y: self.view.center.y - 80)
        }
    }
    
    func isresignKeyboard(sender: UITextField) {
        UIView.animate(withDuration: 0.2) {
            self.view.center = .init(x: self.view.center.x, y: self.view.center.y + 80)
        }
        
        try! realm.write {
            RealmUser.shared.getUserData()?.name = sender.text
        }
    }
    
    func callProfileImageOption(sender: UIButton) {
        print("HERE!")
        
        imagePicker.delegate = self
        PopUp.call(mainTitle: "registrationdialog_title".localized, selectButtonTitles: ["registrationdialog_camera".localized, "registrationdialog_album".localized, "registrationdialog_noprofile".localized], bottomButtonTitle: "CANCEL".localized, bottomButtonType: 0, self, buttonImages: nil)
        
    }
    
}

extension MyPageViewController:UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            try! realm.write {
                RealmUser.shared.getUserData()?.profileImage = image.jpegData(compressionQuality: 0.5)
            }
            
            profileView.profileImageView.image = image
        }
        
        
        picker.dismiss(animated: true, completion: nil)
    }
}

extension MyPageViewController:SelectPopupDelegate {
    func bottomButtonTouched(sender: UIButton) {
        
        self.removePopUpView()
        
    }
    
    func checkPermission() {
        
        
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            print("Access is granted by user")
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({
                (newStatus) in
                print("status is \(newStatus)")
                if newStatus ==  PHAuthorizationStatus.authorized {
                    /* do stuff here */
                    
                    print("success")
                }
            })
            print("It is not determined until now")
        case .restricted:
            // same same
            
            print("User do not have access to photo album.")
        case .denied:
            // same same
            
            print("User has denied the permission.")
        }
    }
    
    func selectButtonTouched(tag: Int) {
        
        switch tag {
        case 0:
            imagePicker.sourceType = .camera
            checkPermission()
            //            checkPermission { (result) in
            //                if result == "authorized" {
            self.present(self.imagePicker, animated: true, completion: nil)
            //                }
        //            }
        case 1:
            imagePicker.sourceType = .photoLibrary
            checkPermission()
            
            //            checkPermission { (result) in
            //                if result == "authorized" {
            self.present(self.imagePicker, animated: true, completion: nil)
            //                }
        //            }
        case 2:
            print("DEFAULT")
        default:
            break
        }
        
        self.removePopUpView()
        
        //        print(tag)
    }
    
    
}



class MyPageSectionView:UIView, ThumnailDelegate {
    func moveToNext(id: Int) {
        delegate?.moveToCompleteArticle(id: id)
    }
    private let titleLb = UILabel()
    private let contentView = UIView()
    var delegate:SectionViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    private func setUI() {
        contentView.accessibilityIdentifier = "ContentView"
        self.addSubview([titleLb, contentView])
        titleLb.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.leading.equalTo(10)
            make.top.equalTo(10)
            make.height.equalTo(40)
        }
        titleLb.addUnderBar()
        self.setBorder(color: .black, width: 1.5)
        contentView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLb.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func setData(content:ContentType) {
        
        titleLb.setNotoText(content.rawValue.localized, color: .black, size: 20, textAlignment: .center)

        switch content {
            
        case .Badge:
            
            let firstRowStackView = UIStackView()
            let secondRowStackView = UIStackView()
            let politicBadgeV = BadgeView()
            let economyBadgeV = BadgeView()
            let generalBadgeV = BadgeView()
            let artBadgeV = BadgeView()
            let sportsBadgeV = BadgeView()
            let peopleBadgeV = BadgeView()

            _ = [politicBadgeV, economyBadgeV, generalBadgeV].map({firstRowStackView.addArrangedSubview($0)})
            _ = [artBadgeV, sportsBadgeV, peopleBadgeV].map({secondRowStackView.addArrangedSubview($0)})
            
            self.contentView.addSubview([firstRowStackView, secondRowStackView])
            
            firstRowStackView.snp.makeConstraints { (make) in
                make.top.equalToSuperview()
                make.leading.equalTo(10)
                make.trailing.equalTo(-10)
                make.height.equalTo(110)
            }
            secondRowStackView.snp.makeConstraints { (make) in
                make.leading.equalTo(10)
                make.trailing.equalTo(-10)
                make.bottom.equalTo(-10)
                make.height.equalTo(110)
                make.top.equalTo(firstRowStackView.snp.bottom).offset(15)
            }
            firstRowStackView.axis = .horizontal
            secondRowStackView.axis = .horizontal
            firstRowStackView.distribution = .fillEqually
            secondRowStackView.distribution = .fillEqually
            firstRowStackView.spacing = 15
            secondRowStackView.spacing = 15
            
            if let _ = delegate?.completedBadges.filter({$0 == 1}).first {
                politicBadgeV.setData(badgeImage: "politicBadge", badgeTitle: "Politics".localized, tag: 1, isCompleted: true)

            }else{
                politicBadgeV.setData(badgeImage: "politicBadge", badgeTitle: "Politics".localized, tag: 1)
            }
            
            if let _ = delegate?.completedBadges.filter({$0 == 2}).first {
                economyBadgeV.setData(badgeImage: "economyBadge", badgeTitle: "Economy".localized, tag: 2, isCompleted: true)

            }else{
                economyBadgeV.setData(badgeImage: "economyBadge", badgeTitle: "Economy".localized, tag: 2)
            }
            
            if let _ = delegate?.completedBadges.filter({$0 == 3}).first {
                generalBadgeV.setData(badgeImage: "generalBadge", badgeTitle: "General".localized, tag: 3, isCompleted: true)

            }else{
                generalBadgeV.setData(badgeImage: "generalBadge", badgeTitle: "General".localized, tag: 3)
            }
            
            if let _ = delegate?.completedBadges.filter({$0 == 4}).first {
                artBadgeV.setData(badgeImage: "artcultureBadge", badgeTitle: "Art".localized, tag: 4, isCompleted: true)
            }else{
                artBadgeV.setData(badgeImage: "artcultureBadge", badgeTitle: "Art".localized, tag: 4)
            }
            if let _ = delegate?.completedBadges.filter({$0 == 5}).first {
                sportsBadgeV.setData(badgeImage: "sportsBadge", badgeTitle: "Sports".localized, tag: 5, isCompleted: true)
            }else{
                sportsBadgeV.setData(badgeImage: "sportsBadge", badgeTitle: "Sports".localized, tag: 5)
            }

            if let _ = delegate?.completedBadges.filter({$0 == 6}).first {
                peopleBadgeV.setData(badgeImage: "peopleBadge", badgeTitle: "People".localized, tag: 6, isCompleted: true)
            }else{
                peopleBadgeV.setData(badgeImage: "peopleBadge", badgeTitle: "People".localized, tag: 6)

            }

        case .Level:
            
            guard let myLevel = delegate?.myLevel else {return}
            let baseView = UIView()
            let levelImageView = UIImageView()
            let position1Lb = UILabel()
            let position2Lb = UILabel()
            let position3Lb = UILabel()
            let position4Lb = UILabel()
            let position5Lb = UILabel()
            
            self.contentView.addSubview(baseView)
            
            baseView.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
            baseView.addSubview([levelImageView, position1Lb, position2Lb, position3Lb, position4Lb, position5Lb])
            
            levelImageView.snp.makeConstraints { (make) in
                make.top.equalToSuperview().offset(10)
                make.width.equalTo(280)
                make.height.equalTo(130)
                make.centerX.equalToSuperview()
                make.bottom.equalTo(-30)
            }
            
            position1Lb.snp.makeConstraints { (make) in
                make.leading.equalTo(levelImageView.snp.leading)
                make.top.equalTo(levelImageView.snp.bottom)
                make.width.equalTo(45)
            }
            
            position2Lb.snp.makeConstraints { (make) in
                make.leading.equalTo(position1Lb.snp.trailing).offset(0)
                make.top.equalTo(levelImageView.snp.bottom).offset(-20)
                make.width.equalTo(70)

            }
            position3Lb.snp.makeConstraints { (make) in

                make.centerX.equalTo(levelImageView.snp.centerX).offset(-3)
                make.top.equalTo(levelImageView.snp.bottom).offset(-45)
                make.width.equalTo(66)
            }
            position4Lb.snp.makeConstraints { (make) in
                make.leading.equalTo(position3Lb.snp.trailing).offset(0)
                make.top.equalTo(levelImageView.snp.bottom).offset(-65)
                make.width.equalTo(66)
            }
            position5Lb.snp.makeConstraints { (make) in
                make.trailing.equalTo(levelImageView.snp.trailing).offset(-3)
                make.top.equalTo(levelImageView.snp.bottom).offset(-90)
                make.width.equalTo(66)
            }
         
    
            
            let levels = RealmLevel.shared.get(Standard.shared.getLocalized()).sorted(by: {$0.id < $1.id})

            position1Lb.setAmericanTyperWriterText(levels[0].grade!, color: .brownGrey, size: 12, textAlignment: .center, font: .bold)
            position2Lb.setAmericanTyperWriterText(levels[1].grade!, color: .brownGrey, size: 12, textAlignment: .center, font: .bold)
            position3Lb.setAmericanTyperWriterText(levels[2].grade!, color: .brownGrey, size: 12, textAlignment: .center, font: .bold)
            position4Lb.setAmericanTyperWriterText(levels[3].grade!, color: .brownGrey, size: 12, textAlignment: .center, font: .bold)
            position5Lb.setAmericanTyperWriterText(levels[4].grade!, color: .brownGrey, size: 12, textAlignment: .center, font: .bold)

            for i in [position1Lb, position2Lb, position3Lb, position4Lb, position5Lb] {
                i.numberOfLines = 2
                i.adjustsFontSizeToFitWidth = true
            }
            
            levelImageView.contentMode = .scaleAspectFit
            

            
            if let myScore = RealmUser.shared.getUserData()?.score {
                
                if myScore < 2000 {
                    levelImageView.image = UIImage.init(named: "levelRe45")
                    position1Lb.textColor = .black
                }else if myScore < 4000 {
                    levelImageView.image = UIImage.init(named: "levelRe46")
                    position2Lb.textColor = .black

                }else if myScore < 8000 {
                    levelImageView.image = UIImage.init(named: "levelRe47")
                    position3Lb.textColor = .black

                }else if myScore < 12000 {
                    levelImageView.image = UIImage.init(named: "levelRe48")
                    position4Lb.textColor = .black

                }else{
                    levelImageView.image = UIImage.init(named: "levelRe49")
                    position5Lb.textColor = .black

                }

            }
            
            print(myLevel)
            
            
            
            
        case .Score:
            
            let starImv = UIImageView.init(image: UIImage.init(named: "ArticleStar")!)
            let pointLb = UILabel()
            
            self.contentView.addSubview([starImv, pointLb])
            
            starImv.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview().offset(-60)
                make.width.height.equalTo(45)
                make.top.equalTo(10)
                make.bottom.equalTo(-26)
            }
            pointLb.snp.makeConstraints { (make) in
                make.leading.equalTo(starImv.snp.trailing).offset(10)
                make.centerY.equalTo(starImv.snp.centerY)
            }
        
            guard let point = delegate?.currentPoint else {return}
            pointLb.attributedText = "\(point)P".makeAttrString(font: .NotoSans(.bold, size: 28), color: .black)
            pointLb.accessibilityIdentifier = "point"
            
        case .CREDIBILITY:
            print("XX")
            let emptyView = UIView()
            let fulfillView = UIView()
            let percentLb = UILabel()
            guard let percent = delegate?.credibility else {return}
            
            self.contentView.addSubview([emptyView, fulfillView, percentLb])

            emptyView.snp.makeConstraints { (make) in

                make.top.equalTo(10)
                make.height.equalTo(34)
                make.width.equalTo(240)
                make.bottom.equalTo(-20)
                make.centerX.equalToSuperview()
            }
            
            fulfillView.snp.makeConstraints { (make) in
                make.leading.bottom.top.equalTo(emptyView)
                make.width.equalTo(240 * Double(Double(percent) / 100))
            }
            emptyView.setBorder(color: .black, width: 1.5)
            emptyView.backgroundColor = .white
            fulfillView.setBorder(color: .black, width: 1.5)
            
            fulfillView.backgroundColor = .sunnyYellow
            
            percentLb.snp.makeConstraints { (make) in
                make.center.equalTo(emptyView.snp.center)
            }
            percentLb.attributedText = "\(percent)%".makeAttrString(font: UIFont.NotoSans(.bold, size: 16), color: .black)
            

            
        case .COMPLETEDARTICLE:
            
            
            let articleStackView = AloeStackView()
            articleStackView.backgroundColor = .basicBackground
            articleStackView.separatorHeight = 0
            self.contentView.addSubview(articleStackView)
           
            
            guard let completedArticle = delegate?.completedArticle else {return}
            
            for i in 0...completedArticle.count - 1 {
                
                let vv = CompleteArticleThumnailView()
                vv.delegate = self
                vv.setData(article: completedArticle[i])
                articleStackView.addRow(vv)
                self.layoutIfNeeded()
            }
            articleStackView.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
                make.height.equalTo(150 * completedArticle.count)
            }
            self.layoutIfNeeded()
            self.layoutSubviews()
            articleStackView.isScrollEnabled = false
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

protocol SectionViewDelegate {
    
    var currentPoint:Int? { get set }
    var completedBadges:[Int] { get set }
    var myLevel:Int? {get set}
    var credibility:Int? {get set}
    var completedArticle:[Article]? {get set}
    func moveToCompleteArticle(id:Int)

}

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

enum ContentType:String {
    
    case Score = "ARTICLE POINTS"
    case Level = "MY LEVEL"
    case Badge = "MY BADGES"
    case CREDIBILITY = "ARTICLE CREDIBILITY"
    case COMPLETEDARTICLE = "COMPLETED ARTICLES"
//    , Level, Badge
}

final class BadgeView:UIView {
    
    let badgeImageView = UIImageView()
    let badgeTitleLb = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    func setData(badgeImage:String, badgeTitle:String, tag:Int, isCompleted:Bool = false) {
        self.tag = tag
        self.badgeImageView.image = UIImage.init(named: !isCompleted ? badgeImage : "\(badgeImage)C")
        self.badgeTitleLb.attributedText = badgeTitle.makeAttrString(font: .NotoSans(.bold, size: 12), color: .black)
    }
    
    private func setUI() {
        self.addSubview([badgeImageView, badgeTitleLb])
        
        badgeImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.width.equalTo(90)
            make.height.equalTo(90)
        }
        badgeTitleLb.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(badgeImageView.snp.bottom).offset(5)
            make.height.equalTo(40)
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        badgeImageView.contentMode = .scaleAspectFit
        badgeTitleLb.textAlignment = .center
        badgeTitleLb.adjustsFontSizeToFitWidth = true
        badgeTitleLb.numberOfLines = 2
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

class NewspaperPublishedView:UIView {
    
    let newspaperImageView = UIImageView()
    let publishButton = BottomButton()
    var delegate:PublishDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    func setUI() {
        
        self.addSubview([newspaperImageView, publishButton])
        
        newspaperImageView.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.centerX.equalToSuperview()
            make.height.equalTo(240)
        }
        newspaperImageView.contentMode = .scaleAspectFit
        
        publishButton.snp.makeConstraints { (make) in
            make.top.equalTo(newspaperImageView.snp.bottom).offset(10)
            make.width.equalToSuperview().multipliedBy(0.6)
            make.height.equalTo(55)
            make.centerX.equalToSuperview()
        }
        
        switch Standard.shared.getLocalized() {
            
        case .ENGLISH:
            newspaperImageView.image = UIImage.init(named: "engNewsPaper")
        case .KOREAN:
            newspaperImageView.image = UIImage.init(named: "koreanNewsPaper")
        case .GERMAN:
            newspaperImageView.image = UIImage.init(named: "germanNewsPaper")
        }
        
        publishButton.setTitle("PRESS".localized, for: .normal)
    }
    
    @objc func moveToNext(sender:UIButton) {
        
        delegate?.moveToNext(sender: sender)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

protocol PublishDelegate {
    func moveToNext(sender:UIButton)
}


enum TopicSection:Int {

    case Politics, Economy, General, Art, Sports, People
    
    
}

enum HashSection:Int {
    
    case hash1, hash2, hash3, hash4, hash5
    
}
