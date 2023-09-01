//
//  NetworkError.swift
//  Todo
//
//  Created by 김도현 on 2023/09/01.
//

import Foundation

enum NetworkError: Error {
    
    case url
    case decode(DecodingError)
    case transport(Error)
    case cancel
    case notConnectedToInternet
    case server(Int)
    case data
    case other(Error)
    
    var message: String {
        switch self {
        case .url:
            return "Url이 존재하지 않습니다"
        case .decode(let error):
            return error.localizedDescription
        case .transport(let error):
            return error.localizedDescription
        case .cancel:
            return URLError(.cancelled).localizedDescription
        case .notConnectedToInternet:
            return URLError(.notConnectedToInternet).localizedDescription
        case .server(let statusCode):
            return "HTTP StatusCode: \(statusCode)"
        case .data:
            return "Data의 값이 존재하지 않습니다"
        case .other(let error):
            return error.localizedDescription
        }
    }
}
