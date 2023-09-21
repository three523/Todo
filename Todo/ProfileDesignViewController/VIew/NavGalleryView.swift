//
//  NavgalleryView.swift
//  Todo
//
//  Created by 김도현 on 2023/09/20.
//

import UIKit

final class NavGalleryView: UIView {
    
    private let gridImageButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "squareshape.split.3x3"), for: .normal)
        button.tintColor = .black
        return button
    }()
    private let horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 2
        return stackView
    }()
    private let topView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexCode: "#DBDBDB")
        return view
    }()
    private let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    private let itemWidth = (UIScreen.main.bounds.size.width/3) - 4

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: View Setup
private extension NavGalleryView {
    func setup() {
        addViews()
        autoLayoutSetup()
    }
    
    func addViews() {
        addSubview(topView)
        addSubview(horizontalStackView)
        addSubview(bottomView)
        horizontalStackView.addArrangedSubview(gridImageButton)
    }
    
    func autoLayoutSetup() {
        topView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(0.5)
        }
        horizontalStackView.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
            make.trailing.lessThanOrEqualToSuperview()
        }
        gridImageButton.snp.makeConstraints { make in
            make.width.equalTo(itemWidth)
        }
        bottomView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(0.5)
            make.width.equalTo(itemWidth)
        }
    }
}

//MARK: 위치 조정
extension NavGalleryView {
    
}
