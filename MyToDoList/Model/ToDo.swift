//
//  ToDo.swift
//  MyToDoList
//
//  Created by Adnann Muratovic on 09.12.21.
//

import Foundation
// import UIKit
struct ToDo: Codable, Equatable {
    var id = UUID()
    var title: String
    var isComplete: Bool
    var duoDate: Date
    var notes: String?
    
    /// TODO: 
    // var image: UIImage?
    
    // Date Formatter
    static let dateFormatter: DateFormatter = {
       let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        
        return dateFormatter
    }()
    
    // MARK: - Save
    static let documentDirectry = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    static let archiveURL = documentDirectry?.appendingPathComponent("todos").appendingPathExtension("plist")
    
    static func loadTodos() -> [ToDo]? {
        guard let archiveURL = archiveURL else { return nil }
        guard let codedTodos = try? Data(contentsOf: archiveURL) else { return nil }
        
        let propertyListDecoder = PropertyListDecoder()
        
        return try? propertyListDecoder.decode([ToDo].self, from: codedTodos)
    }
    
    static func saveTodos(_ todos: [ToDo]) {
        let propertyListEncoder = PropertyListEncoder()
        let codedTodos = try? propertyListEncoder.encode(todos)
        
        guard let archiveURL = archiveURL else { return }
        try? codedTodos?.write(to: archiveURL, options: .noFileProtection)
    }
    
    static func ==(lhs: ToDo, rhs: ToDo) -> Bool {
        return lhs.id == rhs.id
    }

    static func loadSampleTodos() -> [ToDo] {
        let todoOne = ToDo(title: "Todo One",
                           isComplete: false,
                           duoDate: Date(),
                           notes: "Notes One")

        let todoTwo = ToDo(title: "Todo Two",
                           isComplete: false,
                           duoDate: Date(),
                           notes: "Notes Two")


        return [todoOne, todoTwo]
    }
}

