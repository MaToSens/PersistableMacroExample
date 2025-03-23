//
//  TodoListView.swift
//  PersistableMacroExample
//
//  Created by MaTooSens on 23/03/2025.
//

import SwiftUI

struct TodoListView: View {
    @StateObject private var viewModel = TodoListViewModel()
    
    var body: some View {
        List {
            Section {
                TextField("Enter todo name", text: $viewModel.todoTitle)
                    .onSubmit { viewModel.createTodo() }
            }
            
            Section {
                ForEach(viewModel.todos) { todo in
                    Text(todo.title)
                }
                .onDelete(perform: viewModel.deleteTodo)
            }
        }
        .navigationTitle("TODO LIST")
    }
}

#Preview {
    TodoListView()
}
