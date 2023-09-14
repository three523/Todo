//
//  CreateTodoViewController.swift
//  Todo
//
//  Created by 김도현 on 2023/08/08.
//

import UIKit
import CoreData

final class CreateTodoViewController: UIViewController, CAAnimationDelegate {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var goalStackView: UIStackView!
    @IBOutlet weak var goalTextField: UITextField!
    @IBOutlet weak var workCategoryButton: UIButton!
    @IBOutlet weak var lifeCategoryButton: UIButton!
    var todo: (Task & Codable)? = nil
    
    private var titleEmptyLabel: UILabel = {
        let lb = UILabel()
        lb.font = .systemFont(ofSize: 16, weight: .regular)
        lb.text = "제목을 입력해주세요"
        lb.textColor = .red
        lb.isHidden = true
        return lb
    }()
    private var goalEmptyLabel: UILabel = {
        let lb = UILabel()
        lb.font = .systemFont(ofSize: 16, weight: .regular)
        lb.text = "목표 개수를 입력해주세요"
        lb.textColor = .red
        lb.isHidden = true
        return lb
    }()
    private var goalStackViewHeight: NSLayoutConstraint?
    var type: TodoType = .check
    var category: Category = .work
    private var todoManager: TodoManager = TodoManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(titleEmptyLabel)
        view.addSubview(goalEmptyLabel)
        
        workCategoryButton.backgroundColor = .mainColor
        
        updateTodoUi()
        
        if type == .check {
            goalStackView.isHidden = true
        }
        
        titleEmptyLabel.translatesAutoresizingMaskIntoConstraints = false
        titleEmptyLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 8).isActive = true
        titleEmptyLabel.leadingAnchor.constraint(equalTo: titleTextField.leadingAnchor).isActive = true
        
        goalEmptyLabel.translatesAutoresizingMaskIntoConstraints = false
        goalEmptyLabel.topAnchor.constraint(equalTo: goalTextField.bottomAnchor, constant: 8).isActive = true
        goalEmptyLabel.leadingAnchor.constraint(equalTo: goalTextField
            .leadingAnchor).isActive = true
    }
    
    private func updateTodoUi() {
        guard let todo = todo else { return }
        if category == .life {
            lifeCategoryButton.backgroundColor = .mainColor
        } else {
            workCategoryButton.backgroundColor = .mainColor
        }
        titleTextField.text = todo.title
        if let countTodo = todo as? CountTodo {
            type = .count
            goalStackView.alpha = 1
            goalTextField.text = String(countTodo.goal)
        }
        let deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(removeTodo))
        deleteButton.tintColor = .systemRed
        navigationItem.rightBarButtonItem?.title = "수정"
        navigationItem.rightBarButtonItems?.append(deleteButton)
    }

    @IBAction func createTodo(_ sender: Any) {
        guard let titleText = titleTextField.text,
              !titleText.isEmpty  else {
            textfieldAnimation(textField: titleTextField, emptyLabel: titleEmptyLabel)
            return
        }
        
        switch type {
        case .check:
            if var checkTodo = todo {
                checkTodo.title = titleText
                todoManager.todoUpdate(todo: checkTodo, category: category, state: .update)
            } else {
                let newTodo = CheckTodo(title: titleText, isCompleted: false)
                todoManager.todoUpdate(todo: newTodo, category: category, state: .create)
            }
        case .count:
            guard let countText = goalTextField.text,
                  !countText.isEmpty,
                  let goal = Int(countText) else {
                textfieldAnimation(textField: goalTextField, emptyLabel: goalEmptyLabel)
                return
            }
            if var countTodo = todo as? CountTodo {
                countTodo.title = titleText
                countTodo.goal = goal
                todoManager.todoUpdate(todo: countTodo, category: category, state: .update)
            } else {
                let countTodo = CountTodo(title: titleText, goal: goal)
                todoManager.todoUpdate(todo: countTodo, category: category, state: .create)
            }
        }
        navigationController?.popViewController(animated: true)
    }
    @IBAction func workButtonClick(_ sender: Any) {
        category = .work
        workCategoryButton.backgroundColor = .mainColor
        lifeCategoryButton.backgroundColor = .systemGray5
    }
    @IBAction func lifeButtonClick(_ sender: Any) {
        category = .life
        workCategoryButton.backgroundColor = .systemGray5
        lifeCategoryButton.backgroundColor = .mainColor
    }
    
    @objc private func removeTodo() {
        guard let todo else { return }
        todoManager.todoUpdate(todo: todo, category: category, state: .remove)
        navigationController?.popViewController(animated: true)
    }
    
    func textfieldAnimation(textField: UITextField, emptyLabel: UILabel) {
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            textField.layer.borderWidth = 0
            textField.layer.borderColor = nil
            emptyLabel.isHidden = true
        }
        textField.layer.borderWidth = 0.5
        textField.layer.cornerRadius = 5
        textField.layer.borderColor = UIColor.red.cgColor
        
        let animation = CABasicAnimation(keyPath: "position.x")
        animation.fromValue = textField.center.x - 3
        animation.toValue = textField.center.x + 3
        animation.repeatCount = 6
        animation.autoreverses = true
        animation.delegate = self
        animation.duration = 0.05
        emptyLabel.isHidden = false
        textField.layer.add(animation, forKey: "shake")
        CATransaction.commit()
    }
}
