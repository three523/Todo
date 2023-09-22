//
//  ViewController.swift
//  Todo
//
//  Created by 김도현 on 2023/07/31.
//

import UIKit
import SnapKit

final class ViewController: UIViewController {

    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            mainImageView,
            todoListButton,
            doneListButton,
            catImageButton
        ])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 48
        return stackView
    }()
    private var mainImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.backgroundColor = .systemGray5
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    private var todoListButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("할일 확인하기", for: .normal)
        return button
    }()
    private var doneListButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("완료한일 보기", for: .normal)
        return button
    }()
    private let catImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("고양이 사진 보러가기", for: .normal)
        return button
    }()
    private let profileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("프로필 화면 보러가기", for: .normal)
        return button
    }()
    private let imageLoader: ImageLoader = ImageLoader()
    private let viewModel: MainViewModel = MainViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

private extension ViewController {
    
    func setup() {
        addViews()
        autoLayoutSetup()
        mainImageViewSetup()
        buttonClickSetup()
    }
    func addViews() {
        view.addSubview(mainStackView)
        mainStackView.addArrangedSubview(mainImageView)
        mainStackView.addArrangedSubview(todoListButton)
        mainStackView.addArrangedSubview(doneListButton)
        mainStackView.addArrangedSubview(catImageButton)
        mainStackView.addArrangedSubview(profileButton)
    }
    func autoLayoutSetup() {
        let safeArea = view.safeAreaLayoutGuide
        
        mainStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(80)
            make.centerX.equalToSuperview()
            make.bottom.lessThanOrEqualTo(safeArea.snp.bottom).inset(80)
        }
        
        mainImageView.snp.makeConstraints { make in
            make.width.equalTo(220)
            make.height.equalTo(140)
        }
    }
    func mainImageViewSetup() {
        let imageUrl = "https://spartacodingclub.kr/css/images/scc-og.jpg"
        imageLoader.loadUrlImage(url: imageUrl) { data in
            guard let data else { return }
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                self.mainImageView.image = image
            }
        }
    }
    func buttonClickSetup() {
        todoListButton.addTarget(self, action: #selector(todoListButtonClick), for: .touchUpInside)
        doneListButton.addTarget(self, action: #selector(doneListButtonClick), for: .touchUpInside)
        catImageButton.addTarget(self, action: #selector(catImageButtonClick), for: .touchUpInside)
        profileButton.addTarget(self, action: #selector(profileButtonClick), for: .touchUpInside)
    }
    @objc func todoListButtonClick() {
        let vc = TodoListViewController(viewModel: TodoListViewModel(todoManager: viewModel.todoManager))
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc func doneListButtonClick() {
        let vc = DoneListViewController(viewModel: DoneTodoListViewModel(todoManager: viewModel.todoManager))
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc func catImageButtonClick() {
        let vc = CatImageViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc func profileButtonClick() {
        let vc = ProfileDesignViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}

