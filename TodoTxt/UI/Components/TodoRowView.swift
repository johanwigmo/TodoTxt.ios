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
    let onUpdate: (Todo?) -> Void

    @Environment(\.theme) private var theme

    @State private var editedTitle: String = ""
    @State private var editedProject: String = ""
    @State private var editedTag: String = ""
    @State private var editedNote: String = ""
    @State private var editedUrl: String = ""
    @State private var editedDue: Date = Date()

    @FocusState private var isTitleFocused: Bool
    @FocusState private var isProjetFocused: Bool
    @FocusState private var focusedTag: String?
    @FocusState private var isNoteFocused: Bool
    @FocusState private var isUrlFocused: Bool

    @State private var isTitleEditing: Bool = false
    @State private var showDuePicker: Bool = false
    @State private var showNoteField: Bool = false
    @State private var showUrlField: Bool = false

    private var isEditing: Bool {
        isTitleEditing || isProjetFocused || focusedTag != nil ||
        isUrlFocused || isNoteFocused || showNoteField || showUrlField || showDuePicker
    }

    var body: some View {
        VStack(alignment: .leading) {
            if let due = todo.due {
                dueDateHeader(due)
            }

            HStack(alignment: .top, spacing: Spacing.Semantic.inlineGap) {
                TodoCheckbox(isCompleted: todo.isCompleted) {
                    toggleCompletion()
                }

                VStack(alignment: .leading, spacing: 0) {
                    TodoTitleEditor(
                        title: todo.title,
                        priority: todo.priority,
                        isCompleted: todo.isCompleted,
                        editedTitle: $editedTitle,
                        isEditing: $isTitleEditing,
                        isFocused: $isTitleFocused,
                        onSave: saveTitleEdit,
                        onDelete: { onUpdate(nil) }
                    )
                    .onChange(of: isTitleEditing) { _, isEditing in
                        if isEditing {
                            let priorityPrefix = todo.priority.map { "(\($0.rawValue)) " } ?? ""
                            editedTitle = "\(priorityPrefix)\(todo.title)"
                        }
                    }


                    metadataSection()

                    if isExpanded {
                        expandedContent()
                    }
                }
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            if !isEditing {
                onTap()
            }
        }
        .onAppear(perform: initializeState)
        .onChange(of: isNoteFocused) { _, isFocused in
            if !isFocused && showNoteField && editedNote.trimmingCharacters(in: .whitespaces).isEmpty {
                showNoteField = false
            }
        }
        .onChange(of: isUrlFocused) { _, isFocused in
            if !isFocused && showUrlField && editedUrl.trimmingCharacters(in: .whitespaces).isEmpty {
                showUrlField = false
            }
        }
    }
}

private extension TodoRowView {

    func dueDateHeader(_ due: Date) -> some View {
        let dueToday = Calendar.current.isDateInToday(due)

        return VStack(spacing: 0) {
            HStack {
                Color.clear.frame(width: IconSize.l)

                Button {
                    editedDue = due
                    showDuePicker.toggle()
                } label: {
                    Text(due, format: .dateTime.year().month().day())
                        .monospacedCaption(color: dueToday ? theme.warning : theme.secondaryText)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .buttonStyle(.plain)
            }

            if showDuePicker {
                Color.clear.frame(width: IconSize.l)
                DueDatePickerView(date: $editedDue, onSave: saveDue, onRemove: removeDue)
            }
        }
    }

    func metadataSection () -> some View {
        FlowLayout(spacing: Spacing.Semantic.inlineGap) {
            ProjectField(
                project: $editedProject,
                allProjects: allProjects,
                isFocused: $isProjetFocused
            )
            .onChange(of: isProjetFocused) { _, isFocused in
                if !isFocused { saveProject() }
            }

            ForEach(todo.tags, id: \.self) { tag in
                tagField(for: tag)
            }
            tagField(for: nil)
        }
        .padding(.top, Spacing.Semantic.inlineGap)
    }

    func tagField(for tag: String?) -> some View {
        let tagId = tag ?? ""
        let suggestedTag = AutocompleteSuggester.suggest(
            for: editedTag.replacingOccurrences(of: "@", with: ""),
            from: allTags,
            excluding: todo.tags
        )

        return ZStack(alignment: .leading) {
            TextField(tag == nil ? L10n.addTag : "@\(tag!)", text: Binding(
                get: { focusedTag == tagId ? editedTag : (tag.map { "@\($0)" } ?? "") },
                set: { editedTag = $0 }
            ))
            .monospacedCaption(color: theme.tag)
            .plainTextField()
            .focused($focusedTag, equals: tagId)
            .onSubmit {
                if let suggestedTag, !editedTag.isEmpty {
                    editedTag = suggestedTag
                }
                saveTag(originalTag: tag)
            }

            if focusedTag == tagId, let suggestedTag, !editedTag.isEmpty {
                let cleanedInput = editedTag
                    .replacingOccurrences(of: "@", with: "")
                    .trimmingCharacters(in: .whitespaces)

                if suggestedTag.lowercased().hasPrefix(cleanedInput.lowercased()) {
                    HStack(spacing: 0) {
                        Text(editedTag)
                            .monospacedCaption(color: .clear)

                        Text(suggestedTag.dropFirst(cleanedInput.count))
                            .monospacedCaption(color: theme.tag.opacity(0.4))
                    }
                    .allowsHitTesting(false)
                }
            }
        }
    }

    @ViewBuilder
    func expandedContent() -> some View {
        VStack(alignment: .leading, spacing: Spacing.Semantic.inlineGap) {
            if todo.note != nil {
                noteField().padding(.top, Spacing.Semantic.stackSpacing)
            }

            if todo.url != nil {
                urlField().padding(.top, Spacing.Semantic.stackSpacing)
            }

            if !todo.isCompleted {
                actionButtons().padding(.top, Spacing.Semantic.stackSpacing)
            }
        }
    }

    func noteField() -> some View {
        TextField(L10n.addNote, text: $editedNote, axis: .vertical)
            .monospacedCaption()
            .plainTextField()
            .lineLimit(1...)
            .focused($isNoteFocused)
            .onSubmit(saveNote)
            .onAppear {
                if showNoteField { isNoteFocused = true }
            }
    }

    func urlField() -> some View {
        HStack(spacing: Spacing.Semantic.inlineGap) {
            TextField(L10n.addUrl, text: $editedUrl)
                .monospacedCaption()
                .urlTextField()
                .focused($isUrlFocused)
                .onSubmit(saveUrl)
                .onAppear {
                    if showUrlField { isUrlFocused = true }
                }

            if let url = todo.url, !isUrlFocused {
                Button {
                    if let url = URL(string: url) {
                        UIApplication.shared.open(url)
                    }
                } label: {
                    Text(L10n.openUrl)
                }
                .actionButton()
            }
        }
    }

    @ViewBuilder
    func actionButtons() -> some View {
        VStack(alignment: .leading, spacing: Spacing.Semantic.stackSpacing) {
            if todo.due == nil && !showDuePicker && !showNoteField && !showUrlField {
                Button {
                    editedDue = Date()
                    showDuePicker = true
                } label: {
                    Text(L10n.addDue)
                }
                .plainActionButton()
            }

            if todo.note == nil && !showNoteField && !showUrlField && !showDuePicker {
                Button {
                    editedNote = ""
                    showNoteField = true
                } label: {
                    Text(L10n.addNote)
                }
                .plainActionButton()
            }

            if todo.url == nil && !showUrlField && !showNoteField && !showDuePicker {
                Button {
                    editedUrl = ""
                    showUrlField = true
                } label: {
                    Text(L10n.addUrl)
                }
                .plainActionButton()
            }
        }
    }
}

private extension TodoRowView {

    func initializeState() {
        editedProject = todo.project.map { "+\($0)" } ?? ""
        editedUrl = todo.url ?? ""
        editedNote = todo.note ?? ""
    }

    func toggleCompletion(){
        var updated = todo
        updated.isCompleted.toggle()
        updated.completionDate = updated.isCompleted ? Date() : nil
        onUpdate(updated)
    }

    func saveTitleEdit() {
        var newPriority: TodoPriority?
        var newTitle = editedTitle.trimmingCharacters(in: .whitespacesAndNewlines)

        if let match = newTitle.firstMatch(of: Pattern.priorityAndTitle) {
            newPriority = TodoPriority(rawValue: String(match.1))
            newTitle = match.2.map(String.init) ?? ""
        }

        guard !newTitle.isEmpty else { return }

        var updated = todo
        updated.title = newTitle
        updated.priority = newPriority
        onUpdate(updated)
        isTitleFocused = false
    }

    func saveProject() {
        let cleaned = editedProject
            .replacingOccurrences(of: "+", with: "")
            .trimmingCharacters(in: .whitespaces)

        var updated = todo
        updated.project = cleaned.isEmpty ? nil : cleaned
        onUpdate(updated)
    }

    func saveTag(originalTag: String?) {
        let cleaned = editedTag
            .replacingOccurrences(of: "@", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)

        var updated = todo

        if let originalTag {
            if cleaned.isEmpty {
                updated.tags.removeAll { $0 == originalTag}
            } else if cleaned != originalTag, let index = updated.tags.firstIndex(of: originalTag) {
                updated.tags[index] = cleaned
            }
        } else if !cleaned.isEmpty && !updated.tags.contains(cleaned) {
            updated.tags.append(cleaned)
        }

        onUpdate(updated)
        editedTag = ""
        focusedTag = nil
    }

    func saveDue() {
        var updated = todo
        updated.due = editedDue
        onUpdate(updated)
        showDuePicker = false
    }

    func removeDue() {
        var updated = todo
        updated.due = nil
        onUpdate(updated)
        showDuePicker = false
    }

    func saveNote(){
        let cleaned = editedNote.trimmingCharacters(in: .whitespaces)
        var updated = todo
        updated.note = cleaned.isEmpty ? nil : cleaned
        onUpdate(updated)
        isNoteFocused = false
        showNoteField = false
    }

    func saveUrl() {
        let cleaned = editedUrl.trimmingCharacters(in: .whitespaces)
        var updated = todo
        updated.url = cleaned.isEmpty ? nil : cleaned
        onUpdate(updated)
        isUrlFocused = false
        showUrlField = false
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
            title: "Review budget",
            priority: .A,
            project: "Work",
            tags: ["urgent", "finance"],
            due: Date(),
            url: "https://example.com",
            note: "Check with Joe first"
        ),
        isExpanded: true,
        allProjects: ["Work", "Home"],
        allTags: ["urgent", "finance", "meeting"],
        onTap: {},
        onUpdate: { _ in }
    )
    .padding()
    .previewBackground()
}
