//
//  TodoTableViewCell.swift
//  Todo
//
//  Created by 김도현 on 2023/07/31.
//

import UIKit

class TodoTableViewCell: UITableViewCell {
    
    static let identifier: String = "\(TodoTableViewCell.self)"
    var todo: Todo?
    var delegate: UpdateTodoDelegate?
    let todoLabel: UILabel = {
        let lb = UILabel()
        lb.font = .systemFont(ofSize: 18, weight: .regular)
        lb.text = "투두"
        return lb
    }()
    let todoSwitch: UISwitch = {
        let sw = UISwitch()
        return sw
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(todoLabel)
        contentView.addSubview(todoSwitch)
        todoSwitch.addTarget(self, action: #selector(switchToggle), for: .valueChanged)
        autoLayoutSetting()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func autoLayoutSetting() {
        todoLabel.translatesAutoresizingMaskIntoConstraints = false
        todoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18).isActive = true
        todoLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        todoLabel.trailingAnchor.constraint(greaterThanOrEqualTo: todoSwitch.leadingAnchor, constant:-18).isActive = true
        
        todoSwitch.translatesAutoresizingMaskIntoConstraints = false
        todoSwitch.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12).isActive = true
        todoSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18).isActive = true
        todoSwitch.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12).isActive = true
    }
    
    func uiUpdate(todo: Todo) {
        self.todo = todo
        todoLabel.text = todo.title
        todoSwitch.isOn = todo.isCompleted
        strikeThroughLable()
    }
    
    @objc func switchToggle(toggle: UISwitch) {
        todo?.isCompleted = toggle.isOn
        strikeThroughLable()
        delegate?.switchUpdate(todo: todo)
    }
    
    func strikeThroughLable() {
        todoLabel.attributedText = todoSwitch.isOn ? todoLabel.text?.strikeThrough() : todoLabel.text?.normal()
    }

}
