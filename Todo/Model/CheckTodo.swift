//
//  Todo.swift
//  Todo
//
//  Created by 김도현 on 2023/07/31.
//

import Foundation
import UIKit

struct CheckTodo: Task {
    var id: UUID = UUID()
    var createTime: Date = Date()
    var doneTime: Date? = nil
    var title: String
    var isCompleted: Bool {
        didSet {
            if isCompleted { doneTime = Date() }
        }
    }
    var type: TodoType = .check
    
    init(title: String, isCompleted: Bool) {
        self.title = title
        self.isCompleted = isCompleted
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