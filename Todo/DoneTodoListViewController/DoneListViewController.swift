//
//  DoneListViewController.swift
//  Todo
//
//  Created by 김도현 on 2023/07/31.
//

import UIKit
import SnapKit

final class DoneListViewController: UIViewController {
    
    private var todoManager: TodoManager = TodoManager.shared
    private let doneTodoTableView: UITableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

private extension DoneListViewController {
    func setup() {
        addViews()
        configTableView()
        configAutoLayout()
    }
    func addViews() {
        view.addSubview(doneTodoTableView)
    }
    func configAutoLayout() {
        let safeArea = view.safeAreaLayoutGuide
        doneTodoTableView.snp.makeConstraints { make in
            make.edges.equalTo(safeArea)
        }
    }
    func configTableView() {
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
        return todoManager.todoCount(category: category)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return todoManager.categoryTitle(index: section)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 16
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DoneTableViewCell.resuableIdentifier, for: indexPath) as? DoneTableViewCell else { return UITableViewCell() }
        let category = Category.allCases[indexPath.section]
        let todo = todoManager.completeTodo(category: category, at: indexPath.row)
        cell.uiUpdate(todo: todo)
        cell.selectionStyle = .none
        return cell
    }
}
