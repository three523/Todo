//
//  TableView.swift
//  Todo
//
//  Created by 김도현 on 2023/08/24.
//

import Foundation
import UIKit

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T? {
        guard let cell = dequeueReusableCell(withIdentifier: T.resuableIdentifier, for: indexPath) as? T else {
            print("Unable to Dequeue Reusable Table View Cell")
            return nil
        }
        return cell
    }
}
