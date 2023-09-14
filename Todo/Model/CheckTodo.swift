//
//  Todo.swift
//  Todo
//
//  Created by 김도현 on 2023/07/31.
//

import Foundation
import UIKit

struct CheckTodo: Codable, Task {
    var coreDataEntityID: String = "checkTodoData"
    var id: UUID
    var createDate: Date
    var doneDate: Date? = nil
    var title: String
    var category: Category

    var isCompleted: Bool = false {
        didSet {
            if isCompleted { doneDate = Date() }
            else { doneDate = nil }
        }
    }
    
    init(id: UUID = UUID(), title: String, createDate: Date = Date(), doneDate: Date? = nil, isCompleted: Bool, category: Category) {
        self.id = id
        self.title = title
        self.createDate = createDate
        self.isCompleted = isCompleted
        self.doneDate = doneDate
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
