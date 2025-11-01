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
    @State private var showingAddSheet = false
    @State private var expandedItemID: UUID?
    @State private var scrollToItemID: UUID?

    @Environment(\.theme) private var theme

    init(repository: TodoRepository = TodoRepository()) {
        self.repository = repository
    }

    var body: some View {
        if repository.currentFileUrl == nil {
            emptyState
        } else {
            todoState
        }
    }

    private var emptyState: some View {
        EmptyStateView(onLoadFile: {
            showingFilePicker = true
        })
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(theme.primaryBackground)
    }

    private var todoState: some View {
        NavigationStack {
            ScrollViewReader { proxy in
                List(filteredItems, id: \.id) { item in
                    if let header = item as? Header {
                        headerRow(header: header)
                    } else if let todo = item as? Todo {
                        todoRow(todo: todo)
                    }
                }
                .listStyle(.plain)
                .background(theme.primaryBackground)
                .onChange(of: scrollToItemID) { _, newValue in
                    if let newValue {
                        handleScrollToItem(newValue, proxy: proxy)
                    }
                }
                .navigationTitle(L10n.defaultTitle)
                .navigationBarTitleDisplayMode(.large)
                .toolbar { bottomToolbar() }
                .searchable(text: $searchText, prompt: Text(L10n.placeholderSearch))
                .sheet(isPresented: $showingAddSheet) {
                    AddItemSheet(
                        allProjects: repository.allProjects,
                        allTags: repository.allTags,
                        onAdd: addItem
                    )
                }
            }
        }
    }
}

private extension TodoListScreen {

    var filteredItems: [any Item] {
        TodoSearchFilter.filter(items: repository.items, searchText: searchText)
    }

    func headerRow(header: Header) -> some View {
        HeaderRowView(
            header: header,
            onUpdate: { updated in
            // TODO: Error handling
            if let updated {
                try? repository.updateItem(id: updated.id, with: updated)
            } else {
                try? repository.removeItem(id: header.id)
            }
        })
        .id(header.id)
        .listRowInsets(.vertical, Spacing.Semantic.inlineGap)
        .listRowSeparator(.hidden)
        .listRowBackground(Color.clear)
    }

    func todoRow(todo: Todo) -> some View {
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
        .listRowInsets(.vertical, Spacing.Semantic.stackSpacing)
        .listRowSeparator(.hidden)
        .listRowBackground(Color.clear)
    }

    @ToolbarContentBuilder
    func bottomToolbar() -> some ToolbarContent {
        DefaultToolbarItem(kind: .search, placement: .bottomBar)
        ToolbarSpacer(.flexible, placement: .bottomBar)
        ToolbarItemGroup(placement: .bottomBar) {
            Spacer()
            Button {
                showingAddSheet = true
            } label: {
                Image(systemName: "plus")
            }
        }
    }
}

private extension TodoListScreen {

    func addItem(_ item: any Item) {
        repository.addItem(item)
        scrollToItemID = item.id
    }

    func handleScrollToItem(_ itemID: UUID?, proxy: ScrollViewProxy){
        guard let itemID else { return }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation {
                expandedItemID = itemID
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                proxy.scrollTo(itemID, anchor: .center)
            }
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
