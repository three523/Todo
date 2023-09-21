//
//  CreateTodoViewController.swift
//  Todo
//
//  Created by 김도현 on 2023/08/08.
//

import UIKit
import CoreData

final class CreateTodoViewController: UIViewController {
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .equalCentering
        stackView.spacing = 36
        return stackView
    }()
    private let titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 12
        return stackView
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "제목"
        label.font = .systemFont(ofSize: 24)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "투두리스트 제목을 입력해주세요"
        textField.font = .systemFont(ofSize: 20)
        textField.textColor = .black
        textField.borderStyle = .roundedRect
        return textField
    }()
    private let goalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = 12
        return stackView
    }()
    private let goalLabel: UILabel = {
        let label = UILabel()
        label.text = "목표 횟수"
        label.font = .systemFont(ofSize: 24)
        label.textColor = .black
        label.numberOfLines = 1
        label.setContentCompressionResistancePriority(UILayoutPriority(749), for: .horizontal)
        return label
    }()
    private let goalTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "목표 갯수를 입력해주세요"
        textField.font = .systemFont(ofSize: 20)
        textField.textColor = .black
        textField.borderStyle = .roundedRect
        return textField
    }()
    private let categoryStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 12
        return stackView
    }()
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "카테고리"
        label.font = .systemFont(ofSize: 24)
        label.textColor = .black
        label.numberOfLines = 1
        return label
    }()
    private let workCategoryButton: UIButton = {
        let button = UIButton()
        button.setTitle("Work", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .mainColor
        return button
    }()
    private let lifeCategoryButton: UIButton = {
        let button = UIButton()
        button.setTitle("Life", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .systemGray5
        return button
    }()
    var todo: (Task & Codable)? = nil
    var testTodo: (NSManagedObject & TestEntity)? = nil
    
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
    private let margin: CGFloat = 24
    private let topMargin: CGFloat = 12
    var type: TodoType = .check
    var category: Category = .work
    private var todoManager: TodoManager = TodoManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

//MARK: View Setup
extension CreateTodoViewController {
    private func setup() {
        navigationSetup()
        addViews()
        autoLayoutSetup()
        hiddenViewSetup()
        buttonSetup()
        updateTodoUi()
    }
    
    private func navigationSetup() {
        let doneButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(createTodo))
        let deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(removeTodo))
        deleteButton.tintColor = .systemRed
        navigationItem.rightBarButtonItems?.append(doneButton)
        navigationItem.rightBarButtonItem?.title = "수정"
        navigationItem.rightBarButtonItems?.append(deleteButton)
    }
    
    private func mainViewSetup() {
        view.backgroundColor = .white
    }
    
    private func addViews() {
        view.addSubview(mainStackView)
        mainStackView.addArrangedSubview(titleStackView)
        mainStackView.addArrangedSubview(goalStackView)
        mainStackView.addArrangedSubview(categoryStackView)
        titleStackView.addArrangedSubview(titleLabel)
        titleStackView.addArrangedSubview(titleTextField)
        goalStackView.addArrangedSubview(goalLabel)
        goalStackView.addArrangedSubview(goalTextField)
        categoryStackView.addArrangedSubview(categoryLabel)
        categoryStackView.addArrangedSubview(workCategoryButton)
        categoryStackView.addArrangedSubview(lifeCategoryButton)
        view.addSubview(titleEmptyLabel)
        view.addSubview(goalEmptyLabel)
    }
    
    private func viewSetup() {
        view.backgroundColor = .white
    }
    
    private func autoLayoutSetup() {
        let safeArea = view.safeAreaLayoutGuide
        mainStackView.snp.makeConstraints { make in
            make.top.equalTo(safeArea).inset(topMargin)
            make.leading.trailing.equalTo(safeArea).inset(margin)
        }
        
        titleStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }
        
        goalStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }
        
        categoryStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }
        
        titleEmptyLabel.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).inset(8)
            make.leading.equalTo(titleTextField.snp.leading)
        }
        
        goalEmptyLabel.snp.makeConstraints { make in
            make.top.equalTo(goalTextField.snp.bottom).inset(8)
            make.leading.equalTo(goalTextField.snp.leading)
        }
    }
    
    private func hiddenViewSetup() {
        if type == .check {
            goalStackView.isHidden = true
        }
    }
    
    private func updateTodoUi() {
        guard let testTodo else { return }
        if category == .life {
            lifeCategoryButton.backgroundColor = .mainColor
        } else {
            workCategoryButton.backgroundColor = .mainColor
        }
        titleTextField.text = testTodo.title
        if let countTodo = testTodo as? CountTodoEntity {
            type = .count
            goalStackView.alpha = 1
            goalTextField.text = String(countTodo.goal)
        }
    }
    
    private func buttonSetup() {
        workCategoryButton.addTarget(self, action: #selector(workButtonClick), for: .touchUpInside)
        lifeCategoryButton.addTarget(self, action: #selector(lifeButtonClick), for: .touchUpInside)
    }
    @objc
    private func workButtonClick(_ sender: Any) {
        category = .work
        workCategoryButton.backgroundColor = .mainColor
        lifeCategoryButton.backgroundColor = .systemGray5
    }
    @objc
    private func lifeButtonClick(_ sender: Any) {
        category = .life
        workCategoryButton.backgroundColor = .systemGray5
        lifeCategoryButton.backgroundColor = .mainColor
    }
    
    @objc
    private func removeTodo() {
        guard let testTodo else { return }
        todoManager.removeTodo(category: category, todo: testTodo)
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func createTodo(_ sender: Any) {
        guard let titleText = titleTextField.text,
              !titleText.isEmpty  else {
            textfieldAnimation(textField: titleTextField, emptyLabel: titleEmptyLabel)
            return
        }
        
        switch type {
        case .check:
            if var testTodo {
                testTodo.title = titleText
                todoManager.updateTodo(category: category, todo: testTodo)
            } else {
                let context = TodoEntityManager.shared.context
                if let entity = NSEntityDescription.entity(forEntityName: "CheckTodoEntity", in: context) {
                    let newTestTodo = CheckTodoEntity(entity: entity, insertInto: context)
                    newTestTodo.createDate = Date()
                    newTestTodo.isCompleted = false
                    newTestTodo.title = titleText
                    todoManager.addTodo(category: category, todo: newTestTodo)
                }
            }
        case .count:
            guard let countText = goalTextField.text,
                  !countText.isEmpty,
                  let goal = Int(countText) else {
                textfieldAnimation(textField: goalTextField, emptyLabel: goalEmptyLabel)
                return
            }
            if let testTodo = testTodo as? CountTodoEntity {
                testTodo.title = titleText
                testTodo.goal = Int16(goal)
                todoManager.updateTodo(category: category, todo: testTodo)
            } else {
                let context = TodoEntityManager.shared.context
                if let entity = NSEntityDescription.entity(forEntityName: "CountTodoEntity", in: context) {
                    let newTestTodo = CountTodoEntity(entity: entity, insertInto: context)
                    newTestTodo.createDate = Date()
                    newTestTodo.isCompleted = false
                    newTestTodo.title = titleText
                    newTestTodo.goal = Int16(goal)
                    todoManager.addTodo(category: category, todo: newTestTodo)
                }
            }
        }
        navigationController?.popViewController(animated: true)
    }
}


//MARK: Animation
extension CreateTodoViewController: CAAnimationDelegate {
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
