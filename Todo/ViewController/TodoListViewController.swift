//
//  TodoListViewController.swift
//  Todo
//
//  Created by 김도현 on 2023/07/31.
//

import UIKit

protocol UpdateTodoDelegate: AnyObject {
    func update<T: Task & Codable>(todoType: T, todo: T?)
    func remove<T: Task & Codable>(todoType: T, todo: T?)
}

class TodoListViewController: UIViewController, CAAnimationDelegate {
    @IBOutlet weak var todoListTableView: UITableView!
    private var isSelected: Bool = false
    private var todoManager: TodoManager = TodoManager.shared
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        todoListTableView.delegate = self
        todoListTableView.dataSource = self
        todoListTableView.register(TodoTableViewCell.self, forCellReuseIdentifier: TodoTableViewCell.resuableIdentifier)
        todoListTableView.register(CountTodoTableViewCell.self, forCellReuseIdentifier: CountTodoTableViewCell.resuableIdentifier)
        
        view.addSubview(listButton)
        view.addSubview(checkAddButton)
        view.addSubview(countAddButton)
        listButton.addTarget(self, action: #selector(addList), for: .touchUpInside)
        checkAddButton.addTarget(self, action: #selector(createCheckTodo), for: .touchUpInside)
        countAddButton.addTarget(self, action: #selector(createCountTodo), for: .touchUpInside)

        
        listButton.translatesAutoresizingMaskIntoConstraints = false
        listButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24).isActive = true
        listButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24).isActive = true
        listButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        listButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        checkAddButton.translatesAutoresizingMaskIntoConstraints = false
        checkAddButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24).isActive = true
        checkAddButton.bottomAnchor.constraint(equalTo: listButton.topAnchor, constant: -24).isActive = true
        checkAddButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        checkAddButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        countAddButton.translatesAutoresizingMaskIntoConstraints = false
        countAddButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24).isActive = true
        countAddButton.bottomAnchor.constraint(equalTo: checkAddButton.topAnchor, constant: -24).isActive = true
        countAddButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        countAddButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        listButton.layoutIfNeeded()
        checkAddButton.layoutIfNeeded()
        countAddButton.layoutIfNeeded()
        listButton.layer.cornerRadius =  listButton.frame.width/2
        checkAddButton.layer.cornerRadius =  checkAddButton.frame.width/2
        countAddButton.layer.cornerRadius =  countAddButton.frame.width/2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        todoListTableView.reloadData()
    }
    
    var value: CGFloat = 0.0
    
    @objc func addList() {
        isSelected = !isSelected
        isSelected ? buttonListAnimation() : addListVisibleAnimation(button: countAddButton, forkey: "CountAddButton", positionY: checkAddButton.frame.minY)
    }
    
    @objc func createCheckTodo() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "CreateTodo") as? CreateTodoViewController else { return }
        vc.type = .check
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func createCountTodo() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "CreateTodo") as? CreateTodoViewController else { return }
        vc.type = .count
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func buttonListAnimation() {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.fromValue = isSelected ? 0 : Double.pi * 0.25
        rotationAnimation.toValue = isSelected ? Double.pi * 0.25 : 0
        rotationAnimation.duration = 0.25
        rotationAnimation.fillMode = .forwards
        rotationAnimation.isRemovedOnCompletion = false
        rotationAnimation.delegate = self
        
        listButton.layer.add(rotationAnimation, forKey: "rotation")
    }
    
    func addListVisibleAnimation(button: UIButton, forkey: String, positionY: CGFloat) {
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

extension TodoListViewController: UITableViewDelegate, UITableViewDataSource, UpdateTodoDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Category.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let category = Category.allCases[section]
        return todoManager.todoCount(category: category)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let category = Category.allCases[section]
        return category.title
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 16
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let category = Category.allCases[indexPath.section]
        guard let todo = todoManager.todo(category: category, at: indexPath.row) else { return UITableViewCell() }
        
        guard let cell = todo.todoCell(tableView: tableView, indexPath: indexPath, viewContoller: self) else { return UITableViewCell() }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = Category.allCases[indexPath.section]
        guard let todo = todoManager.todo(category: category, at: indexPath.row) else { return }
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "CreateTodo") as? CreateTodoViewController else { return }
        vc.todo = todo
        vc.category = todo.category
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func update<T: Task & Codable>(todoType: T, todo: T?) {
        guard let todo else { return }
        todoManager.update(todoType: T.self, category: todo.category, todo: todo)
    }
    
    func remove<T: Task & Codable>(todoType: T, todo: T?) {
        guard let todo else { return }
        todoManager.remove(todoType: T.self, category: todo.category, id: todo.id)
    }
}
