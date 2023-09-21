//
//  NumberStackView.swift
//  Todo
//
//  Created by 김도현 on 2023/09/20.
//

import UIKit

final class UserFollowInfoStackView: UIStackView {
    struct Info {
        let title: String
        var count: Int
    }
    private var infoList: [Info] = [Info(title: "post", count: 7), Info(title: "follower", count: 0), Info(title: "following", count: 0)]
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension UserFollowInfoStackView {
    
    func setup() {
        stackViewSetup()
        infoListStackViewSetup()
    }
    
    func stackViewSetup() {
        axis = .horizontal
        alignment = .fill
        distribution = .equalCentering
    }
    
    func infoListStackViewSetup() {
        infoList.forEach { info in
            let infoStackView = createInfoStackView(title: info.title, count: info.count)
            addArrangedSubview(infoStackView)
        }
    }
    
    func createInfoStackView(title: String, count: Int) -> UIStackView {
        let countLabel = UILabel()
        countLabel.text = "\(count)"
        countLabel.font = .systemFont(ofSize: 16.5, weight: .bold)
        countLabel.textColor = .black
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 14)
        titleLabel.textColor = .black
        
        let stackView = UIStackView(arrangedSubviews: [countLabel, titleLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        return stackView
    }
}
