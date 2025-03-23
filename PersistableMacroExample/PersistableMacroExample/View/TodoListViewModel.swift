//
//  TodoListViewModel.swift
//  PersistableMacroExample
//
//  Created by MaTooSens on 23/03/2025.
//

import Foundation

final class TodoListViewModel: ObservableObject {
    
    private let manager = DatabaseManager.shared
    
    @Published var todoTitle: String = ""
    @Published private(set) var todos: [Todo] = []
    
    init() { readTodos() }
    
    func createTodo() {
        let newTodo: Todo = .init(title: todoTitle)
        
        do {
            try manager.create(object: newTodo)
            todoTitle = ""
            readTodos()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func readTodos() {
        do {
            self.todos = try manager.readAll()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteTodo(at offsets: IndexSet) {
        guard let index = offsets.first else { return }
        
        do {
            try manager.delete(object: todos[index])
            readTodos()
        } catch {
            print(error.localizedDescription)
        }
    }
}
