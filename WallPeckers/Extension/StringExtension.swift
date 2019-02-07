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
    
    func heightForWithFont(font: UIFont, width: CGFloat, insets: UIEdgeInsets) -> CGFloat {
        let label:UILabel = UILabel(frame: CGRect.init(x: 0, y: 0, width: width + insets.left + insets.right, height: .greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = self
        
        label.sizeToFit()
        return label.frame.height + insets.top + insets.bottom
    }

}
