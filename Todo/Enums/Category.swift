//
//  Category.swift
//  Todo
//
//  Created by 김도현 on 2023/09/01.
//

import Foundation

enum Category: String, CaseIterable, Codable {
    case work = "work"
    case life = "life"
    
    var title: String {
        switch self {
        case .life:
            return "life"
        case .work:
            return "work"
        }
    }
}
