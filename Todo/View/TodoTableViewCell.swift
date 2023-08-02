//
//  TodoTableViewCell.swift
//  Todo
//
//  Created by 김도현 on 2023/07/31.
//

import UIKit

class TodoTableViewCell: UITableViewCell, CAAnimationDelegate {
    
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
    var isComplete: Bool = false
    var animationLayer: CAShapeLayer = CAShapeLayer()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(todoLabel)
        contentView.addSubview(checkBoxButton)
        contentView.layer.masksToBounds = true
        checkBoxButton.addTarget(self, action: #selector(checkButtonClick), for: .touchUpInside)
        checkBoxButton.animationCompleted = animate
        autoLayoutSetting()
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
        checkBoxButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        checkBoxButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    func uiUpdate(todo: Todo) {
        animationLayer.removeFromSuperlayer()
        checkBoxButton.animationLayer.removeFromSuperlayer()
        self.todo = todo
        todoLabel.text = todo.title
        isComplete = todo.isCompleted
        checkBoxButton.isCheck = isComplete
        self.layoutIfNeeded()
        checkBoxButton.noAnimate()
        noanimate()
    }
    
    @objc func checkButtonClick() {
        isComplete = !isComplete
        todo?.isCompleted = isComplete
        checkBoxButton.isCheck = isComplete
        if isComplete {
            checkBoxButton.animate()
        } else {
            animate()
        }
        delegate?.switchUpdate(todo: todo)
    }
    
    func noanimate() {
        if isComplete {
            let path = UIBezierPath(arcCenter: .zero, radius: self.frame.width, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
            let calayer = CAShapeLayer()
            calayer.path = path.cgPath
            calayer.fillColor = UIColor.mainColor.withAlphaComponent(0.5).cgColor
            calayer.position = contentView.center
            animationLayer = calayer
            contentView.layer.insertSublayer(calayer, at: 0)
        }
    }
    
    func animate() {
        animationLayer.removeFromSuperlayer()
        let path = UIBezierPath(arcCenter: .zero, radius: checkBoxButton.frame.height/2, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        let calayer = CAShapeLayer()
        calayer.path = path.cgPath
        calayer.fillColor = UIColor.mainColor.withAlphaComponent(0.5).cgColor
        calayer.position = checkBoxButton.center
                
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        if isComplete {
            animation.fromValue = 1
            animation.toValue = 30
            calayer.add(animation, forKey: "CompleteAnimation")
        } else {
            animation.fromValue = 30
            animation.toValue = 1
            animation.delegate = self
            calayer.add(animation, forKey: "notCompleteAnimation")
        }
        animationLayer = calayer
        contentView.layer.insertSublayer(calayer, at: 0)
    }
    
    func checkAnimation() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        if isComplete {
            animation.fromValue = 1
            animation.toValue = 30
        } else {
            animation.fromValue = 30
            animation.toValue = 1
            animation.delegate = self
        }
        return animation
    }

    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if !flag && animationLayer.animation(forKey: "notCompleteAnimation") == anim {
            animationLayer.removeFromSuperlayer()
            return
        }
        animationLayer.removeFromSuperlayer()
        checkBoxButton.animate()
    }
}
