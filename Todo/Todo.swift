//
//  Todo.swift
//  Todo
//
//  Created by 김도현 on 2023/07/31.
//

import Foundation

struct Todo {
    let id: UUID = UUID()
    let title: String
    var isCompleted: Bool
    
    init(title: String, isCompleted: Bool) {
        self.title = title
        self.isCompleted = isCompleted
    }
}
