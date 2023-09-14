//
//  CountTodoEntity+CoreDataProperties.swift
//  Todo
//
//  Created by 김도현 on 2023/09/14.
//
//

import Foundation
import CoreData


extension CountTodoEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CountTodoEntity> {
        return NSFetchRequest<CountTodoEntity>(entityName: "CountTodoEntity")
    }

    @NSManaged public var id: UUID
    @NSManaged public var createDate: Date
    @NSManaged public var modifyDate: Date?
    @NSManaged public var doneDate: Date?
    @NSManaged public var title: String
    @NSManaged public var count: Int16
    @NSManaged public var goal: Int16
    @NSManaged public var isCompleted: Bool
    @NSManaged public var category: Int16
}

extension CountTodoEntity {
    func convertToCountTodo() -> CheckTodo? {
        let checkTask = CheckTodo(id: id, title: title, createDate: createDate, isCompleted: isCompleted)
        return checkTask
    }
}

extension CountTodoEntity : Identifiable {

}
