//
//  PostCollectionViewCell.swift
//  Todo
//
//  Created by 김도현 on 2023/09/20.
//

import UIKit

final class PostCollectionViewCell: UICollectionViewCell, ReusableCell {
    var imageView: UIImageView = UIImageView(image: nil)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PostCollectionViewCell {
    func setup() {
        addViews()
        autoLayoutSetup()
    }
    func addViews() {
        contentView.addSubview(imageView)
    }
    func autoLayoutSetup() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
