//
//  CategoryEntity+CoreDataProperties.swift
//  Todo
//
//  Created by 김도현 on 2023/09/15.
//
//

import Foundation
import CoreData


extension CategoryEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CategoryEntity> {
        return NSFetchRequest<CategoryEntity>(entityName: "CategoryEntity")
    }

    @NSManaged public var title: String
    @NSManaged public var countTodoEntity: NSOrderedSet?
    @NSManaged public var checkTodoEntity: NSOrderedSet?

}

// MARK: Generated accessors for countTodoEntity
extension CategoryEntity {

    @objc(insertObject:inCountTodoEntityAtIndex:)
    @NSManaged public func insertIntoCountTodoEntity(_ value: CountTodoEntity, at idx: Int)

    @objc(removeObjectFromCountTodoEntityAtIndex:)
    @NSManaged public func removeFromCountTodoEntity(at idx: Int)

    @objc(insertCountTodoEntity:atIndexes:)
    @NSManaged public func insertIntoCountTodoEntity(_ values: [CountTodoEntity], at indexes: NSIndexSet)

    @objc(removeCountTodoEntityAtIndexes:)
    @NSManaged public func removeFromCountTodoEntity(at indexes: NSIndexSet)

    @objc(replaceObjectInCountTodoEntityAtIndex:withObject:)
    @NSManaged public func replaceCountTodoEntity(at idx: Int, with value: CountTodoEntity)

    @objc(replaceCountTodoEntityAtIndexes:withCountTodoEntity:)
    @NSManaged public func replaceCountTodoEntity(at indexes: NSIndexSet, with values: [CountTodoEntity])

    @objc(addCountTodoEntityObject:)
    @NSManaged public func addToCountTodoEntity(_ value: CountTodoEntity)

    @objc(removeCountTodoEntityObject:)
    @NSManaged public func removeFromCountTodoEntity(_ value: CountTodoEntity)

    @objc(addCountTodoEntity:)
    @NSManaged public func addToCountTodoEntity(_ values: NSOrderedSet)

    @objc(removeCountTodoEntity:)
    @NSManaged public func removeFromCountTodoEntity(_ values: NSOrderedSet)

}

// MARK: Generated accessors for checkTodoEntity
extension CategoryEntity {

    @objc(insertObject:inCheckTodoEntityAtIndex:)
    @NSManaged public func insertIntoCheckTodoEntity(_ value: CheckTodoEntity, at idx: Int)

    @objc(removeObjectFromCheckTodoEntityAtIndex:)
    @NSManaged public func removeFromCheckTodoEntity(at idx: Int)

    @objc(insertCheckTodoEntity:atIndexes:)
    @NSManaged public func insertIntoCheckTodoEntity(_ values: [CheckTodoEntity], at indexes: NSIndexSet)

    @objc(removeCheckTodoEntityAtIndexes:)
    @NSManaged public func removeFromCheckTodoEntity(at indexes: NSIndexSet)

    @objc(replaceObjectInCheckTodoEntityAtIndex:withObject:)
    @NSManaged public func replaceCheckTodoEntity(at idx: Int, with value: CheckTodoEntity)

    @objc(replaceCheckTodoEntityAtIndexes:withCheckTodoEntity:)
    @NSManaged public func replaceCheckTodoEntity(at indexes: NSIndexSet, with values: [CheckTodoEntity])

    @objc(addCheckTodoEntityObject:)
    @NSManaged public func addToCheckTodoEntity(_ value: CheckTodoEntity)

    @objc(removeCheckTodoEntityObject:)
    @NSManaged public func removeFromCheckTodoEntity(_ value: CheckTodoEntity)

    @objc(addCheckTodoEntity:)
    @NSManaged public func addToCheckTodoEntity(_ values: NSOrderedSet)

    @objc(removeCheckTodoEntity:)
    @NSManaged public func removeFromCheckTodoEntity(_ values: NSOrderedSet)

}

extension CategoryEntity : Identifiable {

}
