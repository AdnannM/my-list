//
//  ToDoDetailTableViewController.swift
//  MyToDoList
//
//  Created by Adnann Muratovic on 10.12.21.
//

import UIKit
import MessageUI

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
    
    var todo: ToDo?
    
    
    init?(coder: NSCoder, todo: ToDo?) {
        self.todo = todo
        super.init(coder: coder)
    }
    
    required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        if let todo = todo {
            navigationItem.title = "To-Do"
            titleTextField.text = todo.title
            isCompleteButton.isSelected = todo.isComplete
            dueDatePicker.date = todo.duoDate
            notesTextView.text = todo.notes
        } else {
            // update datePicker date when the view Controller is first displayed
            dueDatePicker.date = Date().addingTimeInterval(24*60*60)
        }
        
        updateDateLabel(date: dueDatePicker.date)
        updateSaveButtonState()
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
    
    // Share Notes With Mail
    @IBAction func shareNotesWithMail(_ sender: UIBarButtonItem) {
        guard MFMailComposeViewController.canSendMail() else {
            print("Can't Sand Mail!")
            return
        }
        
        let messageBody = "Title: \(titleTextField.text!), Date: \(dueDateLabel.text!), Notes: \(notesTextView.text!)"
        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = self
        mailComposer.setToRecipients(["example@examplse.com"])
        mailComposer.setMessageBody(messageBody, isHTML: false)
        
        self.present(mailComposer, animated: true, completion: nil)
    }
    
    
    
    // MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "saveUnwind" else { return }
        
        let title = titleTextField.text!
        let isComplete = isCompleteButton.isSelected
        let dueDate = dueDatePicker.date
        let notes = notesTextView.text
        
        todo = ToDo(title: title, isComplete: isComplete, duoDate: dueDate, notes: notes)
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

 // MARK: - Mail Delegate
extension ToDoDetailTableViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true, completion: nil)
    }
}
