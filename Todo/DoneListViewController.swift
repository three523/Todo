//
//  DoneListViewController.swift
//  Todo
//
//  Created by 김도현 on 2023/07/31.
//

import UIKit

class DoneListViewController: UIViewController {
    
    private var todoManager: TodoManager?
    @IBOutlet weak var doneTodoTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doneTodoTableView.delegate = self
        doneTodoTableView.dataSource = self
        doneTodoTableView.register(TodoTableViewCell.self, forCellReuseIdentifier: TodoTableViewCell.identifier)
        todoManager = TodoManager(viewUpdate: doneTodoTableView.reloadData)
    }
}

extension DoneListViewController: UITableViewDelegate, UITableViewDataSource, UpdateTodoDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let todoManager else { return 0 }
        return todoManager.todoCompleteCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TodoTableViewCell.identifier, for: indexPath) as? TodoTableViewCell,
              let todoManager else { return UITableViewCell() }
        let todo = todoManager.completeTodo(at: indexPath.row)
        cell.uiUpdate(todo: todo)
        cell.delegate = self
        return cell
    }
    
    func switchUpdate(todo: Todo?) {
        guard let todoManager,
            let todo else { return }
        todoManager.update(todo: todo)
    }
}
