//
//  DoneTableViewCell.swift
//  Todo
//
//  Created by 김도현 on 2023/08/11.
//

import UIKit

final class DoneTableViewCell: UITableViewCell {
    var todo: Task? = nil
    private var titleLabel: UILabel = {
        let lb = UILabel()
        lb.font = .systemFont(ofSize: 20, weight: .regular)
        lb.textColor = .black
        return lb
    }()
    private var doneTimeLabel: UILabel = {
        let lb = UILabel()
        lb.font = .systemFont(ofSize: 12, weight: .regular)
        lb.textColor = .black
        return lb
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(doneTimeLabel)
        
        configAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configAutoLayout() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12).isActive = true
        
        doneTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        doneTimeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6).isActive = true
        doneTimeLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        doneTimeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12).isActive = true
    }
    
    func uiUpdate(todo: Task) {
        self.todo = todo
        guard let doneTime = todo.doneTime else { return }
        titleLabel.text = todo.title
        doneTimeLabel.text = doneTime.dateTimeString()
    }

}
