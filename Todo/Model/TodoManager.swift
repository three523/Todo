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
    
    private init() {
        initTodoList()
    }

    private func initTodoList() {
        guard let todoEntity = todoEntityManager.todoEntity else { return }
        if let checkTodoData = todoEntity.checkTodoData {
            let checkTodo = decodeData(todoType: CheckTodo.self, data: checkTodoData)
            checkTodo.forEach { category, checkTodoList in
                todoList[category, default: []].append(contentsOf: checkTodoList)
            }
        }
        if let countTodoData = todoEntity.counTodoData {
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
        guard let entity = todoEntityManager.todoEntity,
              let data = entity.checkTodoData else { return tempTodoList }
        do {
            tempTodoList = try decoder.decode([String : [T]].self, from: data)
        } catch let e {
            print(e.localizedDescription)
        }
        return tempTodoList
    }
    
    
    //TODO: 투두리스트중에 카운트나 체크 투두리스트만 가져오는데 CoreData에서 가져오는게 빠를까? todoList 프로퍼티에서 필터를 돌며 가져오는게 빠를까?
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
    
    private func add<T: Todo>(category: Category, todo: T) -> [String : [T]] {
        var genericTodo = fetchCategoryTodo(todoType: T.self, category: category)
        
        todoList[category.title, default: []].append(todo)
        genericTodo[category.title, default: []].append(todo)
        
        return genericTodo
    }
    
    private func update<T: Todo>(category: Category, todo: T) -> [String : [T]] {
        guard todoList[category.title] != nil else { return [:]}
        var categoryTodoList = fetchCategoryTodo(todoType: T.self, category: category)
        
        guard let updateTodoIndex = todoList[category.title, default: []].firstIndex(where: { $0.id == todo.id }) else { return [:] }
        guard let userdefaultUpdateTodoIndex = categoryTodoList[category.title, default: []].firstIndex(where: { $0.id == todo.id }) else { return [:] }
        todoList[category.title]![updateTodoIndex] = todo
        categoryTodoList[category.title]![userdefaultUpdateTodoIndex] = todo
        
        return categoryTodoList
    }
    
    private func remove<T: Todo>(category: Category, todo: T) -> [String : [T]] {
        var categoryTodoList = fetchCategoryTodo(todoType: T.self, category: category)
        todoList[category.title, default: []].removeAll { $0.id == todo.id }
        categoryTodoList[category.title, default: []].removeAll { $0.id == todo.id }
        return categoryTodoList
    }
    
    func todoUpdate<T: Todo>(todo: T, category: Category, state: UpdateState) {
        let tempTodoList = todoList
        var categoryTodoList = [String : [T]]()
        
        switch state {
        case .create:
            categoryTodoList = add(category: category, todo: todo)
        case .update:
            categoryTodoList = update(category: category, todo: todo)
        case .remove:
            categoryTodoList = remove(category: category, todo: todo)
        }
        
        guard let data = encodeTodo(todoList: categoryTodoList) else {
            todoList = tempTodoList
            return
        }
        let isComplete = todoEntityManager.addEntity(todoData: data, category: category)
        if !isComplete { todoList = tempTodoList }
    }
    
    private func encodeTodo<T: Encodable>(todoList: [String : [T]]) -> Data? {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(todoList)
            print(data.base64EncodedString())
            return data
        } catch let e {
            print(e.localizedDescription)
        }
        return nil
    }
    
    private func decodeData<T: Todo>(todoType: T.Type, data: Data) -> [String : [T]] {
        print(data.base64EncodedString())
        var tempTodoList = [String : [T]]()
        let decoder = JSONDecoder()
        do {
            let todo = try decoder.decode([String : [T]].self, from: data)
            tempTodoList = todo
        } catch let DecodingError.dataCorrupted(context) {
            print(DecodingError.dataCorrupted(context))
        } catch let DecodingError.valueNotFound(value, context) {
            print(DecodingError.valueNotFound(value, context))
        } catch let DecodingError.keyNotFound(key, context) {
            print(DecodingError.keyNotFound(key, context))
        } catch let DecodingError.typeMismatch(type, context)  {
            print(DecodingError.typeMismatch(type, context))
        } catch let error {
            print(error)
        }
        return tempTodoList
    }
}
