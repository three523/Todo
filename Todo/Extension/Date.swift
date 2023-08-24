//
//  ExtensionDate.swift
//  Todo
//
//  Created by 김도현 on 2023/08/24.
//

import Foundation

extension Date {
    func dateTimeString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일 hh:mm"
        return dateFormatter.string(from: self)
    }
}
