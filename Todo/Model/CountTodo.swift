//
//  CountTodo.swift
//  Todo
//
//  Created by 김도현 on 2023/08/24.
//

import Foundation
import UIKit

//struct CountTodo: Codable, Task {
//    var id: UUID = UUID()
//    var createDate: Date = Date()
//    var modifyDate: Date? = nil
//    var doneDate: Date? = nil
//    var title: String
//    var count: Int
//    var goal: Int
//    var isCompleted: Bool = false {
//        didSet {
//            if isCompleted { doneDate = Date() }
//            else { doneDate = nil }
//        }
//    }
//
//    init(title: String, goal: Int, count: Int = 0) {
//        self.title = title
//        self.goal = goal
//        self.count = count
//    }
//
//    func todoCell(tableView: UITableView, indexPath: IndexPath, viewContoller: UpdateTodoDelegate) -> UITableViewCell? {
//        guard let cell: CountTodoTableViewCell = tableView.dequeueReusableCell(for: indexPath) else {
//            return nil
//        }
//        let category = Category.allCases[indexPath.section]
//        cell.uiUpdate(todo: self, category: category)
//        cell.delegate = viewContoller
//        return cell
//    }
//}
//
