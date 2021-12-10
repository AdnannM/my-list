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
    
    static func ==(lhs: ToDo, rhs: ToDo) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func loadTodos() -> [ToDo]? {
        return nil
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
        
        let todoThree = ToDo(title: "Todo Three",
                           isComplete: false,
                           duoDate: Date(),
                           notes: "Notes Three")
        
        return [todoOne, todoTwo, todoThree]
    }
}
