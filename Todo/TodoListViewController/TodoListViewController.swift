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
    func update<T: TestEntity & NSManagedObject>(todo: T?, category: Category)
    func remove<T: TestEntity & NSManagedObject>(todo: T?, category: Category)
}

final class TodoListViewController: UIViewController, CAAnimationDelegate {
    private var todoListTableView: UITableView = UITableView()
    private var isSelected: Bool = false
    private var todoManager: TodoManager = TodoManager.shared
    private var entityManager: TodoEntityManager = TodoEntityManager.shared
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
        isSelected = !isSelected
        isSelected ? buttonListAnimation() : addListVisibleAnimation(button: countAddButton, forkey: "CountAddButton", positionY: checkAddButton.frame.minY)
    }
    
    @objc func createCheckTodo() {
        let vc = CreateTodoViewController()
        vc.type = .check
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func createCountTodo() {
        let vc = CreateTodoViewController()
        vc.type = .count
        navigationController?.pushViewController(vc, animated: true)
    }
}
//MARK: Animation
extension TodoListViewController {
    private func buttonListAnimation() {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.fromValue = isSelected ? 0 : Double.pi * 0.25
        rotationAnimation.toValue = isSelected ? Double.pi * 0.25 : 0
        rotationAnimation.duration = 0.25
        rotationAnimation.fillMode = .forwards
        rotationAnimation.isRemovedOnCompletion = false
        rotationAnimation.delegate = self
        
        listButton.layer.add(rotationAnimation, forKey: "rotation")
    }
    
    private func addListVisibleAnimation(button: UIButton, forkey: String, positionY: CGFloat) {
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            button.layer.opacity = self.isSelected ? 1 : 0
        }
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = isSelected ? 0 : 1
        opacityAnimation.toValue = isSelected ? 1 : 0

        let positionAnimation = CABasicAnimation(keyPath: "position.y")
        let position = positionY - button.frame.height/2
        positionAnimation.fromValue = isSelected ? position  : position - 24
        positionAnimation.byValue = isSelected ? -24 : 24

        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.fromValue = isSelected ? Double.pi * 0.5 : 0
        rotationAnimation.toValue = isSelected ? 0 : Double.pi * 0.5

        let group = CAAnimationGroup()
        group.fillMode = .forwards
        group.isRemovedOnCompletion = false
        group.delegate = self
        group.animations = [opacityAnimation, positionAnimation, rotationAnimation]

        button.layer.add(group, forKey: forkey)
        CATransaction.commit()
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if isSelected {
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
            if isSelected {
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
//        return Category.allCases.count
        return todoManager.categoryCount()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        let category = Category.allCases[section]
//        return todoManager.testCategoryCount()
        guard let category = todoManager.category(at: section) else { return 0 }
        return todoManager.todoCount(category: category)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return todoManager.categoryTitle(index: section)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 16
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let category = todoManager.category(at: indexPath.section) else { return UITableViewCell() }
        let todo = todoManager.todo(category: category, at: indexPath.row)
        guard let cell = todo.todoCell(tableView: tableView, indexPath: indexPath, viewContoller: self) else { return UITableViewCell() }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = Category.allCases[indexPath.section]
        let todo = todoManager.todo(category: category, at: indexPath.row)
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "CreateTodo") as? CreateTodoViewController else { return }
        vc.testTodo = todo
        vc.testTodo = todoManager.todo(category: category, at: indexPath.row)
        vc.category = category
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension TodoListViewController: UpdateTodoDelegate {
    func update<T: TestEntity & NSManagedObject>(todo: T?, category: Category) {
        guard let todo else { return }
        todoManager.updateTodo(category: category, todo: todo)
    }
    
    func remove<T: TestEntity & NSManagedObject>(todo: T?, category: Category) {
        guard let todo else { return }
        todoManager.updateTodo(category: category, todo: todo)
    }
}

