//
//  Todo.swift
//  PersistableMacroExample
//
//  Created by MaTooSens on 23/03/2025.
//

import Foundation
import Persistable

@Persistable
struct Todo {
    let id: String
    let title: String
    let isCompleted: Bool
    let createdAt: Date
    
    init(
        id: String = UUID().uuidString,
        title: String,
        isCompleted: Bool = false,
        createdAt: Date = .now
    ) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
        self.createdAt = createdAt
    }
}
