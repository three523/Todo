//
//  Todo.swift
//  Todo
//
//  Created by 김도현 on 2023/07/31.
//

import Foundation
import UIKit

protocol Task {
    var id: UUID { get }
    var title: String { get set }
    var isCompleted: Bool { get set }
    var createTime: Date { get }
    var doneTime: Date? { get set }
    var type: TodoType { get set }
    
    func todoCell(tableView: UITableView, indexPath: IndexPath, viewContoller: UpdateTodoDelegate) -> UITableViewCell?
}

struct CheckTodo: Task {
    var id: UUID = UUID()
    var createTime: Date = Date()
    var doneTime: Date? = nil
    var title: String
    var isCompleted: Bool
    var type: TodoType = .check
    
    init(title: String, isCompleted: Bool) {
        self.title = title
        self.isCompleted = isCompleted
    }
    
    func todoCell(tableView: UITableView, indexPath: IndexPath, viewContoller: UpdateTodoDelegate) -> UITableViewCell? {
        guard let cell: TodoTableViewCell = tableView.dequeueReusableCell(for: indexPath) else {
            return nil
        }
        cell.contentView.backgroundColor = .clear
        cell.uiUpdate(todo: self)
        cell.delegate = viewContoller
        return cell
    }
}

struct CountTodo: Task {
    var id: UUID = UUID()
    var createTime: Date = Date()
    var doneTime: Date? = nil
    var title: String
    var count: Int
    var goal: Int
    var isCompleted: Bool = false
    var type: TodoType = .count
    
    init(title: String, goal: Int, count: Int = 0) {
        self.title = title
        self.goal = goal
        self.count = count
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
