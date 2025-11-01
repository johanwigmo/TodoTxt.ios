//
//  AddItemSheet.swift
//  TodoTxt
//
//  Created by Johan Wigmo on 2025-10-30.
//

import SwiftUI

enum ItemType {
    case header
    case todo
}

struct AddItemSheet: View {

    @Environment(\.dismiss) private var dismiss
    @Environment(\.theme) private var theme

    let allProjects: [String]
    let allTags: [String]
    let onAdd: (any Item) -> Void

    @State private var selectedType: ItemType = .todo
    @State private var title: String = ""
    @State private var priority: TodoPriority?
    @State private var project: String = ""
    @State private var tag: String = ""
    @State private var tags: [String] = []
    @State private var dueDate: Date?
    @State private var url: String = ""
    @State private var note: String = ""
    @State private var showDueDatePicker = false

    @FocusState private var isTitleFocused: Bool
    @FocusState private var isProjectFocused: Bool
    @FocusState private var isTagFocused: Bool
    @FocusState private var isUrlFocused: Bool
    @FocusState private var isNoteFocused: Bool

    var body: some View {
        NavigationStack {
            Form {
                typeSection()
                titleSection()

                if selectedType == .todo {
                    detailsSection()
                    noteSection()
                }
            }
            .scrollContentBackground(.hidden)
            .background(theme.primaryBackground)
            .navigationTitle(selectedType == .todo ? L10n.addTodo : L10n.addHeader)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(L10n.cancel) { dismiss() }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button(L10n.add, action: addItem)
                        .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            .onAppear {
                isTitleFocused = true
            }
        }
        .presentationBackground(theme.primaryBackground)
    }
}

private extension AddItemSheet {

    func typeSection() -> some View {
        Section {
            HStack(spacing: Spacing.Semantic.stackSpacing) {
                TypeSelectorButton(
                    type: .todo,
                    isSelected: selectedType == .todo,
                    colors: buttonColors,
                    action: { selectedType = .todo }
                )

                TypeSelectorButton(
                    type: .header,
                    isSelected: selectedType == .header,
                    colors: buttonColors,
                    action: { selectedType = .header }
                )
            }
        }
        .listRowInsets(EdgeInsets())
        .listRowBackground(Color.clear)
    }

    func titleSection() -> some View {
        Section {
            TextField(L10n.placeholderTitle, text: $title)
                .foregroundStyle(theme.primaryText)
                .focused($isTitleFocused)
                .onChange(of: title) { _, newValue in
                    priority = TodoTextParser.extractPriority(from: newValue).priority
                }

            if let detectedPriority = priority, selectedType == .todo {
                priorityIndicator(detectedPriority)
            }
        }
        .listRowBackground(theme.noteBackground)
    }

    func priorityIndicator(_ priority: TodoPriority) -> some View {
        HStack {
            Text("\(L10n.priority): \(priority.rawValue)")
                .font(.caption)
                .foregroundStyle(theme.secondaryText)

            Spacer()

            Button(L10n.clear) {
                self.priority = nil
            }
            .font(.caption)
        }
    }

    func detailsSection() -> some View {
        Section(L10n.details) {
            ProjectField(
                project: $project,
                allProjects: allProjects,
                isFocused: $isProjectFocused,
                font: .body,
                color: theme.primaryText
            )
            TagChipList(tags: $tags, inputTag: $tag, allTags: allTags, isFocused: $isTagFocused)

            Toggle(L10n.placeholderDueDate, isOn: $showDueDatePicker)
            if showDueDatePicker {
                DatePicker(
                    "",
                    selection: Binding(
                        get: { dueDate ?? Date() },
                        set: { dueDate = $0 }
                    ),
                    displayedComponents: [.date]
                )
                .datePickerStyle(.graphical)
            }

            TextField(L10n.addUrl, text: $url)
                .focused($isUrlFocused)
                .urlTextField()
        }
        .listRowBackground(theme.noteBackground)
    }

    func noteSection() -> some View {
        Section(L10n.note) {
            TextField(L10n.placeholderNote, text: $note, axis: .vertical)
                .foregroundStyle(theme.primaryText)
                .textFieldStyle(.plain)
                .lineLimit(1...)
        }
        .listRowBackground(theme.noteBackground)
    }

    var buttonColors: TypeSelectorButton.Colors {
        TypeSelectorButton.Colors(accent: theme.accentColor, active: theme.buttonText, inactive: theme.primaryText)
    }
}

extension AddItemSheet {

    func addItem() {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTitle.isEmpty else { return }

        let item: any Item
        switch selectedType {
        case .header:
            item = Header(title: trimmedTitle)

        case .todo:
            let finalTitle = TodoTextParser.removePriorityPrefix(from: trimmedTitle)
            item = Todo(
                title: finalTitle,
                isCompleted: false,
                completionDate: nil,
                priority: priority,
                project: project.isEmpty ? nil : project,
                tags: tags,
                due: showDueDatePicker ? dueDate ?? Date() : nil,
                url: url.isEmpty ? nil : url,
                note: note.isEmpty ? nil : note
            )
        }

        onAdd(item)
        dismiss()
    }
}

// compiler doesn't like `.buttonStyle(ifSelected ? .borderedProminent : .bordered)`
private struct TypeSelectorButton: View {

    struct Colors {
        let accent: Color
        let active: Color
        let inactive: Color
    }

    let type: ItemType
    let isSelected: Bool
    let colors: Colors
    let action: () -> Void

    var body: some View {
        let title = type == .todo ? L10n.todo : L10n.header

        if isSelected {
            Button(action: action) {
                Text(title)
                    .foregroundStyle(colors.active)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, Spacing.Semantic.stackSpacing)
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.roundedRectangle)
            .controlSize(.small)
            .tint(colors.accent)
        } else {
            Button(action: action) {
                Text(title)
                    .foregroundStyle(colors.inactive)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, Spacing.Semantic.stackSpacing)
            }
            .buttonStyle(.bordered)
            .buttonBorderShape(.roundedRectangle)
            .controlSize(.small)
            .tint(colors.accent)
        }
    }
}

#Preview("Add sheet - Todo") {
    AddItemSheet(
        allProjects: [],
        allTags: []
    ) { item in
        print("Added: \(item.title)")
    }
}
#Preview("Add sheet - Header") {
    @Previewable @State var type = ItemType.header

    AddItemSheet(
        allProjects: [],
        allTags: []
    ) { item in
        print("Added: \(item.title)")
    }
}

