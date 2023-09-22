//
//  TodoListViewModel.swift
//  Todo
//
//  Created by 김도현 on 2023/09/21.
//

import Foundation

class TodoListViewModel {
    var todoManager: TodoManager
    
    init(todoManager: TodoManager) {
        self.todoManager = todoManager
    }
}
