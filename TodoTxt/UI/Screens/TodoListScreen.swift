//
//  TodoListScreen.swift
//  TodoTxt
//
//  Created by Johan Wigmo on 2025-10-14.
//

import SwiftUI

struct TodoListScreen: View {

    @State private var repository: TodoRepository
    @State private var searchText = ""
    @State private var showingFilePicker = false

    @Environment(\.theme) private var theme

    init(repository: TodoRepository = TodoRepository()) {
        self.repository = repository
    }

    var body: some View {
        if repository.currentFileUrl == nil {
            emptyState
        } else {
            loadedState
        }
    }

    @ViewBuilder
    private var emptyState: some View {
        EmptyStateView(onLoadFile: {
            showingFilePicker = true
        })
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(theme.primaryBackground)
    }

    @ViewBuilder
    private var loadedState: some View {
        NavigationStack {
            todoList
            .navigationTitle(L10n.defaultTitle)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingFilePicker = true
                    } label: {
                        Image(systemName: "folder")
                    }
                }
            }
            .searchable(text: $searchText, prompt: Text("Search Todos"))
            .background(theme.primaryBackground)
        }
    }

    @ViewBuilder
    private var todoList: some View {
        List(repository.lines) { line in
            Text(line.lineNumber.description)
        }
        .background(theme.primaryBackground)
    }
}

#Preview("Empty State") {
    TodoListScreen()
}

#Preview("With Todos - Light") {
    let repo = TodoRepository()

    let todos = [
        FileLine(lineNumber: 0, item: Header(title: "Work")),
        FileLine(lineNumber: 1, item: Todo(
            title: "Review Q4 budget proposal",
            priority: .A,
            project: "+Work",
            tags: ["@urgent", "@finance"],
            url: "https://budget.example.com/q4-review",
            note: "Need to check the marketing allocation before the meeting with Sarah on Friday"
        )),
        FileLine(lineNumber: 2, item: Todo(
            title: "Read design docs",
            project: "+Work",
            url: "https://docs.company.com/new-feature-spec"
        )),
        FileLine(lineNumber: 3, item: Header(title: "Personal")),
        FileLine(lineNumber: 4, item: Todo(
            title: "Buy groceries for the week including all the essentials",
            priority: .B,
            project: "+Personal",
            tags: ["@shopping"],
            note: "Don't forget: milk, eggs, bread, coffee beans, and bananas"
        )),
        FileLine(lineNumber: 5, item: Todo(
            title: "Water the plants",
            project: "+Home"
        )),
        FileLine(lineNumber: 6, item: Todo(
            title: "Send client proposal",
            isCompleted: true,
            completionDate: Date(),
            project: "+Freelance",
            tags: ["@client"]
        ))
    ]

    repo.lines = todos
    repo.currentFileUrl = URL(fileURLWithPath: "/mock/todo.txt")

    return TodoListScreen(repository: repo)
        .preferredColorScheme(.light)
}
