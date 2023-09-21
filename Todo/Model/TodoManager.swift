//
//  TodoManager.swift
//  Todo
//
//  Created by 김도현 on 2023/07/31.
//

import Foundation
import CoreData

final class TodoManager {
    
    //TODO: 이름 고민해보기 todoList의 값을 바꾸는 세가지의 경우를 가지는 enum
    enum UpdateState {
        case create
        case update
        case remove
    }
    
    static let shared: TodoManager = TodoManager()
        
    private var todoEntityManager: TodoEntityManager = TodoEntityManager.shared
    
    typealias Todo = Task & Codable
    
    private var todoList: [String : [Task]] = [:]
    private var testTodoList: [String : [TestEntity & NSManagedObject]] = [:]
    var testTodoEntity: [CategoryEntity] = []
    
    private init() {
        initTodoList()
    }

    private func initTodoList() {
        testTodoEntity = todoEntityManager.categoryEntityList
        convertToDictionay()
    }
    
    func addTodo<T: TestEntity & NSManagedObject>(category: Category, todo: T) {
        testTodoList[category.title, default: []].append(todo)
        let isCompleted = todoEntityManager.addTodoEntity(category: category, todoEntity: todo)
        if isCompleted {
            testTodoList[category.title, default: []].append(todo)
        }
    }
    
    func updateTodo<T: TestEntity & NSManagedObject>(category: Category, todo: T) {
        guard let index = testTodoList[category.title, default: []].firstIndex(where: { $0.objectID == todo.objectID }) else { return }
        testTodoList[category.title, default: []][index] = todo
        let isCompleted = todoEntityManager.updateTodoEntity(category: category, todoEntity: todo)
        if isCompleted {
            testTodoList[category.title, default: []][index] = todo
        }
    }
    
    func removeTodo<T: TestEntity & NSManagedObject>(category: Category, todo: T) {
        let isCompleted = todoEntityManager.removeTodoEntity(category: category, todoEntity: todo)
        if isCompleted {
            testTodoList[category.title, default: []].removeAll(where: { $0.objectID == todo.objectID })
        }
    }
    
    private func convertToDictionay() {
        for categoryEntity in testTodoEntity {
            guard let checkTodoEntity = categoryEntity.checkTodoEntity?.array as? [CheckTodoEntity],
                  let countTodoEntity = categoryEntity.countTodoEntity?.array as? [CountTodoEntity] else { continue }
            testTodoList[categoryEntity.title] = checkTodoEntity
            testTodoList[categoryEntity.title, default: []].append(contentsOf: countTodoEntity)
            testTodoList[categoryEntity.title, default: []].sort{ $0.createDate < $1.createDate }
        }
    }
}

//MARK: CategoryEntity 활용
extension TodoManager {
    func categoryCount() -> Int {
        return testTodoEntity.count
    }
    func category(at index: Int) -> Category? {
        let title = testTodoEntity[index].title
        guard let category = Category(rawValue: title) else { return nil }
        return category
    }
    func categoryTitle(index: Int) -> String {
        return testTodoEntity[index].title
    }
    func todoCount(category: Category) -> Int {
        return testTodoList[category.title, default: []].count
    }
    func completeTodoCount(category: Category) -> Int {
        return testTodoList[category.title, default: []].filter{ $0.isCompleted }.count
    }
    func todo(category: Category, at index: Int) -> TestEntity & NSManagedObject {
        let categoryTodoList = testTodoList[category.title, default: []]
        return categoryTodoList[index]
    }
    func completeTodo(category: Category, at index: Int) -> TestEntity & NSManagedObject {
        let categoryTodoList = testTodoList[category.title, default: []].filter{ $0.isCompleted }
        return categoryTodoList[index]
    }
}
