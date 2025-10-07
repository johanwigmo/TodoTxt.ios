//
//  ContentView.swift
//  TodoTxt
//
//  Created by Johan Wigmo on 2025-09-27.
//

import SwiftUI

struct ContentView: View {

    @State private var repository = TodoRepository()
    @State private var showError = false
    @State private var errorMessage = ""

    var body: some View {
        NavigationStack {
            listGroup
                .navigationTitle("todo.txt")
                .navigationBarTitleDisplayMode(.large)
                .toolbar { toolbar }
                .alert("Error", isPresented: $showError) {
                    Button("OK", role: .cancel) {}
                } message: {
                    Text(errorMessage)
                }
        }
    }

    @ViewBuilder
    private var listGroup: some View {
        if repository.items.isEmpty {
            ContentUnavailableView(
                "Nothing to do",
                systemImage: "checklist",
                description: Text("Load a file to get started")
            )
        } else {
            List {
                ForEach(repository.lines, id: \.id) { line in
                    if let header = line.item as? Header {
                        HeaderRowView(header: header)
                    } else if let todo = line.item as? Todo {
                        TodoRowView(
                            todo: todo,
                            lineNumber: line.lineNumber,
                            repository: repository
                        )
                    }
                }
            }
        }
    }

    @ToolbarContentBuilder
    private var toolbar: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button(action: { saveFile() }) {
                Image(systemName: "arrow.down.document.fill")
            }
            .disabled(repository.currentFileUrl == nil)
        }

        ToolbarItem(placement: .topBarLeading) {
            Button(action: { loadTestFile() }) {
                Image(systemName: "arrow.trianglehead.2.counterclockwise")
            }
        }
    }

    private func saveFile() {
        do {
            try repository.saveFile()
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }

    private func loadTestFile() {
        let testContent =
        """
        # Work
        (A) An important todo +work @urgent
        x 2015-01-01 Completed todo +work
        
        # Personal
        (B) Do something
        (C) Call someone +personal @phone note:"Ask about something" url:https://example.com
        """

        let tempUrl = FileManager.default.temporaryDirectory
            .appendingPathComponent("demo.txt")

        try? testContent.write(to: tempUrl, atomically: true, encoding: .utf8)

        do {
            try repository.loadFile(from: tempUrl)
            print("Loading success")
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }
}

struct HeaderRowView: View {
    let header: Header

    var body: some View {
        Text(header.title)
            .font(.headline)
            .fontWeight(.bold)
            .foregroundStyle(.primary)
            .padding(.vertical, 4)
    }
}

struct TodoRowView: View {

    let todo: Todo
    let lineNumber: Int
    let repository: TodoRepository

    var body: some View {
        HStack {
            Button(action: {toggleCompletion() }) {
                Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
            }
            .buttonStyle(.plain)

            Spacer()

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    if let priority = todo.priority {
                        Text("\(priority.rawValue)")
                            .font(.caption)
                            .foregroundStyle(priorityColor(priority))
                            .fontWeight(.bold)
                    }

                    Text(todo.title)
                        .strikethrough(todo.isCompleted)
                        .foregroundStyle(todo.isCompleted ? .secondary : .primary)

                    Spacer()
                }

                if let project = todo.project {
                    Label(project, systemImage: "folder")
                        .font(.caption)
                        .foregroundStyle(.blue)
                }

                HStack(spacing: 8){
                    ForEach(todo.tags, id: \.self) { tag in
                        Label(tag, systemImage: "tag")
                            .font(.caption)
                            .foregroundStyle(.orange)
                    }
                }

                if let note = todo.note {
                    Text(note)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .italic()
                }

                if let url = todo.url {
                    Text(url)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .italic()
                }
            }
        }
//        .swipeActions(edge: .trailing, swipeActions(allowsFullSwipe: false) {
//            Button(role: .destructive) {
//                deleteItem()
//            } label: {
//                Label("Delete", systemImGe: "trash")
//            }
//        }
    }

    private func toggleCompletion() {
        let updatedTodo = Todo(
            title: todo.title,
            isCompleted: !todo.isCompleted,
            completionDate: !todo.isCompleted ? Date() : nil,
            priority: todo.priority,
            project: todo.project,
            tags: todo.tags,
            reccuring: todo.reccuring,
            url: todo.url,
            note: todo.note
        )

        try? repository.updateItem(at: lineNumber, with: updatedTodo)
    }

    private func deleteItem() {
        try? repository.removeItem(at: lineNumber)
    }

    private func priorityColor(_ priority: TodoPriority) -> Color {
        return switch priority {
        case .A: .red
        case .B: .orange
        case .C: .yellow
        default: .gray
        }
    }
}

#Preview {
    ContentView()
}
