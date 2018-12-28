//
//  StringExtension.swift
//  WallPeckers
//
//  Created by Seongchan Kang on 28/12/2018.
//  Copyright © 2018 KimJimin and Company. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    func makeAttrString(font:UIFont, color:UIColor) -> NSMutableAttributedString {
        
        let descTitle = NSMutableAttributedString.init(string:self)
        
        descTitle.addAttributes([NSAttributedString.Key.foregroundColor:color, NSAttributedString.Key.font:font], range: NSRange.init(location: 0, length: descTitle.length))
        
        return descTitle
    }
    
    var localized: String {
        
        let countryCode = Standard.shared.getLocalized()
        
        let path = Bundle.main.path(forResource: countryCode.rawValue, ofType: "lproj")
        let bundleName = Bundle(path: path!)
        return NSLocalizedString(self, tableName: nil, bundle: bundleName!, value: "", comment: "")
        
    }
}
