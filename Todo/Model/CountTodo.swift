//
//  CountTodo.swift
//  Todo
//
//  Created by 김도현 on 2023/09/22.
//

import Foundation

struct CountTodo: Task {
    var id: UUID = UUID()
    var createDate: Date = Date()
    var modifyDate: Date? = nil
    var doneDate: Date? = nil
    var title: String
    var count: Int
    var goal: Int
    var isCompleted: Bool = false {
        didSet {
            if isCompleted { doneDate = Date() }
            else { doneDate = nil }
        }
    }

    init(title: String, goal: Int, count: Int = 0) {
        self.title = title
        self.goal = goal
        self.count = count
    }
}

