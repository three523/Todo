//
//  CountTodoTableViewCell.swift
//  Todo
//
//  Created by 김도현 on 2023/08/03.
//

import UIKit

final class CountTodoTableViewCell: UITableViewCell, CAAnimationDelegate, Animation {
    private let todoLabel: UILabel = {
        let lb = UILabel()
        lb.font = .systemFont(ofSize: 18, weight: .regular)
        lb.text = "투두"
        return lb
    }()
    private let upButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "plus"), for: .normal)
        return btn
    }()
    private let downButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "minus"), for: .normal)
        return btn
    }()
    private let countButton: CompleteButton = {
        let btn = CompleteButton()
        btn.setTitle("0", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor(red: 106/255, green: 209/255, blue: 213/255, alpha: 1.0).cgColor
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 5
        return btn
    }()
    var isCompleted: Bool = false
    var todo: CountTodoEntity?
    var category: Category = .life
    weak var delegate: UpdateTodoDelegate?
    var animationLayer: CALayer = CALayer()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(todoLabel)
        contentView.addSubview(countButton)
        contentView.addSubview(upButton)
        contentView.addSubview(downButton)
        contentView.layer.masksToBounds = true
        
        configAutoLayout()
        configButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configAutoLayout() {
        todoLabel.translatesAutoresizingMaskIntoConstraints = false
        todoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18).isActive = true
        todoLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        todoLabel.trailingAnchor.constraint(greaterThanOrEqualTo: upButton.leadingAnchor, constant:-18).isActive = true
        
        upButton.translatesAutoresizingMaskIntoConstraints = false
        upButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        upButton.heightAnchor.constraint(equalTo: countButton.heightAnchor).isActive = true
        upButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        upButton.trailingAnchor.constraint(equalTo: countButton.leadingAnchor).isActive = true
        
        countButton.translatesAutoresizingMaskIntoConstraints = false
        countButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12).isActive = true
        countButton.trailingAnchor.constraint(equalTo: downButton.leadingAnchor).isActive = true
        countButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12).isActive = true
        countButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        let countButtonHeight = countButton.heightAnchor.constraint(equalToConstant: 30)
        countButtonHeight.priority = UILayoutPriority(rawValue: 999)
        countButtonHeight.isActive = true
        
        downButton.translatesAutoresizingMaskIntoConstraints = false
        downButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        downButton.heightAnchor.constraint(equalTo: countButton.heightAnchor).isActive = true
        downButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        downButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18).isActive = true
    }
    
    private func configButton() {
        upButton.addTarget(self, action: #selector(countIncrease), for: .touchUpInside)
        downButton.addTarget(self, action: #selector(countDecrease), for: .touchUpInside)
        
        countButton.animationCompleted = {
            if self.isCompleted {
                self.animation(animationRadius: self.countButton.frame.height, center: self.countButton.center)
            }
        }
    }
    
    func uiUpdate(todo: CountTodoEntity, category: Category) {
        self.todo = todo
        self.category = category
        isCompleted = todo.isCompleted
        todoLabel.text = todo.title
        countButton.setTitle("\(todo.count)", for: .normal)
        animationLayer.removeFromSuperlayer()
        countButton.animationLayer.removeFromSuperlayer()
        let count = todo.count > todo.goal ? todo.goal : todo.count
        countButton.noAnimation(height: 31, count: CGFloat(count), goal: CGFloat(todo.goal))
        contentView.backgroundColor = isCompleted ? .mainColor.withAlphaComponent(0.5) : .clear
    }
    
    func testUiUpdate(todo: CountTodoEntity, category: Category) {
        self.todo = todo
        self.category = category
        isCompleted = todo.isCompleted
        todoLabel.text = todo.title
        countButton.setTitle("\(todo.count)", for: .normal)
        animationLayer.removeFromSuperlayer()
        countButton.animationLayer.removeFromSuperlayer()
        let count = todo.count > todo.goal ? todo.goal : todo.count
        countButton.noAnimation(height: 31, count: CGFloat(count), goal: CGFloat(todo.goal))
        contentView.backgroundColor = isCompleted ? .mainColor.withAlphaComponent(0.5) : .clear
    }
    
    func animation(animationRadius: CGFloat, center: CGPoint) {
        guard let todo else { return }
        var fromValue = 1.0
        var toValue = 1.0
        var forkey: String?
        if isCompleted {
            fromValue = 1
            toValue = 30
            forkey = "CompleteAnimation"
        } else if todo.count + 1 == todo.goal {
            fromValue = 30
            toValue = 1
            forkey = "notCompleteAnimation"
            contentView.backgroundColor = .white
        } else {
            countButton.countAnimation(count: CGFloat(todo.count), goal: CGFloat(todo.goal), isIncrease: false)
            return
        }
        animationLayer = animateLayer(animationRadius: animationRadius, center: center, color: UIColor.mainColor.withAlphaComponent(0.5), fromValue: fromValue, toValue: toValue, forKey: forkey)
        contentView.layer.insertSublayer(animationLayer, at: 0)
    }
    
    @objc func countIncrease() {
        self.todo?.count += Int16(1)
        guard let todo else { return }
        isCompleted = todo.count >= todo.goal
        if todo.isCompleted != isCompleted {
            self.todo?.isCompleted = isCompleted
        }
        let count = isCompleted ? todo.goal : todo.count
        countButton.isCompleted = isCompleted
        if todo.count <= todo.goal {
            countButton.countAnimation(count: CGFloat(count), goal: CGFloat(todo.goal), isIncrease: true)
        }
        countButton.setTitle("\(todo.count)", for: .normal)
        delegate?.update(todo: self.todo, category: category)
    }
    
    @objc func countDecrease() {
        guard let todo else { return }
        if todo.count == 0 { return }
        let todoCount = todo.count - Int16(1)
        self.todo?.count = todoCount
        isCompleted = todoCount >= todo.goal
        if todo.isCompleted != isCompleted {
            self.todo?.isCompleted = isCompleted
        }
        countButton.isCompleted = isCompleted
        
        if !isCompleted { animation(animationRadius: self.countButton.frame.height, center: self.countButton.center) }
        countButton.setTitle("\(todoCount)", for: .normal)
        delegate?.update(todo: self.todo, category: category)
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if animationLayer.animation(forKey: "notCompleteAnimation") == anim {
            guard let todo else { return }
            animationLayer.removeFromSuperlayer()
            let count = isCompleted ? todo.goal : todo.count
            countButton.countAnimation(count: CGFloat(count), goal: CGFloat(todo.goal), isIncrease: false)
        }
    }
}
