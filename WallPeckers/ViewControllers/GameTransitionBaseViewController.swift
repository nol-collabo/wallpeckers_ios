//
//  GameTransitionBaseViewController.swift
//  WallPeckers
//
//  Created by Seongchan Kang on 12/12/2018.
//  Copyright © 2018 KimJimin and Company. All rights reserved.
//

import UIKit

class GameTransitionBaseViewController: UIViewController {

    var delegate:GameViewTransitionDelegate?
    var type:GameViewType?

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func findBeforeVc(type:GameViewType) -> GameTransitionBaseViewController? { // 이전 뷰컨트롤러 찾기

        if let vcs = self.parent?.children as? [GameTransitionBaseViewController] {
            
            if let findVc = vcs.filter({
                
                $0.type == type

            }).first {
                return findVc
            }else{
                return nil
            }
        }else{
            return nil
        }
    }
}

protocol GameViewTransitionDelegate {
    
    func moveTo(fromVc:GameTransitionBaseViewController, toVc:GameTransitionBaseViewController, sendData:Any?, direction:TransitionDirection)
    
}

enum TransitionDirection:String {
    case forward, backward
}
