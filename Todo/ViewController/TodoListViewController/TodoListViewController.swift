//
//  TodoListViewController.swift
//  Todo
//
//  Created by 김도현 on 2023/07/31.
//

import UIKit
import CoreData
import SnapKit

protocol UpdateTodoDelegate: AnyObject {
    func update<T: TaskEntity & NSManagedObject>(todo: T?, category: Category)
    func remove<T: TaskEntity & NSManagedObject>(todo: T?, category: Category)
}

final class TodoListViewController: UIViewController, CAAnimationDelegate {
    private var todoListTableView: UITableView = UITableView()
    private var isSelectedAddButton: Bool = false
    private var listButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "plus"), for: .normal)
        btn.backgroundColor = .mainColor
        btn.adjustsImageWhenHighlighted = false
        btn.tintColor = .white
        btn.layer.masksToBounds = true
        return btn
    }()
    private var countAddButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "minus.forwardslash.plus"), for: .normal)
        btn.backgroundColor = .mainColor
        btn.tintColor = .white
        btn.adjustsImageWhenHighlighted = false
        btn.layer.opacity = 0
        btn.layer.masksToBounds = true
        btn.layer.borderColor = UIColor.mainColor.cgColor
        return btn
    }()
    private var checkAddButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "checkmark"), for: .normal)
        btn.backgroundColor = .mainColor
        btn.tintColor = .white
        btn.adjustsImageWhenHighlighted = false
        btn.layer.opacity = 0
        btn.layer.masksToBounds = true
        btn.layer.borderColor = UIColor.mainColor.cgColor
        return btn
    }()
    private let margin: CGFloat = 24
    private let buttonSize: CGFloat = 50
    private let viewModel: TodoListViewModel
    
    init(viewModel: TodoListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        todoListTableView.reloadData()
    }
}

//MARK: UI Setup
extension TodoListViewController {
    private func setup() {
        addViews()
        configAutoLayout()
        configTableView()
        configButton()
    }
    
    private func addViews() {
        view.addSubview(todoListTableView)
        view.addSubview(listButton)
        view.addSubview(checkAddButton)
        view.addSubview(countAddButton)
    }
    
    private func configTableView() {
        todoListTableView.delegate = self
        todoListTableView.dataSource = self
        todoListTableView.register(CheckTodoTableViewCell.self, forCellReuseIdentifier: CheckTodoTableViewCell.resuableIdentifier)
        todoListTableView.register(CountTodoTableViewCell.self, forCellReuseIdentifier: CountTodoTableViewCell.resuableIdentifier)
    }
    
    private func configAutoLayout() {
        let safeArea = view.safeAreaLayoutGuide
        todoListTableView.snp.makeConstraints { make in
            make.edges.equalTo(safeArea)
        }
        listButton.snp.makeConstraints { make in
            make.bottom.trailing.equalTo(safeArea).inset(margin)
            make.width.height.equalTo(buttonSize)
        }
        checkAddButton.snp.makeConstraints { make in
            make.trailing.equalTo(safeArea).inset(margin)
            make.bottom.equalTo(listButton.snp.top).offset(-margin)
            make.width.height.equalTo(buttonSize)
        }
        countAddButton.snp.makeConstraints { make in
            make.trailing.equalTo(safeArea).inset(margin)
            make.bottom.equalTo(checkAddButton.snp.top).offset(-margin)
            make.width.height.equalTo(buttonSize)
        }
    }
    
    private func configButton() {
        listButton.addTarget(self, action: #selector(addList), for: .touchUpInside)
        checkAddButton.addTarget(self, action: #selector(createCheckTodo), for: .touchUpInside)
        countAddButton.addTarget(self, action: #selector(createCountTodo), for: .touchUpInside)
        
        listButton.layoutIfNeeded()
        checkAddButton.layoutIfNeeded()
        countAddButton.layoutIfNeeded()
        listButton.layer.cornerRadius =  listButton.frame.width/2
        checkAddButton.layer.cornerRadius =  checkAddButton.frame.width/2
        countAddButton.layer.cornerRadius =  countAddButton.frame.width/2
    }
    
    @objc func addList() {
        isSelectedAddButton.toggle()
        isSelectedAddButton ? buttonListAnimation() : addListVisibleAnimation(button: countAddButton, forkey: "CountAddButton", positionY: checkAddButton.frame.minY)
    }
    
    @objc func createCheckTodo() {
        let vc = CreateTodoViewController(viewModel: CreateTodoViewModel(type: .check, todoManager: viewModel.todoManager))
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func createCountTodo() {
        let vc = CreateTodoViewController(viewModel: CreateTodoViewModel(type: .count, todoManager: viewModel.todoManager))
        navigationController?.pushViewController(vc, animated: true)
    }
}

//TODO: Animation은 다른 클래스로 빼는 방법 생각해보기
//MARK: Animation
extension TodoListViewController {
    private func buttonListAnimation() {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.fromValue = isSelectedAddButton ? 0 : Double.pi * 0.25
        rotationAnimation.toValue = isSelectedAddButton ? Double.pi * 0.25 : 0
        rotationAnimation.duration = 0.25
        rotationAnimation.fillMode = .forwards
        rotationAnimation.isRemovedOnCompletion = false
        rotationAnimation.delegate = self
        
        listButton.layer.add(rotationAnimation, forKey: "rotation")
    }
    
    private func addListVisibleAnimation(button: UIButton, forkey: String, positionY: CGFloat) {
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            button.layer.opacity = self.isSelectedAddButton ? 1 : 0
        }
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = isSelectedAddButton ? 0 : 1
        opacityAnimation.toValue = isSelectedAddButton ? 1 : 0

        let positionAnimation = CABasicAnimation(keyPath: "position.y")
        let position = positionY - button.frame.height/2
        positionAnimation.fromValue = isSelectedAddButton ? position  : position - 24
        positionAnimation.byValue = isSelectedAddButton ? -24 : 24

        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.fromValue = isSelectedAddButton ? Double.pi * 0.5 : 0
        rotationAnimation.toValue = isSelectedAddButton ? 0 : Double.pi * 0.5

        let group = CAAnimationGroup()
        group.fillMode = .forwards
        group.isRemovedOnCompletion = false
        group.delegate = self
        group.animations = [opacityAnimation, positionAnimation, rotationAnimation]

        button.layer.add(group, forKey: forkey)
        CATransaction.commit()
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if isSelectedAddButton {
            if anim == listButton.layer.animation(forKey: "rotation") {
                listButton.tintColor = .red
                addListVisibleAnimation(button: checkAddButton, forkey: "CheckAddButton", positionY: listButton.frame.minY)
            } else if anim == checkAddButton.layer.animation(forKey: "CheckAddButton") {
                addListVisibleAnimation(button: countAddButton, forkey: "CountAddButton", positionY: checkAddButton.frame.minY)
            } else if anim == countAddButton.layer.animation(forKey: "CountAddButton") {
            }
        } else {
            if anim == countAddButton.layer.animation(forKey: "CountAddButton") {
                addListVisibleAnimation(button: checkAddButton, forkey: "CheckAddButton", positionY: listButton.frame.minY)
            } else if anim == checkAddButton.layer.animation(forKey: "CheckAddButton") {
                buttonListAnimation()
                listButton.tintColor = .white
            } else if anim == listButton.layer.animation(forKey: "rotation") {
                
            }
        }
        if !flag {
            if isSelectedAddButton {
                listButton.tintColor = .red
                checkAddButton.layer.opacity = 1
                countAddButton.layer.opacity = 1
            } else {
                listButton.tintColor = .mainColor
                checkAddButton.layer.opacity = 0
                countAddButton.layer.opacity = 0
            }
        }
    }
}

extension TodoListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.todoManager.categoryCount()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let category = viewModel.todoManager.category(at: section) else { return 0 }
        return viewModel.todoManager.todoCount(category: category)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.todoManager.categoryTitle(index: section)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 16
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let category = viewModel.todoManager.category(at: indexPath.section) else { return UITableViewCell() }
        let todo = viewModel.todoManager.todo(category: category, at: indexPath.row)
        guard let cell = todo.todoCell(tableView: tableView, indexPath: indexPath, viewContoller: self) else { return UITableViewCell() }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let category = viewModel.todoManager.category(at: indexPath.section) else { return }
        let todo = viewModel.todoManager.todo(category: category, at: indexPath.row)
        var type: TodoType = .check
        if todo as? CountTodoEntity != nil {
            type = .count
        }
        let viewModel = CreateTodoViewModel(todo: todo, type: type, todoManager: viewModel.todoManager)
        let vc = CreateTodoViewController(viewModel: viewModel)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension TodoListViewController: UpdateTodoDelegate {
    func update<T: TaskEntity & NSManagedObject>(todo: T?, category: Category) {
        guard let todo else { return }
        viewModel.todoManager.updateTodo(category: category, todo: todo)
    }
    
    func remove<T: TaskEntity & NSManagedObject>(todo: T?, category: Category) {
        guard let todo else { return }
        viewModel.todoManager.updateTodo(category: category, todo: todo)
    }
}

