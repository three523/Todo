//
//  TodoListViewController.swift
//  Todo
//
//  Created by 김도현 on 2023/07/31.
//

import UIKit

protocol UpdateTodoDelegate: AnyObject {
    func update(todo: Todo?)
}

class TodoListViewController: UIViewController {
    @IBOutlet weak var todoListTableView: UITableView!
    private var todoManager: TodoManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        todoListTableView.delegate = self
        todoListTableView.dataSource = self
        todoListTableView.register(TodoTableViewCell.self, forCellReuseIdentifier: TodoTableViewCell.identifier)
        todoManager = TodoManager(viewUpdate: todoListTableView.reloadData)
    }
    
    @IBAction func addTodo(_ sender: Any) {
        let alert = UIAlertController(title: "투두 추가", message: nil, preferredStyle: .alert)
        alert.addTextField { textfield in
            textfield.placeholder = "할일을 입력해주세요!"
        }
        let okButton = UIAlertAction(title: "확인", style: .default) { _ in
            guard let title = alert.textFields?.first?.text else { return }
            let todo = Todo(title: title, isCompleted: false)
            self.todoManager?.add(todo: todo)
        }
        let cancelButton = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(okButton)
        alert.addAction(cancelButton)
        present(alert, animated: true)
    }
}

extension TodoListViewController: UITableViewDelegate, UITableViewDataSource, UpdateTodoDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let todoManager else { return 0 }
        return todoManager.todoAllCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TodoTableViewCell.identifier, for: indexPath) as? TodoTableViewCell,
              let todoManager else {
            return UITableViewCell()
        }
        let todo = todoManager.todo(at: indexPath.row)
        cell.selectionStyle = .none
        cell.uiUpdate(todo: todo)
        cell.delegate = self
        return cell
    }
    
    func update(todo: Todo?) {
        guard let todo else { return }
        todoManager?.update(todo: todo)
    }
}
