//
//  DoneListViewController.swift
//  Todo
//
//  Created by 김도현 on 2023/07/31.
//

import UIKit

final class DoneListViewController: UIViewController {
    
    private var todoManager: TodoManager = TodoManager.shared
    @IBOutlet weak var doneTodoTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
    }
    
    private func configTableView() {
        doneTodoTableView.delegate = self
        doneTodoTableView.dataSource = self
        doneTodoTableView.estimatedRowHeight = UITableView.automaticDimension
        doneTodoTableView.register(DoneTableViewCell.self, forCellReuseIdentifier: DoneTableViewCell.resuableIdentifier)
    }
}

extension DoneListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Category.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let category = Category.allCases[section]
        return todoManager.todoCompleteCount(category: category)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Category.allCases[section].title
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 16
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DoneTableViewCell.resuableIdentifier, for: indexPath) as? DoneTableViewCell else { return UITableViewCell() }
        let category = Category.allCases[indexPath.section]
        guard let todo = todoManager.completeTodo(category: category, at: indexPath.row) else { return UITableViewCell() }
        cell.uiUpdate(todo: todo)
        cell.selectionStyle = .none
        return cell
    }
}