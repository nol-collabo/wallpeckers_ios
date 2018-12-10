//
//  ClueSelectViewController.swift
//  WallPeckers
//
//  Created by Seongchan Kang on 10/12/2018.
//  Copyright © 2018 KimJimin and Company. All rights reserved.
//

import UIKit
import SnapKit
import AloeStackView

class ClueSelectViewController: UIViewController {

    var article:Article?
    var timerView:NavigationCustomView?
    let factCheckButton = BottomButton()
    let backButton = UIButton()
    var five_W_One_Hs:[Five_W_One_Hs]?
    let stackView = AloeStackView()
    var sectionString:String?
    var questionPoint:String?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        // Do any additional setup after loading the view.
    }
    
    func setData(article:Article, five:[Five_W_One_Hs]) {
        self.article = article
        self.five_W_One_Hs = five
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Standard.shared.delegate = self
    }
    
    func setUI(){
        Standard.shared.delegate = self
        self.setCustomNavigationBar()
        self.timerView = self.findTimerView()
        self.view.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeArea.top).offset(90)
            make.bottom.equalTo(view.safeArea.bottom)
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            
        }
        self.view.backgroundColor = .basicBackground
        backButton.setImage(UIImage.init(named: "backButton"), for: .normal)
        factCheckButton.setTitle("FACT CHECK", for: .normal)
        backButton.addTarget(self, action: #selector(moveToBack(sender:)), for: .touchUpInside)
        factCheckButton.addTarget(self, action: #selector(moveToFactCheck(sender:)), for: .touchUpInside)
        setStack()
        
    }
    
    func setStack() {
        
        stackView.backgroundColor = .basicBackground
        
        let articleView = ArticleView()
        
        articleView.setData(article: article!, point: questionPoint!)

        stackView.addRow(articleView)
        
        for v in five_W_One_Hs! {
            
            let view = ClueSelectView()
            view.delegate = self
            if let clue = realm.objects(Clue.self).filter({
                
                $0.id == v.clue
            }).first {
                view.setData(five: v, clue: clue)
                view.tag = v.clue
                stackView.addRow(view)
            }
            
            stackView.addRow(factCheckButton)
            factCheckButton.snp.makeConstraints { (make) in
                make.width.equalTo(200)
                make.height.equalTo(50)
                make.center.equalToSuperview()
            }
            stackView.addRow(backButton)
//            article?.clues.
        }
        
    }
    
    @objc func moveToFactCheck(sender:UIButton) {
        print("MOVE To FactCheck")
    }
    @objc func moveToBack(sender:UIButton) {
        sender.isUserInteractionEnabled = false
        self.navigationController?.popViewController(animated: true)
        sender.isUserInteractionEnabled = true
    }

}

extension ClueSelectViewController:GamePlayTimeDelegate, ClueSelectDelegate, CluePopUpViewDelegate {
    func touchButton(sender: Clue) {
        
        if let clueType = sender.type {
            PopUp.callCluePopUp(clueType: clueType, vc: self)
        }

    }
    
    func inputCode(_ code: String?) {
        print(code)
    }
    

    
    func checkPlayTime(_ time: Int) {
        timerView?.updateTime(time)
        if time == 0 { //완료 됐을떄
            
            PopUp.callAlert(time: "00:00", desc: "완료", vc: self, tag: 1)
            print("END!")
            
        }else if time == 60 { // 1분 남았을 때
            PopUp.callAlert(time: "01:00", desc: "1분", vc: self, tag: 2)
            
            print("1minute!")
            
        }
    }
    
    
}

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
        
        pathLb.attributedText = article.word?.makeAttrString(font: .NotoSans(.medium, size: 10), color: .black)
        pointLb.attributedText = "\(point)".makeAttrString(font: .NotoSans(.medium, size: 10), color: .black)
        titleLb.attributedText = article.title?.makeAttrString(font: .NotoSans(.bold, size: 20), color: .black)
        descLb.attributedText = article.title_sub?.makeAttrString(font: .NotoSans(.bold, size: 15), color: .black)
        articleImageView.image = UIImage()
        articleImageView.backgroundColor = .blue
    }
    
    private func setUI() {
    
        self.addSubview([pathLb, pointLb, titleLb, descLb, articleImageView])
        
        pathLb.snp.makeConstraints { (make) in
            make.top.leading.equalTo(5)
            make.width.equalTo(120)
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
//            make.height.equalTo(50)
            make.trailing.equalTo(-5)
//            make.bottom.equalToSuperview()
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

final class ClueSelectView:UIView {
    
    let clueButton = UIButton()
    let clueLb = UILabel()
    let infoLb = UILabel()
    var delegate:ClueSelectDelegate?
    var clue:Clue?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    func setData(five:Five_W_One_Hs, clue:Clue) {
        
        self.clue = clue
        clueButton.setAttributedTitle("\(clue.type!)".makeAttrString(font: .NotoSans(.bold, size: 20), color: .black), for: .normal)
        
        if !five.given {
            clueLb.text = ""
            infoLb.isHidden = false
            clueButton.backgroundColor = .white

        }else {
            clueButton.backgroundColor = .basicBackground
            clueLb.text = clue.desc
            clueButton.isUserInteractionEnabled = false
            infoLb.isHidden = true
        }
        
        
    }
    
    @objc func callCodePopUp(sender:Clue) {
        
//        print(sender.clueButton.currentTitle)
        delegate?.touchButton(sender: clue!)
        
    }
    
    private func setUI() {
      
        self.addSubview([clueButton, clueLb, infoLb])
        
        clueButton.snp.makeConstraints { (make) in
            make.top.equalTo(4)
            make.leading.equalTo(20)
            make.width.equalTo(100)
            make.height.equalTo(34)
        }

        clueButton.backgroundColor = .white
        clueButton.setBorder(color: .black, width: 1)
        clueButton.layer.shadowColor = UIColor.black.cgColor
        clueButton.layer.shadowOpacity = 1
        clueButton.layer.shadowRadius = 5
        
        infoLb.snp.makeConstraints { (make) in
            make.leading.equalTo(clueButton.snp.trailing).offset(10)
            make.centerY.equalTo(clueButton.snp.centerY)
            make.trailing.equalTo(-2)
        }
        clueLb.snp.makeConstraints { (make) in
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.top.equalTo(clueButton.snp.bottom).offset(10)
            make.bottom.equalTo(-10)
        }
        clueButton.addTarget(self, action: #selector(callCodePopUp(sender:)), for: .touchUpInside)
        clueLb.numberOfLines = 0
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

protocol ClueSelectDelegate {
    func touchButton(sender:Clue)
}

final class CluePopUpView:UIView {
    
    let baseView = UIView()
    let popupView = UIView()
    let titleLb = UILabel()
    let codeLb = UILabel()
    let codeTf = LeftPaddedTextField()
    let okButton = BottomButton()
    var delegate:CluePopUpViewDelegate?
    let keyboardResigner = UITapGestureRecognizer()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    @objc func keyboardRemove(){
        codeTf.resignFirstResponder()
    }
    
    private func setUI(){
        
        keyboardResigner.addTarget(self, action: #selector(keyboardRemove))
        self.addSubview([baseView, popupView])
        self.addGestureRecognizer(keyboardResigner)
        baseView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        baseView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        
        popupView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.leading.equalTo(30)
            make.height.equalTo(330)
        }
        popupView.addSubview([titleLb, codeLb, codeTf, okButton])
        popupView.backgroundColor = .white
        codeTf.keyboardType = .numberPad
        
        okButton.snp.makeConstraints { (make) in
            make.leading.equalTo(30)
            make.bottom.equalTo(-20)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
        }
        okButton.setTitle("OK", for: .normal)
        titleLb.snp.makeConstraints { (make) in
            make.top.equalTo(20)
            make.leading.equalTo(30)
            make.centerX.equalToSuperview()
            make.height.equalTo(55)
        }
        titleLb.setBorder(color: .black, width: 1.5)
        codeLb.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalTo(40)
        }
        
        codeLb.attributedText = "CODE:".makeAttrString(font: .NotoSans(.medium, size: 18), color: .black)
        codeTf.snp.makeConstraints { (make) in
            make.leading.equalTo(codeLb.snp.trailing).offset(10)
            make.trailing.equalTo(-40)
            make.centerY.equalTo(codeLb.snp.centerY)
        }
        codeTf.addUnderBar()
        codeTf.font = UIFont.NotoSans(.bold, size: 31)
        
        popupView.setBorder(color: .black, width: 2.5)
        titleLb.textAlignment = .center
        okButton.addTarget(self, action: #selector(okButtonTouched(sender:)), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func okButtonTouched(sender:UIButton) {
        
        delegate?.inputCode(codeTf.text)
        self.removeFromSuperview()
    }
    
}

protocol CluePopUpViewDelegate {
    
    func inputCode(_ code:String?)
    
}

extension UIView {
    
    func dropShadow() {
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.layer.shadowRadius = 1
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        
        self.layer.rasterizationScale = UIScreen.main.scale
        
    }
}
