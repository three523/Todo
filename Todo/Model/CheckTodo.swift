//
//  Todo.swift
//  Todo
//
//  Created by 김도현 on 2023/07/31.
//

import Foundation
import UIKit

struct CheckTodo: Codable, Task {
    var id: UUID = UUID()
    var createTime: Date = Date()
    var doneTime: Date? = nil
    var title: String
    var category: Category

    var isCompleted: Bool = false {
        didSet {
            if isCompleted { doneTime = Date() }
        }
    }
    
    init(title: String, isCompleted: Bool, category: Category) {
        self.title = title
        self.isCompleted = isCompleted
        self.category = category
    }
    
    func todoCell(tableView: UITableView, indexPath: IndexPath, viewContoller: UpdateTodoDelegate) -> UITableViewCell? {
        guard let cell: TodoTableViewCell = tableView.dequeueReusableCell(for: indexPath) else {
            return nil
        }
        cell.uiUpdate(todo: self)
        cell.delegate = viewContoller
        return cell
    }
}
