//
//  ViewState.swift
//  Todo
//
//  Created by 김도현 on 2023/09/13.
//

enum ViewState {
    typealias isConnectedToInternet = Bool
    case loading
    case loaded
    case error(isConnectedToInternet)
}
