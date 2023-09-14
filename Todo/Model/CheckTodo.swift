//
//  Todo.swift
//  Todo
//
//  Created by 김도현 on 2023/07/31.
//

import Foundation
import UIKit

struct CheckTodo: Codable, Task {
    var id: UUID
    var createDate: Date
    var modifyDate: Date? = nil
    var doneDate: Date? = nil
    var title: String

    var isCompleted: Bool = false {
        didSet {
            if isCompleted { doneDate = Date() }
            else { doneDate = nil }
        }
    }
    
    init(id: UUID = UUID(), title: String, createDate: Date = Date(), doneDate: Date? = nil, isCompleted: Bool) {
        self.id = id
        self.title = title
        self.createDate = createDate
        self.isCompleted = isCompleted
        self.doneDate = doneDate
    }
    
    func todoCell(tableView: UITableView, indexPath: IndexPath, viewContoller: UpdateTodoDelegate) -> UITableViewCell? {
        guard let cell: CheckTodoTableViewCell = tableView.dequeueReusableCell(for: indexPath) else {
            return nil
        }
        let category = Category.allCases[indexPath.section]
        cell.uiUpdate(todo: self, category: category)
        cell.delegate = viewContoller
        return cell
    }
}
