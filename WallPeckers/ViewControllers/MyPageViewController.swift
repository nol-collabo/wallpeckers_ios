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
    
    var fromGame:Bool = false
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
    
    func moveToNext(sender: UIButton) {
        
        if fromResult {
            self.dismiss(animated: true, completion: nil)
        }else{
            guard let vc = UIStoryboard.init(name: "Publish", bundle: nil).instantiateViewController(withIdentifier: "Publish") as? UINavigationController else {return}
            
            if let mvc = vc.viewControllers.first as? PublishViewController {
                mvc.fromMyPage = true
            }
            
            sender.isUserInteractionEnabled = true
            self.present(vc, animated: true, completion: nil)
        }

    }
    
    func moveToCompleteArticle(id: Int) {
        
        guard let vc = UIStoryboard.init(name: "Game", bundle: nil).instantiateViewController(withIdentifier: "CompleteArticleViewController") as? CompleteArticleViewController else {return}
        
        if let ar = RealmArticle.shared.get(Standard.shared.getLocalized()).filter({$0.id == id}).first {
            vc.setData(article: ar, hashTag: ar.selectedHashtag, wrongIds: Array(ar.wrongQuestionsId))
            vc.fromMyPage = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
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
        setDelegate()
        setAction()
        setInitData()
        setUI()
    }
    
    private func setInitData() {
        currentPoint = RealmUser.shared.getUserData()?.score
        myLevel = 10
        
        completedArticle = RealmArticle.shared.get(Standard.shared.getLocalized()).filter({$0.isCompleted})
        
        if let corec = completedArticle?.map({Double($0.correctQuestionCount)}), let total = completedArticle?.map({Double($0.totalQuestionCount)}) {
            
            if corec.count > 0 {
                credibility = Int((corec.reduce(0, +) / total.reduce(0, +)) * 100)
            }
        }
        
        for i in 1...6 {
            addBadge(tag: i)
        }
    }
    
    private func setDelegate() {
        scoreView.delegate = self
        badgeView.delegate = self
        levelView.delegate = self
        profileView.delegate = self
        if let _currentPoint = currentPoint {
            if _currentPoint > 0 {
                credView.delegate = self
                completedArticleView.delegate = self
            }
        }
    }
    
    private func setAction() {
        self.view.addGestureRecognizer(keyboardResigner)
        keyboardResigner.addTarget(self, action: #selector(keyboardResign))
        dismissBtn.addTarget(self, action: #selector(dismissTouched(sender:)), for: .touchUpInside)

    }
    
    private func setUI() {
        
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
        

        
        aStackView.addRow(scoreView)
        profileBaseView.addSubview(profileView)
 
        profileView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(DEVICEHEIGHT > 600 ? 42 : 32)
            make.height.equalTo(DEVICEHEIGHT > 600 ? 360 : 290)

        }
        
        profileView.setData(userData: RealmUser.shared.getUserData()!, level: RealmUser.shared.getUserLevel(), camera: true, nameEdit: true, myPage: false)
        
        
        //완료된 기사가 없으면 숨김 처리할 것에 대한 부분
        
        if let _completedArticle = completedArticle {
            
            if _completedArticle.count > 0 {
                
                credView.setData(content: .CREDIBILITY)
                completedArticleView.setData(content: .COMPLETEDARTICLE)
                
                aStackView.addRow(credView)
                if let _count = completedArticle?.count {
                    if _count > 0 {
                        if !fromGame {
                            if (RealmUser.shared.getUserData()?.playTime)! <= 0 {
                                aStackView.addRow(publishView)
                                publishView.snp.makeConstraints { (make) in
                                    make.edges.equalToSuperview()
                                    make.height.equalTo(320)
                                }
                                publishView.delegate = self
                            }
                        }
                    }
                }
                aStackView.addRow(completedArticleView)
            }
        }
        
        aStackView.addRows([levelView, badgeView])
        aStackView.backgroundColor = .basicBackground


    }
    
    @objc func dismissTouched(sender:UIButton) {
        sender.isUserInteractionEnabled = false
        self.dismiss(animated: true) {
            sender.isUserInteractionEnabled = true
        }
    }
}

extension MyPageViewController:MyPageDelegate { // 내 정보 뷰 관련 델리게이트
    
    
    func isbecomeKeyboard(sender: UITextField) {
        UIView.animate(withDuration: 0.2) {
            self.view.center = .init(x: self.view.center.x, y: self.view.center.y - 120)
        }
    }
    
    func isresignKeyboard(sender: UITextField) { // 닉네임 수정 시 불리는 함수
        sender.resignFirstResponder()
        UIView.animate(withDuration: 0.2) {
            self.view.center = .init(x: self.view.center.x, y: self.view.center.y + 120)
        }
        
        try! realm.write {
            RealmUser.shared.getUserData()?.name = sender.text
        }
    }
    
    func callProfileImageOption(sender: UIButton) {
        
        imagePicker.delegate = self
        PopUp.call(mainTitle: "registrationdialog_title".localized, selectButtonTitles: ["registrationdialog_camera".localized, "registrationdialog_album".localized, "registrationdialog_noprofile".localized], bottomButtonTitle: "CANCEL".localized, bottomButtonType: 0, self, buttonImages: nil)
        
    }
    
}

extension MyPageViewController:UIImagePickerControllerDelegate, UINavigationControllerDelegate { // 프로필 이미지 선택 관련 델리게이트
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) { // 프로필 이미지 선택
        
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

    
    func selectButtonTouched(tag: Int) {
        
        switch tag {
        case 0:
            imagePicker.sourceType = .camera
            switch AVCaptureDevice.authorizationStatus(for: .video) {
                
                
            case .authorized:
                self.present(self.imagePicker, animated: true, completion: nil)
                
            case .denied:
                UIApplication.shared.open(SETTINGURL)
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { (response) in
                    if response {
                        
                        self.present(self.imagePicker, animated: true, completion: nil)
                        
                    }else {
                        print(response)
                    }
                }
            case .restricted:
                UIApplication.shared.open(SETTINGURL)
                
            }
            
        case 1:
            imagePicker.sourceType = .photoLibrary

            let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
            switch photoAuthorizationStatus {
            case .authorized:
                print("Access is granted by user")
                self.present(self.imagePicker, animated: true, completion: nil)
                
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization({
                    (newStatus) in
                    print("status is \(newStatus)")
                    if newStatus ==  PHAuthorizationStatus.authorized {
                        
                        self.present(self.imagePicker, animated: true)
                        
                        print("success")
                    }
                })
                print("It is not determined until now")
            case .restricted:
                // same same
                UIApplication.shared.open(SETTINGURL)

                print("User do not have access to photo album.")
            case .denied:
                // same same
                UIApplication.shared.open(SETTINGURL)

                print("User has denied the permission.")
            }
            
        case 2:
            profileView.profileImageView.image = UIImage.init(named: "basic_profile")
            
            try! realm.write {
                RealmUser.shared.getUserData()?.profileImage = UIImage.init(named: "basic_profile")!.jpegData(compressionQuality: 0.5)
            }
            
        default:
            break
        }
    
        self.removePopUpView()
    }

}
