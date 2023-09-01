//
//  ErrorView.swift
//  Todo
//
//  Created by 김도현 on 2023/08/31.
//

import UIKit

final class ErrorView: UIView {
    
    private let errorImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "xmark"))
        imageView.tintColor = .mainColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let errorLabel = {
        let lb = UILabel()
        lb.text = "오류가 발생하였습니다.\n다시시도 해주세요"
        lb.numberOfLines = 2
        lb.textAlignment = .center
        lb.font = .systemFont(ofSize: 16, weight: .regular)
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(errorImageView)
        addSubview(errorLabel)
        
        configAutolayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configAutolayout() {
        NSLayoutConstraint.activate([
            errorImageView.widthAnchor.constraint(equalToConstant: 40),
            errorImageView.heightAnchor.constraint(equalToConstant: 40),
            errorImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            errorImageView.bottomAnchor.constraint(equalTo: self.centerYAnchor, constant: -8),
            
            errorLabel.topAnchor.constraint(equalTo: self.centerYAnchor, constant: 8),
            errorLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        ])
    }
    
    func configConnectedToInternet(isConnectedToInternet: Bool) {
        if isConnectedToInternet {
            errorImageView.image = UIImage(systemName: "xmark")
            errorLabel.text = "오류가 발생하였습니다.\n다시시도 해주세요"
        } else {
            errorImageView.image = UIImage(systemName: "arrow.triangle.2.circlepath")
            errorLabel.text = "인터넷 연결이 불안정합니다\n연결후 다시 시도해주세요"
        }
    }
    
}
