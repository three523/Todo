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
    
    private var todoEntityManager: TodoEntityManager = TodoEntityManager()
        
    private var testTodoList: [String : [TaskEntity]] = [:]
    var testTodoEntity: [CategoryEntity] = []
    
    init() {
        initTodoList()
    }

    private func initTodoList() {
        testTodoEntity = todoEntityManager.categoryEntityList
        convertToDictionay()
    }
    
    func addTodo(category: Category, checkTodo: CheckTodo) {
        guard let todoEntity = todoEntityManager.createCheckTodoEntity(category: category, checkTodo: checkTodo) else { return }
        testTodoList[category.title, default: []].append(todoEntity)
        addEntity(category: category, todo: todoEntity)
    }
    
    func addTodo(category: Category, countTodo: CountTodo) {
        guard let todoEntity = todoEntityManager.createCountTodoEntity(category: category, countTodo: countTodo) else { return }
        addEntity(category: category, todo: todoEntity)
    }
    
    private func addEntity<T: TaskEntity & NSManagedObject>(category: Category, todo: T) {
        let isCompleted = todoEntityManager.addTodoEntity(category: category, todoEntity: todo)
        if isCompleted {
            testTodoList[category.title, default: []].append(todo)
        }
    }
    
    func updateTodo<T: TaskEntity>(category: Category, todo: T) {
        todoEntityManager.saveContext()
    }
    
    //TODO: 내가 만든 프로토콜을 사용해서는 인덱스를 확인하면 에러가 남. 다른 방법 찾아보기
    func removeTodo<T: TaskEntity>(category: Category, todo: T) {
        guard let managedObjectList = testTodoList[category.title, default: []] as? ([NSManagedObject]),
            let entityTodo = todo as? NSManagedObject else { return }
        guard let index = managedObjectList.firstIndex(where: { $0.objectID == entityTodo.objectID }) else { return }
        let isCompleted = todoEntityManager.removeTodoEntity(category: category, todoEntity: todo)
        testTodoList[category.title, default: []].remove(at: index)
        
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
    func todo(category: Category, at index: Int) -> TaskEntity {
        let categoryTodoList = testTodoList[category.title, default: []]
        return categoryTodoList[index]
    }
    func completeTodo(category: Category, at index: Int) -> TaskEntity {
        let categoryTodoList = testTodoList[category.title, default: []].filter{ $0.isCompleted }
        return categoryTodoList[index]
    }
}
