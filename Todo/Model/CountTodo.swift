//
//  CountTodo.swift
//  Todo
//
//  Created by 김도현 on 2023/08/24.
//

import Foundation
import UIKit

struct CountTodo: Codable, Task {
    var id: UUID = UUID()
    var createTime: Date = Date()
    var doneTime: Date? = nil
    var title: String
    var count: Int
    var goal: Int
    var category: Category
    var isCompleted: Bool = false {
        didSet {
            if isCompleted { doneTime = Date() }
        }
    }
    
    init(title: String, goal: Int, count: Int = 0, category: Category) {
        self.title = title
        self.goal = goal
        self.count = count
        self.category = category
    }
    
    func todoCell(tableView: UITableView, indexPath: IndexPath, viewContoller: UpdateTodoDelegate) -> UITableViewCell? {
        guard let cell: CountTodoTableViewCell = tableView.dequeueReusableCell(for: indexPath) else {
            return nil
        }
        cell.uiUpdate(todo: self)
        cell.delegate = viewContoller
        return cell
    }
}

