//
//  CreateViewModel.swift
//  Todo
//
//  Created by 김도현 on 2023/09/21.
//

import Foundation

class CreateTodoViewModel {
    var todo: TaskEntity?
    var type: TodoType
    var category: Category
    var todoManager: TodoManager
    
    init(todo: TaskEntity? = nil, type: TodoType, category: Category = .life, todoManager: TodoManager) {
        self.todo = todo
        self.type = type
        self.category = category
        self.todoManager = todoManager
    }
}
extension CreateTodoViewModel {
    var isHiddenGoalStackView: Bool { type == .check }
    var isUpdateMode: Bool { todo != nil }
    
    func addCheckTodo(title: String) {
        let checkTodo = CheckTodo(title: title)
        todoManager.addTodo(category: category, checkTodo: checkTodo)
    }
    
    func addCountTodo(title: String, goal: Int) {
        let countTodo = CountTodo(title: title, goal: goal)
        todoManager.addTodo(category: category, countTodo: countTodo)
    }
    
    func updateTodo<T: TaskEntity>(todo: T) {
        todoManager.updateTodo(category: category, todo: todo)
    }
    
    func removeTodo() {
        guard let todo else { return }
        todoManager.removeTodo(category: category, todo: todo)
    }
}
