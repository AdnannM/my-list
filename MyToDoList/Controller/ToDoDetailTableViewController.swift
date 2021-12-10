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
    
    var isDatePickerHidden: Bool = true
    let dateLabelIndexPath = IndexPath(row: 1, section: 2)
    let datePickerIndexPath = IndexPath(row: 2, section: 2)
    let notesIndexPath = IndexPath(row: 0, section: 2)
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // update datePicker date when the view Controller is first displayed
        dueDatePicker.date = Date().addingTimeInterval(24*60*60)
        
        updateSaveButtonState()
        updateDateLabel(date: dueDatePicker.date)
    }
    
    // MARK: - Helpers Methods
    private func updateSaveButtonState() {
        let shoudEnableSaveButton = titleTextField.text?.isEmpty == false
        saveButton.isEnabled = shoudEnableSaveButton
    }
    
    private func updateDateLabel(date: Date) {
        dueDateLabel.text = ToDo.dateFormatter.string(from: date)
    }
    
    // MARK: - Action
    @IBAction func textEditChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    @IBAction func returnPressed(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    @IBAction func isCompleteSelected(_ sender: UIButton) {
        isCompleteButton.isSelected.toggle()
    }
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        updateDateLabel(date: sender.date)
    }
}

// MARK: - TableView
extension ToDoDetailTableViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case dateLabelIndexPath where isDatePickerHidden == true:
            return 0
        case notesIndexPath:
            return 200
        default:
            return UITableView.automaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath == dateLabelIndexPath {
            isDatePickerHidden.toggle()
            dueDateLabel.textColor = .black
            updateDateLabel(date: dueDatePicker.date)
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
}
