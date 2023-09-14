//
//  TodoEntity+CoreDataProperties.swift
//  Todo
//
//  Created by 김도현 on 2023/09/14.
//
//

import Foundation
import CoreData


extension TodoEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodoEntity> {
        return NSFetchRequest<TodoEntity>(entityName: "TodoEntity")
    }

    @NSManaged public var counTodoData: Data?
    @NSManaged public var checkTodoData: Data?
    @NSManaged public var checkTodoEntites: NSSet?
    @NSManaged public var countTodoEntites: NSSet?

}

// MARK: Generated accessors for checkTodoEntites
extension TodoEntity {

    @objc(addCheckTodoEntitesObject:)
    @NSManaged public func addToCheckTodoEntites(_ value: CheckTodoEntity)

    @objc(removeCheckTodoEntitesObject:)
    @NSManaged public func removeFromCheckTodoEntites(_ value: CheckTodoEntity)

    @objc(addCheckTodoEntites:)
    @NSManaged public func addToCheckTodoEntites(_ values: NSSet)

    @objc(removeCheckTodoEntites:)
    @NSManaged public func removeFromCheckTodoEntites(_ values: NSSet)

}

// MARK: Generated accessors for countTodoEntites
extension TodoEntity {

    @objc(addCountTodoEntitesObject:)
    @NSManaged public func addToCountTodoEntites(_ value: CountTodoEntity)

    @objc(removeCountTodoEntitesObject:)
    @NSManaged public func removeFromCountTodoEntites(_ value: CountTodoEntity)

    @objc(addCountTodoEntites:)
    @NSManaged public func addToCountTodoEntites(_ values: NSSet)

    @objc(removeCountTodoEntites:)
    @NSManaged public func removeFromCountTodoEntites(_ values: NSSet)

}

extension TodoEntity : Identifiable {

}
