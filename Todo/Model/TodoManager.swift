//
//  TodoManager.swift
//  Todo
//
//  Created by 김도현 on 2023/07/31.
//

import Foundation

enum Category: CaseIterable, Codable {
    case work
    case life
    
    var title: String {
        switch self {
        case .life:
            return "life"
        case .work:
            return "work"
        }
    }
}

enum TodoType: CaseIterable {
    case check
    case count
    
    func type() -> (Task & Codable).Type {
        switch self {
        case .check:
            return CheckTodo.self
        case .count:
            return CountTodo.self
        }
    }
}

class TodoManager {
    
    static let shared: TodoManager = TodoManager()
    
    private var standard = UserDefaults.standard
    
    typealias Todo = Task & Codable
    
    private var todoList: [String : [Task]] = [:]
    
    private init() {
        initTodoList()
    }

    private func initTodoList() {
        let categoryAllCase: [Category] = Category.allCases
        var tempTodoList = [String: [Todo]]()
        categoryAllCase.forEach { category in
            tempTodoList[category.title] = []
        }
                
        let todoAllCase: [TodoType] = TodoType.allCases
        todoAllCase.forEach { todoType in
            tempTodoList = configData(todoType: todoType.type(), tempTodoList: tempTodoList)
        }
        
        self.todoList = sortTodoList(tempTodoList: tempTodoList)
    }
    
    private func configData<T: Todo>(todoType: T.Type, tempTodoList: [String : [Todo]]) -> [String : [Todo]] {
        var tempTodoList = tempTodoList
        let decoder = JSONDecoder()
        if let genericTodoData = standard.data(forKey: T.userDefaultsId),
           let genericTodo = try? decoder.decode([String : [T]].self, from: genericTodoData) {
            genericTodo.keys.forEach { category in
                tempTodoList[category]!.append(contentsOf: genericTodo[category] ?? [])
            }
        } else {
            var emptyTodoList = [String : [T]]()
            let categoryAllCase: [Category] = Category.allCases
            categoryAllCase.forEach { category in
                emptyTodoList[category.title] = [T]()
            }
            let encoder = JSONEncoder()
            do {
                let data = try encoder.encode(emptyTodoList)
                standard.set(data, forKey: T.userDefaultsId)
            } catch let e {
                print(e.localizedDescription)
            }
        }
        return tempTodoList
    }
    
    private func fetchData<T: Todo>(todoType: T.Type) -> [String : [T]] {
        var tempTodoList = [String : [T]]()
        let decoder = JSONDecoder()
        if let genericTodoData = standard.data(forKey: T.userDefaultsId),
           let genericTodo = try? decoder.decode([String : [T]].self, from: genericTodoData) {
            tempTodoList = genericTodo
        }
        return tempTodoList
    }
    
    private func sortTodoList(tempTodoList: [String : [Todo]]) -> [String : [Todo]] {
        var tempTodoList = tempTodoList
        let categoryAllCase = Category.allCases
        categoryAllCase.forEach { category in
            if let categoryTodo = tempTodoList[category.title] {
                tempTodoList[category.title] = categoryTodo.sorted { $0.createTime < $1.createTime }
            }
        }
        return tempTodoList
    }
    
    func todoCount(category: Category) -> Int {
        guard let categoryTodo = todoList[category.title] else { return 0 }
        return categoryTodo.count
    }
    
    func todoCompleteCount(category: Category) -> Int {
        let completeTodo = todoList[category.title]?.filter { $0.isCompleted }
        return completeTodo?.count ?? 0
    }
    
    func todo(category: Category, at index: Int) -> Task? {
        guard let categoryTodo = todoList[category.title] else { return nil }
        return categoryTodo[index]
    }
    
    func completeTodo(category: Category, at index: Int) -> Task? {
        guard let categoryTodo = todoList[category.title] else { return nil }
        let completeTodo = categoryTodo.filter { $0.isCompleted }
        return completeTodo[index]
    }
    
    func add<T: Todo>(category: Category, todo: T) {
        guard todoList[category.title] != nil else { return }
        var genericTodo = fetchData(todoType: T.self)
        guard genericTodo[category.title] != nil else { return }
        
        let encoder = JSONEncoder()
        self.todoList[category.title]?.append(todo)
        genericTodo[category.title]?.append(todo)
        do {
            let data = try encoder.encode(genericTodo)
            standard.set(data, forKey: T.userDefaultsId)
        } catch let e {
            print(e.localizedDescription)
        }
    }
    
    func update<T: Todo>(todoType: T.Type, category: Category, todo: T) {
        guard todoList[category.title] != nil else { return }
        var userdefaultsTodo = fetchData(todoType: T.self)
        guard userdefaultsTodo[category.title] != nil else { return }
        
        let encoder = JSONEncoder()
        guard let updateTodoIndex = todoList[category.title]!.firstIndex(where: { $0.id == todo.id }) else { return }
        guard let userdefaultUpdateTodoIndex = userdefaultsTodo[category.title]!.firstIndex(where: { $0.id == todo.id }) else { return }
        todoList[category.title]![updateTodoIndex] = todo
        userdefaultsTodo[category.title]![userdefaultUpdateTodoIndex] = todo
        do {
            let data = try encoder.encode(userdefaultsTodo)
            standard.set(data, forKey: T.userDefaultsId)
        } catch let e {
            print(e.localizedDescription)
        }
    }
    
    func remove<T: Todo>(todoType: T.Type, category: Category, id: UUID) {
        guard todoList[category.title] != nil else { return }
        var userdefaultsTodo = fetchData(todoType: T.self)
        guard userdefaultsTodo[category.title] != nil else { return }
        
        todoList[category.title]!.removeAll { $0.id == id }
        userdefaultsTodo[category.title]!.removeAll { $0.id == id }
        
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(userdefaultsTodo)
            standard.set(data, forKey: T.userDefaultsId)
        } catch let e {
            print(e.localizedDescription)
        }
    }
}
