//
//  CatImageView.swift
//  Todo
//
//  Created by 김도현 on 2023/08/31.
//

import UIKit

protocol DataLoding {
    var errorView: ErrorView { get }
    var lodingView: UIActivityIndicatorView { get }
    var viewState: ViewState { get set }
    
    func update()
}

extension DataLoding where Self: UIView {
    func update() {
        DispatchQueue.main.async {
            switch self.viewState {
            case .loading:
                self.lodingView.startAnimating()
                self.lodingView.isHidden = false
                self.errorView.isHidden = true
            case .loaded:
                self.lodingView.stopAnimating()
                self.lodingView.isHidden = true
                self.errorView.isHidden = true
            case .error(let isConnectedToInternet):
                self.lodingView.stopAnimating()
                self.lodingView.isHidden = true
                self.errorView.isHidden = false
                self.errorView.configConnectedToInternet(isConnectedToInternet: isConnectedToInternet)
            }
        }
    }
}

final class CatImageView: UIImageView, DataLoding {
    var errorView: ErrorView = ErrorView()
    var lodingView: UIActivityIndicatorView = UIActivityIndicatorView(style: .medium)
    var viewState: ViewState {
        didSet {
            update()
        }
    }
    
    init(state: ViewState) {
        viewState = state
        super.init(frame: .zero)
        
        self.addSubview(errorView)
        self.addSubview(lodingView)
        
        setUp()
        configAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        viewState = .loading
        super.init(coder: coder)
    }
    
    private func setUp() {
        errorView.isHidden = true
        lodingView.isHidden = false
        lodingView.startAnimating()
    }
    
    private func configAutoLayout() {
        errorView.translatesAutoresizingMaskIntoConstraints = false
        lodingView.translatesAutoresizingMaskIntoConstraints = false
        
        
        errorView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        errorView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        lodingView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        lodingView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        lodingView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        lodingView.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
}
