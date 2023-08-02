//
//  TodoManager.swift
//  Todo
//
//  Created by 김도현 on 2023/07/31.
//

import Foundation

class TodoManager {
    static var todoList: [Todo] = []
    var viewUpdate: ()->() = {}
    
    init(viewUpdate: @escaping () -> Void) {
        self.viewUpdate = viewUpdate
    }
    
    func todoAllCount() -> Int {
        return TodoManager.todoList.count
    }
    
    func todoCompleteCount() -> Int {
        return TodoManager.todoList.filter{ $0.isCompleted }.count
    }
    
    func todo(at index: Int) -> Todo {
        return TodoManager.todoList[index]
    }
    
    func completeTodo(at index: Int) -> Todo {
        return TodoManager.todoList.filter{ $0.isCompleted }[index]
    }
    
    func add(todo: Todo) {
        TodoManager.todoList.append(todo)
        viewUpdate()
    }
    
    func update(todo: Todo) {
        guard let index = TodoManager.todoList.firstIndex(where: {$0.id == todo.id}) else { return }
        TodoManager.todoList[index] = todo
//        viewUpdate()
    }
    
    func remove(todo: Todo) {
        TodoManager.todoList.removeAll(where: {$0.id == todo.id})
        viewUpdate()
    }
}
