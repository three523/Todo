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
    var updateTime: Date { get set }
}

struct Todo: Task {
    var id: UUID = UUID()
    var createTime: Date = Date()
    var updateTime: Date = Date()
    var title: String
    var isCompleted: Bool
    
    init(title: String, isCompleted: Bool) {
        self.title = title
        self.isCompleted = isCompleted
    }
}

struct CountTodo: Task {
    func todoCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    var id: UUID = UUID()
    var createTime: Date = Date()
    var updateTime: Date = Date()
    var title: String
    var count: Int
    var goal: Int
    var isCompleted: Bool = false
    
    init(title: String, goal: Int, count: Int = 0) {
        self.title = title
        self.goal = goal
        self.count = count
    }
}
