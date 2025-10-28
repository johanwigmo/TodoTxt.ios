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
    @State private var expandedItemID: UUID?

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

    private var emptyState: some View {
        EmptyStateView(onLoadFile: {
            showingFilePicker = true
        })
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(theme.primaryBackground)
    }

    private var loadedState: some View {
        NavigationStack {
            List(repository.items, id: \.id) { item in
                if let header = item as? Header {
                    HeaderRowView(header: header, onUpdate: { updated in
                        // TODO: Error handling
                        if let updated {
                            try? repository.updateItem(id: updated.id, with: updated)
                        } else {
                            try? repository.removeItem(id: header.id)
                        }
                    })
                    .id(header.id)
                    .listRowInsets(.vertical, Spacing.Semantic.rowInternalSpacing)
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                } else if let todo = item as? Todo {
                    TodoRowView(
                        todo: todo,
                        isExpanded: expandedItemID == todo.id,
                        allProjects: repository.allProjects,
                        allTags: repository.allTags,
                        onTap: {
                            expandedItemID = expandedItemID == todo.id ? nil : todo.id
                        },
                        onUpdate: { updated in
                            // TODO: Error handling
                            if let updated {
                                try? repository.updateItem(id: updated.id, with: updated)
                            } else {
                                try? repository.removeItem(id: todo.id)
                            }
                        })
                    .id(todo.id)
                    .listRowInsets(.vertical, Spacing.Semantic.itemSpacing)
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                }
            }
            .listStyle(.plain)
            .background(theme.primaryBackground)
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
        }
    }
}

#Preview("Empty State") {
    TodoListScreen()
}

#Preview("Todos - Light") {
    TodoListScreen(repository: SampleDataLoader.createSampleRepository())
        .preferredColorScheme(.light)
}

#Preview("Todos - Dark") {
    TodoListScreen(repository: SampleDataLoader.createSampleRepository())
        .preferredColorScheme(.dark)
}
