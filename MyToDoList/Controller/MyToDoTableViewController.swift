//
//  MyToDoTableViewController.swift
//  MyToDoList
//
//  Created by Adnann Muratovic on 09.12.21.
//

import UIKit


class MyToDoTableViewController: UITableViewController {
    
    var todos: [ToDo] = []

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
        
    }
}

// MARK: - TableView DataSoruce
extension MyToDoTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PropertyKeys.cellIdentifier, for: indexPath)
        let todo = todos[indexPath.row]
        cell.textLabel?.text = todo.title
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
        }
    }
}

// MARK: - PropertyKeys
extension MyToDoTableViewController {
    struct PropertyKeys {
        static let cellIdentifier = "todoCell"
    }
}
