//
//  Extenstion.swift
//  Todo
//
//  Created by 김도현 on 2023/07/31.
//

import Foundation
import UIKit
extension String {
    func strikeThrough() -> NSAttributedString {
        let attributeString = NSMutableAttributedString(string: self)
        attributeString.addAttribute(.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributeString.length))
        attributeString.addAttribute(.foregroundColor, value: UIColor.systemGray3, range: NSRange(location: 0, length: attributeString.length))
        return attributeString
    }
    func normal() -> NSAttributedString {
        let attributeString = NSMutableAttributedString(string: self)
        attributeString.addAttribute(.strikethroughStyle, value: 0, range: NSMakeRange(0, attributeString.length))
        return attributeString
    }
}

extension UIColor {
    static var mainColor: UIColor = UIColor(red: 109/255, green: 209/255, blue: 213/255, alpha: 1.0)
}
