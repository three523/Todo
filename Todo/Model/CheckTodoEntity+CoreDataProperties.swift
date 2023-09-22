//
//  CheckTodoEntity+CoreDataProperties.swift
//  Todo
//
//  Created by 김도현 on 2023/09/15.
//
//

import Foundation
import CoreData
import UIKit


extension CheckTodoEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CheckTodoEntity> {
        return NSFetchRequest<CheckTodoEntity>(entityName: "CheckTodoEntity")
    }

    @NSManaged public var id: UUID
    @NSManaged public var createDate: Date
    @NSManaged public var doneDate: Date?
    @NSManaged public var isCompleted: Bool
    @NSManaged public var modifyDate: Date?
    @NSManaged public var title: String
    @NSManaged public var categoryEntity: CategoryEntity?

}

extension CheckTodoEntity: TaskEntity {
    func addIntoCategoryEntity(categoryEntity: CategoryEntity) {
        categoryEntity.addToCheckTodoEntity(self)
    }
    func removeIntoCategoryEntity() {
        guard let categoryEntity else { return }
        categoryEntity.removeFromCheckTodoEntity(self)
    }
    func updateIntoCategoryEntity() {
        guard var checkTodoEntityList = (categoryEntity?.checkTodoEntity?.array as? [CheckTodoEntity]),
              let checkTodoEntityIndex = checkTodoEntityList.firstIndex(where: { $0.id == self.id }) else { return }
        checkTodoEntityList[checkTodoEntityIndex] = self
    }
    func todoCell(tableView: UITableView, indexPath: IndexPath, viewContoller: UpdateTodoDelegate) -> UITableViewCell? {
        guard let cell: CheckTodoTableViewCell = tableView.dequeueReusableCell(for: indexPath),
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

extension CheckTodoEntity : Identifiable {

}
