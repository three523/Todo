//
//  PersistentContainer.swift
//  Todo
//
//  Created by 김도현 on 2023/09/13.
//

import CoreData

class TodoEntityManager {
    
    var categoryEntityList: [CategoryEntity] = []
    let context: NSManagedObjectContext
    
    init() {
        let container = NSPersistentContainer(name: "Todo")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        self.context = container.viewContext
        categoryEntityList = fetch()
        categoryEntityList.forEach { entity in
            print(entity.title)
        }
    }
            
    func fetch() -> [CategoryEntity] {
        let fecthRequest = NSFetchRequest<CategoryEntity>(entityName: "CategoryEntity")
        do {
            var objectList = try context.fetch(fecthRequest)
            if objectList.count != Category.allCases.count {
                objectList = initCategoryEntityList()
            }
            return objectList
        } catch let e {
            print(e.localizedDescription)
        }
        return []
    }
    
    //TODO: 카테고리 리스트가 늘어날 경우 추가로 생긴 카데리고 리스트를 만들도록 작업하기
    private func initCategoryEntityList() -> [CategoryEntity] {
        let categoryAllCases = Category.allCases
        var initCategoryEntityList = [CategoryEntity]()
        categoryAllCases.forEach { category in
            if let entity = NSEntityDescription.entity(forEntityName: "CategoryEntity", in: context) {
                let categoryEntity = CategoryEntity(entity: entity, insertInto: context)
                categoryEntity.title = category.title
                categoryEntity.checkTodoEntity = NSOrderedSet(array: [])
                categoryEntity.countTodoEntity = NSOrderedSet(array: [])
                initCategoryEntityList.append(categoryEntity)
            }
        }
        saveContext()
        return initCategoryEntityList
    }
    
    func createCheckTodoEntity(category: Category, checkTodo: CheckTodo) -> CheckTodoEntity? {
        if let entity = NSEntityDescription.entity(forEntityName: "CheckTodoEntity", in: context) {
            let checkTodoEntity = CheckTodoEntity(entity: entity, insertInto: context)
            checkTodoEntity.createDate = Date()
            checkTodoEntity.isCompleted = false
            checkTodoEntity.title = checkTodo.title
            guard let categoryEntity = categoryEntityList.first(where: { $0.title == category.title }) else { return nil }
            checkTodoEntity.addIntoCategoryEntity(categoryEntity: categoryEntity)
            saveContext()
            return checkTodoEntity
        }
        return nil
    }
    
    func createCountTodoEntity(category: Category, countTodo: CountTodo) -> CountTodoEntity? {
        if let entity = NSEntityDescription.entity(forEntityName: "CountTodoEntity", in: context) {
            let countTodoEntity = CountTodoEntity(entity: entity, insertInto: context)
            countTodoEntity.createDate = Date()
            countTodoEntity.isCompleted = false
            countTodoEntity.title = countTodo.title
            countTodoEntity.goal = Int16(countTodo.goal)
            guard let categoryEntity = categoryEntityList.first(where: { $0.title == category.title }) else { return nil }
            countTodoEntity.addIntoCategoryEntity(categoryEntity: categoryEntity)
            saveContext()
            return countTodoEntity
        }
        return nil
    }
    
    func addTodoEntity<T: NSManagedObject & TaskEntity>(category: Category, todoEntity: T) -> Bool {
        guard let index = categoryEntityList.firstIndex(where: { $0.title == category.title }) else { return false }
        var categoryEntity = categoryEntityList[index]

        todoEntity.addIntoCategoryEntity(categoryEntity: categoryEntity)
        return saveContext()
    }
        
    func updateTodoEntity<T: TaskEntity>(category: Category, todoEntity: T) -> Bool {
        todoEntity.updateIntoCategoryEntity()
        return saveContext()
    }
    
    func removeTodoEntity<T: TaskEntity>(category: Category, todoEntity: T) -> Bool {
        guard let todoEntity = todoEntity as? NSManagedObject else { return false }
        context.delete(todoEntity)
        return saveContext()
    }
    
    func saveContext() -> Bool {
        do {
            try context.save()
            return true
        } catch let error as NSError {
            print("Error: \(error), \(error.userInfo)")
            return false
        }
    }
}
