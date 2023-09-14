//
//  CheckTodoEntity+CoreDataProperties.swift
//  Todo
//
//  Created by 김도현 on 2023/09/14.
//
//

import Foundation
import CoreData


extension CheckTodoEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CheckTodoEntity> {
        return NSFetchRequest<CheckTodoEntity>(entityName: "CheckTodoEntity")
    }

    @NSManaged public var id: UUID
    @NSManaged public var title: String
    @NSManaged public var isCompleted: Bool
    @NSManaged public var createDate: Date
    @NSManaged public var modifyDate: Date?
    @NSManaged public var doneDate: Date?
    @NSManaged public var category: Int16

}

extension CheckTodoEntity {
    func convertToCheckTodo() -> CheckTodo? {
        let checkTask = CheckTodo(id: id, title: title, createDate: createDate, isCompleted: isCompleted)
        return checkTask
    }
}

extension CheckTodoEntity : Identifiable {

}
