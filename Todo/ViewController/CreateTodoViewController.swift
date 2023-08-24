//
//  CreateTodoViewController.swift
//  Todo
//
//  Created by 김도현 on 2023/08/08.
//

import UIKit

enum TodoType {
    case check
    case count
}

class CreateTodoViewController: UIViewController, CAAnimationDelegate {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var alramSwitch: UISwitch!
    @IBOutlet weak var goalStackView: UIStackView!
    @IBOutlet weak var goalTextField: UITextField!
    var todo: Task? = nil
    
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
    var type: TodoType = .check
    var todoManager: TodoManager = TodoManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(titleEmptyLabel)
        view.addSubview(goalEmptyLabel)
        
        if type == .check { goalStackView.alpha = 0 }
        
        updateTodoUi()
        
        titleEmptyLabel.translatesAutoresizingMaskIntoConstraints = false
        titleEmptyLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 8).isActive = true
        titleEmptyLabel.leadingAnchor.constraint(equalTo: titleTextField.leadingAnchor).isActive = true
        
        goalEmptyLabel.translatesAutoresizingMaskIntoConstraints = false
        goalEmptyLabel.topAnchor.constraint(equalTo: goalTextField.bottomAnchor, constant: 8).isActive = true
        goalEmptyLabel.leadingAnchor.constraint(equalTo: goalTextField
            .leadingAnchor).isActive = true
    }
    
    func updateTodoUi() {
        guard let todo = todo else { return }
        titleTextField.text = todo.title
        if let countTodo = todo as? CountTodo {
            type = .count
            goalStackView.alpha = 1
            goalTextField.text = String(countTodo.goal)
        }
        navigationItem.rightBarButtonItem?.title = "수정"
    }

    @IBAction func createTodo(_ sender: Any) {
        guard let titleText = titleTextField.text,
              !titleText.isEmpty  else {
            textfieldAnimation(textField: titleTextField, emptyLabel: titleEmptyLabel)
            return
        }
        
        switch type {
        case .check:
            if let todo {
                self.todo?.title = titleText
                todoManager.update(todo: self.todo!)
            } else {
                let todo = CheckTodo(title: titleText, isCompleted: false)
                todoManager.add(todo: todo)
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
                todoManager.update(todo: countTodo)
            } else {
                let todo = CountTodo(title: titleText, goal: goal)
                todoManager.add(todo: todo)
            }
        }
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
    
    @IBAction func datePickerDisable(_ sender: Any) {
        if alramSwitch.isOn {
            datePicker.alpha = 1
        } else {
            datePicker.alpha = 0
        }
    }
}
