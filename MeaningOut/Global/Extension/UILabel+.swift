//
//  UILabel+.swift
//  MeaningOut
//
//  Created by 아라 on 6/17/24.
//

import UIKit

extension UILabel {
    func partiallyChanged(_ target: String, font: UIFont?, color: UIColor?) {
        let text = text ?? ""
        let attr = NSMutableAttributedString(string: text)
        let range = (text as NSString).range(of: target)
        attr.addAttributes([.font: font as Any, .foregroundColor: color as Any], range: range)
        attributedText = attr
    }
}
