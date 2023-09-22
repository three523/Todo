//
//  DoneTodoListViewModel.swift
//  Todo
//
//  Created by 김도현 on 2023/09/22.
//

import Foundation

class DoneTodoListViewModel {
    let todoManager: TodoManager
    
    init(todoManager: TodoManager) {
        self.todoManager = todoManager
    }
}
