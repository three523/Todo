//
//  CountTodoEntity+CoreDataProperties.swift
//  Todo
//
//  Created by 김도현 on 2023/09/15.
//
//

import Foundation
import CoreData
import UIKit


extension CountTodoEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CountTodoEntity> {
        return NSFetchRequest<CountTodoEntity>(entityName: "CountTodoEntity")
    }

    @NSManaged public var count: Int16
    @NSManaged public var createDate: Date
    @NSManaged public var doneDate: Date?
    @NSManaged public var goal: Int16
    @NSManaged public var isCompleted: Bool
    @NSManaged public var modifyDate: Date?
    @NSManaged public var title: String
    @NSManaged public var categoryEntity: CategoryEntity?

}

extension CountTodoEntity: TestEntity {
    func addIntoCategoryEntity(categoryEntity: CategoryEntity) {
        categoryEntity.addToCountTodoEntity(self)
    }
    func removeIntoCategoryEntity() {
        guard let categoryEntity else { return }
        categoryEntity.removeFromCountTodoEntity(self)
    }
    func updateIntoCategoryEntity() {
        guard var countTodoEntityList = (categoryEntity?.countTodoEntity?.array as? [CountTodoEntity]),
              let countTodoEntityIndex = countTodoEntityList.firstIndex(where: { $0.id == self.id }) else { return }
        countTodoEntityList[countTodoEntityIndex] = self
    }
    func todoCell(tableView: UITableView, indexPath: IndexPath, viewContoller: UpdateTodoDelegate) -> UITableViewCell? {
        guard let cell: CountTodoTableViewCell = tableView.dequeueReusableCell(for: indexPath),
              let categoryTitle = categoryEntity?.title,
              let category = Category(rawValue: categoryTitle) else { return nil }
        cell.testUiUpdate(todo: self, category: category)
        cell.delegate = viewContoller
        return cell
    }
    func relationshipEntity() -> NSManagedObject? {
        return categoryEntity
    }
}

extension CountTodoEntity : Identifiable {

}
