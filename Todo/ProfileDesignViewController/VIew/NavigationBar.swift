//
//  NavigationBar.swift
//  Todo
//
//  Created by 김도현 on 2023/09/20.
//

import UIKit
import SnapKit

final class NavigationBar: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "nabaecamp"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        return label
    }()
    private let menuImageView: UIImageView = UIImageView(image: UIImage(named: "Menu"))
    private let margin: CGFloat = 14

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension NavigationBar {
    func setup() {
        addViews()
        autoLayoutSetup()
    }
    func addViews() {
        addSubview(titleLabel)
        addSubview(menuImageView)
    }
    func autoLayoutSetup() {
        titleLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        menuImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(margin)
        }
    }
}
