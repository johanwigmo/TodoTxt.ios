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

    @State private var showDuePicker: Bool = false
    @State private var editedDue: Date = Date()

    @State private var editedTitle: String = ""
    @State private var isEditingTitle: Bool = false
    @FocusState private var titleFieldFocused: Bool

    @State private var editedProject: String = ""
    @FocusState private var isEditingProject: Bool

    @State private var editedTag: String = ""
    @FocusState private var focusedTag: String? // nil = none, "" = new tag, or tag name

    @State private var editedNote: String = ""
    @State private var showNoteField: Bool = false
    @FocusState private var isEditingNote: Bool

    @State private var editedUrl: String = ""
    @State private var showUrlField: Bool = false
    @FocusState private var isEditingUrl: Bool


    @State private var showDeleteAlert: Bool = false

    private var isEditing: Bool {
        isEditingTitle || isEditingProject || focusedTag != nil || isEditingUrl || isEditingNote || showNoteField || showUrlField || showDuePicker
    }

    private static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }()

    var body: some View {
        VStack(alignment: .leading) {
            if todo.due != nil {
                dueSection()
            }

            HStack(alignment: .top, spacing: Spacing.Semantic.rowInternalSpacing) {
                checkbox()

                VStack(alignment: .leading) {
                    titleSection()
                    projectAndTagsSection()

                    if isExpanded {
                        noteSection()
                            .padding(.top, Spacing.Semantic.itemSpacing)
                        urlSection()
                            .padding(.top, Spacing.Semantic.rowInternalSpacing)
                        actionButtonSection()
                            .padding(.top, Spacing.Semantic.rowInternalSpacing)
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
        .onAppear() {
            let priority = todo.priority.map { "(\($0.rawValue)) "} ?? ""
            editedTitle = "\(priority)\(todo.title)"

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
        .onChange(of: focusedTag) { oldValue, newValue in
            if newValue == nil && oldValue != nil {
                cancelTagEdit()
            }
        }
        .onChange(of: isEditingNote) { oldValue, newValue in
            if oldValue && !newValue && showNoteField {
                if editedNote.trimmingCharacters(in: .whitespaces).isEmpty {
                    showNoteField = false
                }
            }
        }
        .onChange(of: isEditingUrl) { oldValue, newValue in
            if oldValue && !newValue && showUrlField {
                if editedUrl.trimmingCharacters(in: .whitespaces).isEmpty {
                    showUrlField = false
                }
            }
        }
    }
}

// MARK: Due

private extension TodoRowView {

    @ViewBuilder
    func dueSection() -> some View {
        if let due = todo.due {
            let dueToday = Calendar.current.isDateInToday(due)
            HStack {
                Color.clear.frame(width: IconSize.l)
                Button {
                    editedDue = due
                    showDuePicker.toggle()
                } label: {
                    Text(Self.dateFormatter.string(from: due) )
                        .font(.system(.caption, design: .monospaced))
                        .foregroundStyle(dueToday ? theme.warning : theme.secondaryText)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .buttonStyle(.plain)
                .controlSize(.small)
            }

            if showDuePicker {
                Color.clear.frame(width: IconSize.l)
                dueDatePicker()
            }
        }
    }

    @ViewBuilder
    func dueDatePicker() -> some View {
        VStack(alignment: .leading) {
            DatePicker(
                "",
                selection: $editedDue,
                displayedComponents: [.date]
            )
            .datePickerStyle(.graphical)
            .labelsHidden()
            .tint(theme.accentColor)

            HStack {
                Button(L10n.removeDue) {
                    isEditingUrl = false
                    resetDue()
                }
                .tint(theme.warning)
                Spacer()
                Button(L10n.setDue) {
                    isEditingUrl = false
                    saveDue()
                }
                .tint(theme.accentColor)
            }
            .font(.system(.caption, design: .monospaced))
            .fontWeight(.medium)
            .foregroundStyle(theme.buttonText)
            .buttonStyle(.borderedProminent)
            .controlSize(.small)
            .padding(.bottom, Spacing.Semantic.rowInternalSpacing)
        }
        .frame(maxHeight: .infinity, alignment: .top)

    }

    func saveDue() {
        var updated = todo
        updated.due = editedDue
        onUpdate(updated)

        showDuePicker = false
    }

    func resetDue() {
        var updated = todo
        updated.due = nil
        onUpdate(updated)

        showDuePicker = false
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
        VStack {
            if isEditingTitle {
                TextField(L10n.placeholderTitle, text: $editedTitle, axis: .vertical)
                    .font(.system(.body, design: .monospaced))
                    .textFieldStyle(.plain)
                    .foregroundStyle(todo.isCompleted ? theme.secondaryText : theme.primaryText)
                    .lineLimit(1...)
                    .focused($titleFieldFocused)
                    .onSubmit {
                        saveTitleEdit()
                    }
                    .onAppear {
                        let priority = todo.priority.map { "(\($0.rawValue)) "} ?? ""
                        editedTitle = "\(priority)\(todo.title)"

                        titleFieldFocused = true
                    }
            } else {
                Text(styledTitle)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .onTapGesture {
                        isEditingTitle = true
                    }
            }
        }
        .alert(L10n.deleteItem, isPresented: $showDeleteAlert) {
            Button(L10n.delete, role: .destructive) {
                onUpdate(nil)
                isEditingTitle = false
            }
            Button(L10n.cancel, role: .cancel) {
                isEditingTitle = true
            }
        } message: {
            Text(L10n.deleteTodoDescription)
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

        if newTitle.isEmpty {
            showDeleteAlert = true
            return
        }

        var updated = todo
        updated.title = newTitle
        updated.priority = newPriority
        onUpdate(updated)
        isEditingTitle = false
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

            ForEach(todo.tags, id: \.self) { tag in
                tagView(tag: tag)
            }
            tagView(tag: nil)
        }
    }

    func projectView() -> some View {
        ZStack(alignment: .leading) {
            TextField(editedProject == "" ? L10n.addProject : "", text: $editedProject)
                .font(.system(.caption, design: .monospaced))
                .foregroundStyle(theme.project)
                .textFieldStyle(.plain)
                .onSubmit {
                    if isEditingProject, let suggestedProject, !editedProject.isEmpty {
                        let searchTerm = editedProject
                            .replacingOccurrences(of: "+", with: "")
                            .trimmingCharacters(in: .whitespaces)

                        if suggestedProject.lowercased().hasPrefix(searchTerm.lowercased()) {
                            editedProject = suggestedProject
                        }
                    }

                    saveProject()
                    isEditingTitle = false
                }
                .focused($isEditingProject)
                .autocorrectionDisabled()

            if isEditingProject, let suggestedProject, !editedProject.isEmpty {
                let searchTerm = editedProject
                    .replacingOccurrences(of: "+", with: "")
                    .trimmingCharacters(in: .whitespaces)

                if suggestedProject.lowercased().hasPrefix(searchTerm.lowercased()) {
                    HStack(spacing: 0) {
                        Text(editedProject)
                            .font(.system(.caption, design: .monospaced))
                            .foregroundStyle(.clear) // Hiden to align with TextField
                        Text(suggestedProject.dropFirst(searchTerm.count))
                            .font(.system(.caption, design: .monospaced))
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
                .trimmingCharacters(in: .whitespaces)
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

    var suggestedProject: String? {
        let searchTerm = editedProject
            .replacingOccurrences(of: "+", with: "")
            .trimmingCharacters(in: .whitespaces)

        guard !searchTerm.isEmpty else { return allProjects.first }
        return allProjects.first { $0.localizedCaseInsensitiveContains(searchTerm) }
    }

    func tagView(tag: String?) -> some View {
        let tagId = tag ?? ""

        return ZStack(alignment: .leading) {
            TextField(tag == nil ? L10n.addTag : "@\(tag!)", text: Binding(
                get: {
                    focusedTag == tagId ? editedTag : (tag.map { "@\($0)" } ?? "")
                },
                set: { editedTag = $0 }
            ))
            .font(.system(.caption, design: .monospaced))
            .foregroundStyle(theme.tag)
            .textFieldStyle(.plain)
            .onSubmit {
                if focusedTag == tagId, let suggestedTag, !editedTag.isEmpty {
                    let searchTerm = editedTag
                        .replacingOccurrences(of: "@", with: "")
                        .trimmingCharacters(in: .whitespaces)

                    if suggestedTag.lowercased().hasPrefix(searchTerm.lowercased()) {
                        editedTag = suggestedTag
                    }
                }

                saveTag(originalTag: tag)
                focusedTag = nil
            }
            .focused($focusedTag, equals: tagId)
            .autocorrectionDisabled()

            if focusedTag == tagId, let suggestedTag, !editedTag.isEmpty {
                let searchTerm = editedTag
                    .replacingOccurrences(of: "@", with: "")
                    .trimmingCharacters(in: .whitespaces)

                if suggestedTag.lowercased().hasPrefix(searchTerm.lowercased()) {
                    HStack(spacing: 0) {
                        Text(editedTag)
                            .font(.system(.caption, design: .monospaced))
                            .foregroundStyle(.clear)
                        Text(suggestedTag.dropFirst(searchTerm.count))
                            .font(.system(.caption, design: .monospaced))
                            .foregroundStyle(theme.tag.opacity(0.4))
                    }
                    .allowsHitTesting(false)
                }
            }
        }
    }

    func saveTag(originalTag: String?) {
        let cleanedTag = editedTag
            .replacingOccurrences(of: "@", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)

        var updated = todo

        if let orignalTag = originalTag {
            if cleanedTag.isEmpty { // Remove tag
                updated.tags.removeAll { $0 == originalTag }
            } else if cleanedTag != orignalTag,
                        let originalTag,
                        let index = updated.tags.firstIndex(of: originalTag) { // Replace tag
                updated.tags[index] = cleanedTag
            }
        } else if !cleanedTag.isEmpty && !updated.tags.contains(cleanedTag) { // New tag
            updated.tags.append(cleanedTag)
        }

        onUpdate(updated)
        editedTag = ""
    }

    func cancelTagEdit() {
        editedTag = ""
    }

    var suggestedTag: String? {
        let searchTerm = editedTag
            .replacingOccurrences(of: "@", with: "")
            .trimmingCharacters(in: .whitespaces)

        guard !searchTerm.isEmpty else { return allTags.first }
        return allTags
            .filter { !todo.tags.contains($0) }
            .first { $0.localizedCaseInsensitiveContains(searchTerm) }
    }
}

// MARK: Note

private extension TodoRowView {

    @ViewBuilder
    func noteSection() -> some View {
        if todo.note != nil {
            noteTextField()
        }
    }

    @ViewBuilder
    func noteTextField() -> some View{
        TextField(L10n.addNote, text: $editedNote, axis: .vertical)
            .font(.system(.caption, design: .monospaced))
            .textFieldStyle(.plain)
            .foregroundStyle(theme.secondaryText)
            .lineLimit(1...)
            .onSubmit {
                saveNote()
            }
            .focused($isEditingNote)
            .onAppear {
                if showNoteField {
                    isEditingNote = true
                }
            }
    }

    func saveNote() {
        isEditingNote = false
        let cleaned = editedNote.trimmingCharacters(in: .whitespaces)

        var updated = todo
        updated.note = cleaned.isEmpty ? nil : cleaned
        onUpdate(updated)

        showNoteField = false
    }
}

// MARK: Url

private extension TodoRowView {

    @ViewBuilder
    func urlSection() -> some View {
        if todo.url != nil {
            urlTextField()
        }
    }

    @ViewBuilder
    func urlTextField() -> some View {
        HStack(spacing: Spacing.Semantic.elementGap) {
            TextField(L10n.addUrl, text: $editedUrl)
                .font(.system(.caption, design: .monospaced))
                .textFieldStyle(.plain)
                .foregroundStyle(theme.secondaryText)
                .onSubmit {
                    saveUrl()
                }
                .focused($isEditingUrl)
                .onAppear {
                    if showUrlField {
                        isEditingUrl = true
                    }
                }
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()

            if let url = todo.url, !isEditingUrl {
                Button {
                    if let url = URL(string: url) {
                        UIApplication.shared.open(url)
                    }
                } label: {
                    Text(L10n.openUrl)
                        .font(.system(.caption, design: .monospaced))
                        .fontWeight(.medium)
                        .foregroundStyle(theme.buttonText)
                }
                .buttonStyle(.borderedProminent)
                .tint(theme.accentColor)
                .controlSize(.small)
            }

        }
    }

    func saveUrl() {
        isEditingUrl = false
        let cleaned = editedUrl.trimmingCharacters(in: .whitespaces)

        var updated = todo
        updated.url = cleaned.isEmpty ? nil : cleaned
        onUpdate(updated)

        showUrlField = false
    }
}

// MARK: Action Buttons

private extension TodoRowView {

    @ViewBuilder
    func actionButtonSection() -> some View {
        if !todo.isCompleted {
            VStack(alignment: .leading, spacing: Spacing.Semantic.contentPadding) {

                if todo.due == nil {
                    if showDuePicker {
                        dueDatePicker()
                    } else if !showNoteField && !showUrlField {
                        Button {
                            editedDue = Date()
                            showDuePicker = true
                        } label: {
                            Text(L10n.addDue)
                                .font(.system(.caption, design: .monospaced))
                                .foregroundStyle(theme.accentColor)
                        }
                        .buttonStyle(.plain)
                        .controlSize(.small)
                    }
                }

                if todo.note == nil {
                    if showNoteField {
                        noteTextField()
                    } else if !showUrlField && !showDuePicker {
                        Button {
                            editedNote = ""
                            showNoteField = true
                        } label: {
                            Text(L10n.addNote)
                                .font(.system(.caption, design: .monospaced))
                                .foregroundStyle(theme.accentColor)
                        }
                        .buttonStyle(.plain)
                        .controlSize(.small)
                    }
                }

                if todo.url == nil {
                    if showUrlField {
                        urlTextField()
                    } else if !showNoteField && !showDuePicker {
                        Button {
                            editedUrl = ""
                            showUrlField = true
                        } label: {
                            Text(L10n.addUrl)
                                .font(.system(.caption, design: .monospaced))
                                .foregroundStyle(theme.accentColor)
                        }
                        .buttonStyle(.plain)
                        .controlSize(.small)
                    }
                }
            }
        }
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
            due: Date(),
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
    .preferredColorScheme(.dark)
}
