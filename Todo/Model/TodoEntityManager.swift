//
//  PersistentContainer.swift
//  Todo
//
//  Created by 김도현 on 2023/09/13.
//

import CoreData

class TodoEntityManager {
    
    static let shared: TodoEntityManager = TodoEntityManager()
    var categoryEntityList: [CategoryEntity] = []
    let context: NSManagedObjectContext
    
    private init() {
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
    
    func addTodoEntity<T: NSManagedObject & TestEntity>(category: Category, todoEntity: T) -> Bool {
        guard let index = categoryEntityList.firstIndex(where: { $0.title == category.title }) else { return false }
        var categoryEntity = categoryEntityList[index]

        todoEntity.addIntoCategoryEntity(categoryEntity: categoryEntity)
        return saveContext()
    }
        
    func updateTodoEntity<T: NSManagedObject & TestEntity>(category: Category, todoEntity: T) -> Bool {
        todoEntity.updateIntoCategoryEntity()
        return saveContext()
    }
    
    func removeTodoEntity<T: NSManagedObject & TestEntity>(category: Category, todoEntity: T) -> Bool {
        context.delete(todoEntity)
        return saveContext()
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
