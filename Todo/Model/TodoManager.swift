//
//  TodoManager.swift
//  Todo
//
//  Created by 김도현 on 2023/07/31.
//

import Foundation
import CoreData
import UIKit

final class TodoManager {
    
    static let shared: TodoManager = TodoManager()
        
    private var todoEntityManager: TodoEntityManager = TodoEntityManager.shared
    
    typealias Todo = Task & Codable
    
    private var todoList: [String : [Task]] = [:]
    
    private init() {
        initTodoList()
    }

    private func initTodoList() {
        guard let todo = todoEntityManager.todoEntity.first else { return }
        if let checkTodoData = todo.checkTodoData {
            let checkTodo = decodeData(todoType: CheckTodo.self, data: checkTodoData)
            checkTodo.forEach { category, checkTodoList in
                todoList[category, default: []].append(contentsOf: checkTodoList)
            }
        }
        if let countTodoData = todo.counTodoData {
            let countTodo = decodeData(todoType: CountTodo.self, data: countTodoData)
            countTodo.forEach { category, countTodoList in
                todoList[category, default: []].append(contentsOf: countTodoList)
            }
        }
        sortTodoList()
    }
    
    private func fetchCategoryTodo<T: Todo>(todoType: T.Type) -> [String : [T]] {
        var tempTodoList = [String : [T]]()
        let decoder = JSONDecoder()
        guard let entity = todoEntityManager.todoEntity.first,
              let data = entity.checkTodoData else { return tempTodoList }
        do {
            tempTodoList = try decoder.decode([String : [T]].self, from: data)
        } catch let e {
            print(e.localizedDescription)
        }
        return tempTodoList
    }
    
    private func fetchCategoryTodo<T: Todo>(todoType: T.Type, category: Category) ->[String : [T]] {
        guard let filterTodoList = todoList[category.title, default: []].filter({ $0 is T }) as? [T] else {
            return [:]
        }
        return [category.title : filterTodoList]
    }
    
    private func sortTodoList() {
        let categoryAllCase = Category.allCases
        categoryAllCase.forEach { category in
            todoList[category.title, default: []].sort { $0.createDate < $1.createDate }
        }
    }
    
    func todoCount(category: Category) -> Int {
        guard let categoryTodo = todoList[category.title] else { return 0 }
        return categoryTodo.count
    }
    
    func todoCompleteCount(category: Category) -> Int {
        let completeTodo = todoList[category.title]?.filter { $0.isCompleted }
        return completeTodo?.count ?? 0
    }
    
    func todo(category: Category, at index: Int) -> Todo? {
        guard let categoryTodo = todoList[category.title] else { return nil }
        return categoryTodo[index] as? Todo
    }
    
    func completeTodo(category: Category, at index: Int) -> Task? {
        guard let categoryTodo = todoList[category.title] else { return nil }
        let completeTodo = categoryTodo.filter { $0.isCompleted }
        return completeTodo[index]
    }
    
    func add<T: Todo>(category: Category, todo: T) {
        var genericTodo = fetchCategoryTodo(todoType: T.self, category: category)
        
        let encoder = JSONEncoder()
        todoList[category.title, default: []].append(todo)
        genericTodo[category.title, default: []].append(todo)
        
        guard let data = encodeTodo(todoList: genericTodo, category: category) else {
            todoList[category.title, default: []].popLast()
            return
        }
        let isSaveComplete = todoEntityManager.addEntity(todoData: data, category: category)
        if !isSaveComplete { todoList[category.title, default: []].popLast() }
    }
    
    func update<T: Todo>(category: Category, todo: T) {
        guard todoList[category.title] != nil else { return }
        let tempTodoList = todoList
        var categoryTodoList = fetchCategoryTodo(todoType: T.self, category: category)
        
        guard let updateTodoIndex = todoList[category.title, default: []].firstIndex(where: { $0.id == todo.id }) else { return }
        guard let userdefaultUpdateTodoIndex = categoryTodoList[category.title, default: []].firstIndex(where: { $0.id == todo.id }) else { return }
        todoList[category.title]![updateTodoIndex] = todo
        categoryTodoList[category.title]![userdefaultUpdateTodoIndex] = todo
        
        guard let data = encodeTodo(todoList: categoryTodoList, category: category) else {
            todoList = tempTodoList
            return
        }
        let isComplete = todoEntityManager.addEntity(todoData: data, category: category)
        if !isComplete { todoList = tempTodoList }
    }
    
    func remove<T: Todo>(todoType: T.Type, category: Category, id: UUID) {
        guard todoList[category.title] != nil else { return }
        let tempTodoList = todoList
        var categoryTodoList = fetchCategoryTodo(todoType: T.self, category: category)
        
        todoList[category.title, default: []].removeAll { $0.id == id }
        categoryTodoList[category.title, default: []].removeAll { $0.id == id }
        
        guard let data = encodeTodo(todoList: categoryTodoList, category: category) else {
            todoList = tempTodoList
            return
        }
        let isComplete = todoEntityManager.addEntity(todoData: data, category: category)
        if !isComplete { todoList = tempTodoList }
    }
    
    private func encodeTodo<T: Encodable>(todoList: [String : [T]], category: Category) -> Data? {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(todoList)
            return data
        } catch let e {
            print(e.localizedDescription)
        }
        return nil
    }
    
    private func decodeData<T: Todo>(todoType: T.Type, data: Data) -> [String : [T]] {
        var tempTodoList = [String : [T]]()
        let decoder = JSONDecoder()
        do {
            let todo = try decoder.decode([String : [T]].self, from: data)
            tempTodoList = todo
        } catch let e {
            print(e.localizedDescription)
        }
        return tempTodoList
    }
}
