//
//  CheckTodo.swift
//  Todo
//
//  Created by 김도현 on 2023/09/21.
//

import Foundation
import UIKit

struct CheckTodo: Task {
    var id: UUID = UUID()
    var createDate: Date
    var modifyDate: Date? = nil
    var doneDate: Date? = nil
    var title: String

    var isCompleted: Bool = false {
        didSet {
            if isCompleted { doneDate = Date() }
            else { doneDate = nil }
        }
    }

    init(title: String, createDate: Date = Date(), doneDate: Date? = nil, isCompleted: Bool = false) {
        self.title = title
        self.createDate = createDate
        self.isCompleted = isCompleted
        self.doneDate = doneDate
    }
}
