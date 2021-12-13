//
//  MyToDoTableViewController.swift
//  MyToDoList
//
//  Created by Adnann Muratovic on 09.12.21.
//

import UIKit


class MyToDoTableViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    var todos: [ToDo] = []

    var todosFilter: [ToDo] = []
    
    var todo: ToDo?
    override func viewDidLoad() {
        
        self.todosFilter = self.todos
        self.searchBar.delegate = self
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem
        loadSampleData()
    }
    
    private func loadSampleData() {
        if let loadTodos = ToDo.loadTodos() {
            todos = loadTodos
        } else {
            todosFilter = ToDo.loadSampleTodos()
        }
    }
    
    // MARK: - Segue
    @IBAction func unwindToToDoList(segue: UIStoryboardSegue) {
        guard segue.identifier == "saveUnwind" else { return }
        let sourceViewControler = segue.source as! ToDoDetailTableViewController
        guard  let todo = sourceViewControler.todo else { return }
        
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            todosFilter[selectedIndexPath.row] = todo
            tableView.reloadRows(at: [selectedIndexPath], with: .none)
        } else {
            let newIndexPath = IndexPath(row: todosFilter.count, section: 0)
            todosFilter.append(todo)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
        
        ToDo.saveTodos(todosFilter)
    }
    
    @IBSegueAction func editTodo(_ coder: NSCoder, sender: Any?) -> ToDoDetailTableViewController? {
        guard let cell = sender as? UITableViewCell else { return nil }
        
        if let indexPath = tableView.indexPath(for: cell) {
            let todoToEdit = todosFilter[indexPath.row]
            return ToDoDetailTableViewController(coder: coder, todo: todoToEdit)
        } else {
            return ToDoDetailTableViewController(coder: coder, todo: nil)
        }
    }
}


// MARK: - TableView DataSoruce
extension MyToDoTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

            return self.todosFilter.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PropertyKeys.cellIdentifier, for: indexPath) as! ToDoTableViewCell
        let todo = todosFilter[indexPath.row]
    
        cell.titleLabel.text = todo.title
        cell.isComplete.isSelected = todo.isComplete

        
        cell.delegate = self
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
            var todo = todosFilter[indexPath.row]
            todo.isComplete.toggle()
            todosFilter[indexPath.row] = todo
            tableView.reloadRows(at: [indexPath], with: .automatic)
            ToDo.saveTodos(todosFilter)
        }
    }
}

 // MARK: - SearchBarDelegate
extension MyToDoTableViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.endEditing(true)
        self.todosFilter = self.todos
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.todosFilter = searchText.isEmpty ? todos : todos.filter({ notes in
            return notes.title.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        })
        
        self.tableView.reloadData()
    }
}
