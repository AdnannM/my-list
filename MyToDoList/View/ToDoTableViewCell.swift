//
//  ToDoTableViewCell.swift
//  MyToDoList
//
//  Created by Adnann Muratovic on 13.12.21.
//

import UIKit

protocol ToDoTableViewCellDelegate {
    func checkMarkTapped(sender: ToDoTableViewCell)
}

class ToDoTableViewCell: UITableViewCell {
    
    var delegate: ToDoTableViewCellDelegate?
    
    // MARK: - Properties
    @IBOutlet weak var isComplete: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

     // MARK: - Action
    @IBAction func completeButtonTapped(_ sender: UIButton) {
        delegate?.checkMarkTapped(sender: self)
    }
}
