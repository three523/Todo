//
//  Task.swift
//  Todo
//
//  Created by 김도현 on 2023/08/24.
//

import Foundation
import UIKit

protocol Task {
    var id: UUID { get }
    var title: String { get set }
    var isCompleted: Bool { get set }
    var createDate: Date { get }
    var modifyDate: Date? { get set }
    var doneDate: Date? { get set }
    
}

protocol TaskEntity {
    var id: UUID { get }
    var title: String { get set }
    var isCompleted: Bool { get set }
    var createDate: Date { get }
    var modifyDate: Date? { get set }
    var doneDate: Date? { get set }
    
    func addIntoCategoryEntity(categoryEntity: CategoryEntity)
    func removeIntoCategoryEntity()
    func updateIntoCategoryEntity()
    func todoCell(tableView: UITableView, indexPath: IndexPath, viewContoller: UpdateTodoDelegate) -> UITableViewCell?
}

