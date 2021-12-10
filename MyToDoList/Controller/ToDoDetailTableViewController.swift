//
//  ToDoDetailTableViewController.swift
//  MyToDoList
//
//  Created by Adnann Muratovic on 10.12.21.
//

import UIKit

class ToDoDetailTableViewController: UITableViewController {
    
    // MARK: - Properties
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var isCompleteButton: UIButton!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateSaveButtonState()
    }
    
    private func updateSaveButtonState() {
        let shoudEnableSaveButton = titleTextField.text?.isEmpty == false
        saveButton.isEnabled = shoudEnableSaveButton
    }
    
    // MARK: - Action
    @IBAction func textEditChanged(_ sender: Any) {
        updateSaveButtonState()
    }
}
