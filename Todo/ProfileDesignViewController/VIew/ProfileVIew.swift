//
//  ProfileStackVIew.swift
//  Todo
//
//  Created by 김도현 on 2023/09/20.
//

import UIKit
import SnapKit

final class ProfileView: UIStackView {
    
    private let infoView: UIView = UIView()
    private let imageView: UIImageView = UIImageView(image: UIImage(named: "UserPic"))
    private let userFollowInfoStackView: UserFollowInfoStackView = UserFollowInfoStackView()
    private let descriptionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        return stackView
    }()
    private let descriptionTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "르탄이"
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .black
        return label
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "iOS Developer 🍎"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .black
        return label
    }()
    private let descriptionLinkLabel: UILabel = {
        let label = UILabel()
        label.text = "spartacodingclub.kr"
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .systemBlue
        return label
    }()
    private let middleBarStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        return stackView
    }()
    private let followButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(hexCode: "#3898F3")
        button.layer.cornerRadius = 4
        button.setTitle("Follow", for: .normal)
        button.layer.borderWidth = 1.5
        button.layer.borderColor = UIColor(hexCode: "#DADADA").cgColor
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.white, for: .selected)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        button.isSelected =  true
        return button
    }()
    private let MessageButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.layer.cornerRadius = 4
        button.layer.borderWidth = 1.5
        button.layer.borderColor = UIColor(hexCode: "#DADADA").cgColor
        button.setTitle("Message", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.white, for: .selected)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        button.isSelected = false
        return button
    }()
    private let moreButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.layer.cornerRadius = 4
        button.layer.borderWidth = 1.5
        button.layer.borderColor = UIColor(hexCode: "#DADADA").cgColor
        button.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        button.tintColor = .black
        return button
    }()
    private let margin: CGFloat = 14
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ProfileView {
    
    func setup() {
        addViews()
        stackViewSetup()
        autoLayoutSetup()
    }
    
    func stackViewSetup() {
        axis = .vertical
        alignment = .leading
        distribution = .equalSpacing
        spacing = 10
    }
    
    func addViews() {
        addArrangedSubview(infoView)
        addArrangedSubview(descriptionStackView)
        addArrangedSubview(middleBarStackView)
        addSubview(moreButton)
        
        infoView.addSubview(imageView)
        infoView.addSubview(userFollowInfoStackView)
        
        descriptionStackView.addArrangedSubview(descriptionTitleLabel)
        descriptionStackView.addArrangedSubview(descriptionLabel)
        descriptionStackView.addArrangedSubview(descriptionLinkLabel)
        
        middleBarStackView.addArrangedSubview(followButton)
        middleBarStackView.addArrangedSubview(MessageButton)
    }
    
    func autoLayoutSetup() {
        let spacing = 12
        let imageSize = 88
        let moreButtonSize = 30
        infoView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }
        imageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.width.height.equalTo(imageSize)
        }
        userFollowInfoStackView.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.trailing).inset(-40)
            make.trailing.equalToSuperview().inset(margin)
            make.centerY.equalTo(imageView.snp.centerY)
        }
        descriptionStackView.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).inset(-spacing)
            make.leading.trailing.equalToSuperview()
        }
        middleBarStackView.snp.makeConstraints { make in
            make.top.equalTo(descriptionStackView.snp.bottom).inset(-spacing)
            make.leading.equalToSuperview()
            make.trailing.equalTo(moreButton.snp.leading).inset(-8)
            make.height.equalTo(moreButtonSize)
        }
        moreButton.snp.makeConstraints { make in
            make.top.equalTo(middleBarStackView.snp.top)
            make.width.height.equalTo(moreButtonSize)
            make.trailing.equalToSuperview()
        }
    }
}

