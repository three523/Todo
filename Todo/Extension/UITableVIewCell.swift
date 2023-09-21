//
//  UITableVIewCell.swift
//  Todo
//
//  Created by 김도현 on 2023/08/24.
//

import Foundation
import UIKit

protocol ReusableCell {
    static var resuableIdentifier: String { get }
}

extension ReusableCell {
    static var resuableIdentifier: String {
        return "\(self)"
    }
}

extension UITableViewCell: ReusableCell {
    static var resuableIdentifier: String {
        return "\(self)"
    }
}
