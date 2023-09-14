//
//  PersistentContainer.swift
//  Todo
//
//  Created by 김도현 on 2023/09/13.
//

import CoreData

class TodoEntityManager {
    
    static let shared: TodoEntityManager = TodoEntityManager()
    var todoEntity: [TodoEntity] = []
    private let context: NSManagedObjectContext
    
    private init() {
        let container = NSPersistentContainer(name: "Todo")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        self.context = container.viewContext
        todoEntity = fetchAll()
    }
            
    func fetchAll() -> [TodoEntity] {
        let fecthRequest = NSFetchRequest<TodoEntity>(entityName: "TodoEntity")
        let todo = fetchObject(request: fecthRequest)
        return todo
    }
    
    func addEntity(todoData: Data, category: Category) -> Bool {
        if let entity = NSEntityDescription.entity(forEntityName: "TodoEntity", in: context) {
            let todoEntity = TodoEntity(entity: entity, insertInto: context)
            switch category {
            case .work:
                todoEntity.checkTodoData = todoData
            case .life:
                todoEntity.counTodoData = todoData
            }
            return saveContext()
        }
        print("Not Found TodoEntity")
        return false
    }
    
    func fetchObject<T: NSManagedObject>(request: NSFetchRequest<T>) -> [T] {
        do {
            let objectList = try context.fetch(request)
            return objectList
        } catch let e {
            print(e.localizedDescription)
            return []
        }
    }
    
    private func saveContext() -> Bool {
        do {
            try context.save()
            return true
        } catch let error as NSError {
            print("Error: \(error), \(error.userInfo)")
            return false
        }
    }
}
