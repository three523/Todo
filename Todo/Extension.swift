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

extension Date {
    func dateTimeString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일 hh:mm"
        return dateFormatter.string(from: self)
    }
}

extension UIColor {
    static var mainColor: UIColor = UIColor(red: 109/255, green: 209/255, blue: 213/255, alpha: 1.0)
}

protocol ReusableCell {
    static var resuableIdentifier: String { get }
}

extension UITableViewCell: ReusableCell {
    static var resuableIdentifier: String {
        return "\(self)"
    }
}

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T? {
        guard let cell = dequeueReusableCell(withIdentifier: T.resuableIdentifier, for: indexPath) as? T else {
            print("Unable to Dequeue Reusable Table View Cell")
            return nil
        }

        return cell
    }
}
