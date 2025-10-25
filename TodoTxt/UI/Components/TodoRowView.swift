//
//  TodoRowView.swift
//  TodoTxt
//
//  Created by Johan Wigmo on 2025-10-17.
//

import SwiftUI

struct TodoRowView: View {

    let todo: Todo
    let isExpanded: Bool
    let allProjects: [String]
    let allTags: [String]
    let onTap: () -> Void
    let onUpdate: (Todo) -> Void

    @Environment(\.theme) private var theme

    @State private var editedTitle: String = ""
    @State private var isEditingTitle: Bool = false
    @FocusState private var titleFieldFocused: Bool

    @State private var editedProject: String = ""
    @FocusState private var isEditingProject: Bool

    @State private var isEditingTag = false
    @State private var isEditingUrl = false
    @State private var isEditingNote = false

    @State private var editedTag: String = ""
    @State private var editedUrl: String = ""
    @State private var editedNote: String = ""

    private var isEditing: Bool {
        isEditingTitle || isEditingProject || isEditingTag || isEditingUrl || isEditingNote
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top, spacing: Spacing.Semantic.rowInternalSpacing) {
                checkbox()

                VStack(alignment: .leading) {
                    titleSection()
                    projectAndTagsSection()

                    if isExpanded {
                        urlSection()
                            .padding(.top, Spacing.Semantic.itemSpacing)
                        noteSection()
                            .padding(.top, Spacing.Semantic.rowInternalSpacing)
                        actionButtonSection()
                            .padding(.top, Spacing.Semantic.rowInternalSpacing)
                    }
                }
            }
        }
        .background(isExpanded ? Color.red : Color.clear) // TODO: This is temporary
        .contentShape(Rectangle())
        .onTapGesture {
            if !isEditing {
                onTap()
            }
        }
        .onAppear() {
            editedTitle = todo.title
            if let project = todo.project {
                editedProject = "+\(project)"
            }
            editedUrl = todo.url ?? ""
            editedNote = todo.note ?? ""
        }
        .onChange(of: titleFieldFocused) { oldValue, newValue in
            if oldValue && !newValue && isEditingTitle {
                cancelTitleEdit()
            }
        }
        .onChange(of: isEditingProject) { oldValue, newValue in
            if oldValue && !newValue {
                cancelProjectEdit()
            }
        }
    }
}

// MARK: Checkbox

private extension TodoRowView {

    func checkbox() -> some View {
        Button {
            var updated = todo
            updated.isCompleted.toggle()
            updated.completionDate = updated.isCompleted ? Date() : nil
            onUpdate(updated)
        } label: {
            Image(systemName: todo.isCompleted ? "checkmark.square.fill" : "square")
                .font(.title2)
                .foregroundStyle(todo.isCompleted ? theme.completed : theme.secondaryText)
                .frame(width: IconSize.l, height: IconSize.l)
                .padding(.vertical, -Spacing.xxs)
        }
        .buttonStyle(.plain)
    }
}

// MARK: Title

private extension TodoRowView {

    @ViewBuilder
    func titleSection() -> some View {
        if isEditingTitle {
            TextField(L10n.placeholderTitle, text: $editedTitle, axis: .vertical)
                .font(.system(.body, design: .monospaced))
                .textFieldStyle(.plain)
                .foregroundStyle(todo.isCompleted ? theme.secondaryText : theme.primaryText)
                .lineLimit(1...)
                .onSubmit {
                    saveTitleEdit()
                    isEditingTitle = false
                }
                .focused($titleFieldFocused)
                .onAppear {
                    titleFieldFocused = true
                }
        } else {
            Text(styledTitle)
                .frame(maxWidth: .infinity, alignment: .leading)
                .onTapGesture {
                    let priority = todo.priority.map { "(\($0.rawValue)) "} ?? ""
                    editedTitle = "\(priority)\(todo.title)"
                    isEditingTitle = true
                }
        }
    }

    var styledTitle: AttributedString {
        var result = AttributedString()

        if let priority = todo.priority {
            var text = AttributedString("(\(priority.rawValue)) ")
            text.font = .system(.body, design: .monospaced).bold()
            text.foregroundColor = theme.priority
            result.append(text)
        }

        var text = AttributedString(todo.title)
        text.font = .system(.body, design: .monospaced)
        text.foregroundColor = todo.isCompleted ? theme.secondaryText : theme.primaryText

        if todo.isCompleted {
            text.strikethroughStyle = .single
        }

        result.append(text)

        return result
    }

    func saveTitleEdit() {
        var newPriority: TodoPriority? = nil
        var newTitle = editedTitle.trimmingCharacters(in: .whitespacesAndNewlines)

        if let match = newTitle.firstMatch(of: Pattern.priorityAndTitle) {
            newPriority = TodoPriority(rawValue: String(match.1))
            newTitle = String(match.2)
        }

        var updated = todo
        updated.title = newTitle
        updated.priority = newPriority
        onUpdate(updated)
    }

    func cancelTitleEdit() {
        isEditingTitle = false
        editedTitle = todo.title
    }
}

// MARK: Project & Tags

private extension TodoRowView {

    func projectAndTagsSection() -> some View {
        FlowLayout(spacing: Spacing.Semantic.elementGap) {
            projectView()
            // TODO: Tags
        }
    }

    func projectView() -> some View {
        ZStack(alignment: .leading) {
            TextField(L10n.addProject, text: $editedProject)
                .font(.system(.subheadline, design: .monospaced))
                .foregroundStyle(theme.project)
                .textFieldStyle(.plain)
                .onSubmit {
                    if isEditingProject, let firstMatch = filteredProjects.first, !editedProject.isEmpty {
                        let searchTerm = editedProject
                            .replacingOccurrences(of: "+", with: "")
                            .trimmingCharacters(in: .whitespaces)

                        // Only use suggestion if it matches the prefix
                        if firstMatch.lowercased().hasPrefix(searchTerm.lowercased()) {
                            editedProject = firstMatch
                        }
                    }

                    saveProject()
                    isEditingTitle = false
                }
                .focused($isEditingProject)
                .autocorrectionDisabled()

            if isEditingProject,
               let firstMatch = filteredProjects.first,
               !editedProject.isEmpty {
                let searchTerm = editedProject
                    .replacingOccurrences(of: "+", with: "")
                    .trimmingCharacters(in: .whitespaces)

                if firstMatch.lowercased().hasPrefix(searchTerm.lowercased()) {
                    HStack(spacing: 0) {
                        Text(editedProject)
                            .font(.system(.subheadline, design: .monospaced))
                            .foregroundStyle(.clear) // Hiden to align with TextField
                        Text(firstMatch.dropFirst(searchTerm.count))
                            .font(.system(.subheadline, design: .monospaced))
                            .foregroundStyle(theme.project.opacity(0.4))
                    }
                    .allowsHitTesting(false)
                }
            }
        }
    }

    func saveProject() {
        var newProject: String?
        if !editedProject.isEmpty {
            newProject = editedProject
                .replacingOccurrences(of: "+", with: "")
                .replacingOccurrences(of: " ", with: "")
        } else {
            newProject = nil
        }

        var updated = todo
        updated.project = newProject
        onUpdate(updated)
    }

    func cancelProjectEdit() {
        isEditingProject = false
        if let project = todo.project {
            editedProject = "+\(project)"
        } else {
            editedProject = ""
        }
    }

    var filteredProjects: [String] {
        let searchTerm = editedProject
            .replacingOccurrences(of: "+", with: "")
            .trimmingCharacters(in: .whitespaces)

        if searchTerm.isEmpty {
            return Array(allProjects.prefix(5))
        }

        return allProjects.filter { $0.localizedCaseInsensitiveContains(searchTerm) }
    }
}

private extension TodoRowView {

    @ViewBuilder
    private func urlSection() -> some View {

    }

    @ViewBuilder
    private func noteSection() -> some View {

    }

    @ViewBuilder
    private func actionButtonSection() -> some View {

    }
}

#Preview("Basic") {
    TodoRowView(
        todo: Todo(title: "Buy groceries", priority: .B),
        isExpanded: false,
        allProjects: [],
        allTags: [],
        onTap: {},
        onUpdate: { _ in }
    )
    .padding()
    .previewBackground()
}

#Preview("Expanded") {
    TodoRowView(
        todo: Todo(
            title: "Review budget, and send proposal to everyone",
            priority: .A,
            project: "Work",
            tags: ["urgent", "finance"],
            url: "https://example.com",
            note: "Check with Joe first"
        ),
        isExpanded: true,
        allProjects: [],
        allTags: [],
        onTap: {},
        onUpdate:  { _ in }
    )
    .padding()
    .previewBackground()
}
