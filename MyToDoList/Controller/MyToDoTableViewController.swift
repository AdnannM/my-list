//
//  MyToDoTableViewController.swift
//  MyToDoList
//
//  Created by Adnann Muratovic on 09.12.21.
//

import UIKit


class MyToDoTableViewController: UITableViewController {
    
    var todos: [ToDo] = []

    var todo: ToDo?
    override func viewDidLoad() {
        
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem
        loadSampleData()
    }
    
    private func loadSampleData() {
        if let loadTodos = ToDo.loadTodos() {
            todos = loadTodos
        } else {
            todos = ToDo.loadSampleTodos()
        }
    }
    
    // MARK: - Segue
    @IBAction func unwindToToDoList(segue: UIStoryboardSegue) {
        guard segue.identifier == "saveUnwind" else { return }
        let sourceViewControler = segue.source as! ToDoDetailTableViewController
        guard  let todo = sourceViewControler.todo else { return }
        
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            todos[selectedIndexPath.row] = todo
            tableView.reloadRows(at: [selectedIndexPath], with: .none)
        } else {
            let newIndexPath = IndexPath(row: todos.count, section: 0)
            todos.append(todo)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
        
        ToDo.saveTodos(todos)
    }
    
    @IBSegueAction func editTodo(_ coder: NSCoder, sender: Any?) -> ToDoDetailTableViewController? {
        guard let cell = sender as? UITableViewCell else { return nil }
        
        if let indexPath = tableView.indexPath(for: cell) {
            let todoToEdit = todos[indexPath.row]
            return ToDoDetailTableViewController(coder: coder, todo: todoToEdit)
        } else {
            return ToDoDetailTableViewController(coder: coder, todo: nil)
        }
    }
}


// MARK: - TableView DataSoruce
extension MyToDoTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PropertyKeys.cellIdentifier, for: indexPath) as! ToDoTableViewCell
        let todo = todos[indexPath.row]
        cell.titleLabel.text = todo.title
        cell.delegate = self
        cell.isComplete.isSelected = todo.isComplete
        return cell
    }
    
    // For Edit Button in Left Corner
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Swipe to Delete
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            todos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            ToDo.saveTodos(todos)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - PropertyKeys
extension MyToDoTableViewController {
    struct PropertyKeys {
        static let cellIdentifier = "todoCell"
    }
}

 // MARK: - Protocol
extension MyToDoTableViewController: ToDoTableViewCellDelegate {
    func checkMarkTapped(sender: ToDoTableViewCell) {
        if let indexPath = tableView.indexPath(for: sender) {
            var todo = todos[indexPath.row]
            todo.isComplete.toggle()
            todos[indexPath.row] = todo
            tableView.reloadRows(at: [indexPath], with: .automatic)
            ToDo.saveTodos(todos)
        }
    }
}

