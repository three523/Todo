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
        doneTodoTableView.estimatedRowHeight = UITableView.automaticDimension
        doneTodoTableView.register(DoneTableViewCell.self, forCellReuseIdentifier: DoneTableViewCell.resuableIdentifier)
        todoManager = TodoManager()
    }
}

extension DoneListViewController: UITableViewDelegate, UITableViewDataSource, UpdateTodoDelegate {
    func update(todo: Task?) {
        guard let todo else { return }
        todoManager?.update(todo: todo)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let todoManager else { return 0 }
        return todoManager.todoCompleteCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let todoManager,
              let cell = tableView.dequeueReusableCell(withIdentifier: DoneTableViewCell.resuableIdentifier, for: indexPath) as? DoneTableViewCell else { return UITableViewCell() }
        let todo = todoManager.todo(at: indexPath.row)
        cell.uiUpdate(todo: todo)
        cell.selectionStyle = .none
        return cell
    }
    
    func update(todo: CheckTodo?) {
        guard let todoManager,
            let todo else { return }
        todoManager.update(todo: todo)
    }
}
