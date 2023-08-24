//
//  TodoManager.swift
//  Todo
//
//  Created by 김도현 on 2023/07/31.
//

import Foundation

class TodoManager {
    static var todoList: [Task] = []
    
    func todoAllCount() -> Int {
        return TodoManager.todoList.count
    }
    
    func todoCompleteCount() -> Int {
        return TodoManager.todoList.filter{ $0.isCompleted }.count
    }
    
    func todo(at index: Int) -> Task {
        return TodoManager.todoList[index]
    }
    
    func completeTodo(at index: Int) -> Task {
        return TodoManager.todoList.filter{ $0.isCompleted }[index]
    }
    
    func add(todo: Task) {
        TodoManager.todoList.append(todo)
    }
    
    func update(todo: Task) {
        guard let index = TodoManager.todoList.firstIndex(where: {$0.id == todo.id}) else { return }
        TodoManager.todoList[index] = todo
    }
    
    func remove(at index: Int) {
        TodoManager.todoList.remove(at: index)
    }
}
