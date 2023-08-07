//
//  TodoTableViewCell.swift
//  Todo
//
//  Created by 김도현 on 2023/07/31.
//

import UIKit

class TodoTableViewCell: UITableViewCell, CAAnimationDelegate, Animation {
    
    static let identifier: String = "\(TodoTableViewCell.self)"
    var todo: Todo?
    var delegate: UpdateTodoDelegate?
    let todoLabel: UILabel = {
        let lb = UILabel()
        lb.font = .systemFont(ofSize: 18, weight: .regular)
        lb.text = "투두"
        return lb
    }()
    let checkBoxButton: CheckBoxButton = {
        let btn = CheckBoxButton()
        btn.setImage(UIImage(systemName: "checkmark"), for: .normal)
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor(red: 106/255, green: 209/255, blue: 213/255, alpha: 1.0).cgColor
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 5
        return btn
    }()
    var animationLayer: CAShapeLayer = CAShapeLayer()
    var previewAnimationLayer: CAShapeLayer = CAShapeLayer()
    var isCompleted: Bool = false
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(todoLabel)
        contentView.addSubview(checkBoxButton)
        contentView.layer.masksToBounds = true
        checkBoxButton.addTarget(self, action: #selector(checkButtonClick), for: .touchUpInside)
        autoLayoutSetting()
        layoutIfNeeded()
        checkBoxButton.animationCompleted = {
            self.animation(animationRadius: self.checkBoxButton.frame.height, center: self.checkBoxButton.center)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func autoLayoutSetting() {
        todoLabel.translatesAutoresizingMaskIntoConstraints = false
        todoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18).isActive = true
        todoLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        todoLabel.trailingAnchor.constraint(greaterThanOrEqualTo: checkBoxButton.leadingAnchor, constant:-18).isActive = true
        
        checkBoxButton.translatesAutoresizingMaskIntoConstraints = false
        checkBoxButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12).isActive = true
        checkBoxButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18).isActive = true
        checkBoxButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12).isActive = true
        let checkButtonHeight = checkBoxButton.heightAnchor.constraint(equalToConstant: 30)
        checkButtonHeight.priority = UILayoutPriority(999)
        checkButtonHeight.isActive = true
        checkBoxButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    func uiUpdate(todo: Todo) {
        self.todo = todo
        todoLabel.text = todo.title
        isCompleted = todo.isCompleted
        checkBoxButton.isSelected = isSelected
        animationLayer.removeFromSuperlayer()
        checkBoxButton.animationLayer.removeFromSuperlayer()
        if isCompleted {
            checkBoxButton.backgroundColor = .mainColor
            contentView.backgroundColor = .mainColor.withAlphaComponent(0.5)
        }
    }
    
    @objc func checkButtonClick() {
        contentView.backgroundColor = .clear
        checkBoxButton.backgroundColor = .clear
        isCompleted = !isCompleted
        todo?.isCompleted = isCompleted
        delegate?.update(todo: todo)
        checkBoxButton.isCompleted = isCompleted
        let radius = checkBoxButton.frame.size.width
        let position = CGPoint(x: checkBoxButton.frame.size.width/2, y: checkBoxButton.frame.size.width/2)
        isCompleted ? checkBoxButton.animation(animationRadius: radius/10, center: position) : animation(animationRadius: radius/2, center: checkBoxButton.center)
    }
    
    func animation(animationRadius: CGFloat, center: CGPoint) {
        var fromValue = 1.0
        var toValue = 1.0
        var forkey: String?
        if isCompleted {
            fromValue = 1
            toValue = 30
            forkey = "CompleteAnimation"
        } else {
            fromValue = 30
            toValue = 1
            forkey = "notCompleteAnimation"
        }
        previewAnimationLayer = animationLayer
        animationLayer = animateLayer(animationRadius: animationRadius, center: center, color: UIColor.mainColor.withAlphaComponent(0.5), fromValue: fromValue, toValue: toValue, forKey: forkey)
        contentView.layer.insertSublayer(animationLayer, at: 0)
    }

    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if anim == animationLayer.animation(forKey: "CompleteAnimation") && flag {
            return
        } else if anim == animationLayer.animation(forKey: "CompleteAnimation") && !flag {
            animationLayer.removeFromSuperlayer()
            return
        } else if !flag && anim == previewAnimationLayer.animation(forKey: "notCompleteAnimation") {
            previewAnimationLayer.removeFromSuperlayer()
            return
        } else if !flag && anim == animationLayer.animation(forKey: "notCompleteAnimation") {
            return
        }
        animationLayer.removeFromSuperlayer()
        checkBoxButton.animation(animationRadius: checkBoxButton.frame.width/10, center: CGPoint(x: checkBoxButton.frame.width/2, y: checkBoxButton.frame.width/2))
    }
}
