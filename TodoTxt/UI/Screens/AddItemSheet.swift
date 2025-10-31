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
                    todoDetailsSection()
                    todoNoteSection()
                }
            }
            .scrollContentBackground(.hidden)
            .background(theme.primaryBackground)
            .navigationTitle(selectedType == .todo ? L10n.addTodo : L10n.addHeader)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(L10n.cancel) {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button(L10n.add) {
                        addItem()
                    }
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
            HStack(spacing: Spacing.Semantic.itemSpacing) {
                TypeSelectorButton(
                    type: .todo,
                    isSelected: selectedType == .todo,
                    colors: TypeSelectorButton.Colors(
                        accent: theme.accentColor,
                        active: theme.buttonText,
                        inactive: theme.primaryText
                    ),
                    action: { selectedType = .todo }
                )

                TypeSelectorButton(
                    type: .header,
                    isSelected: selectedType == .header,
                    colors: TypeSelectorButton.Colors(
                        accent: theme.accentColor,
                        active: theme.buttonText,
                        inactive: theme.primaryText
                    ),
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
                    let result = TodoTextParser.extractPriority(from: newValue)
                    priority = result.priority
                }

            if let detectedPriority = priority, selectedType == .todo {
                HStack {
                    Text("\(L10n.priority): \(detectedPriority.rawValue)")
                        .font(.caption)
                        .foregroundStyle(theme.secondaryText)
                    Spacer()
                    Button(L10n.clear) {
                        priority = nil
                    }
                    .font(.caption)
                }
            }
        }
        .listRowBackground(theme.noteBackground)
    }

    func todoDetailsSection() -> some View {

        Section(L10n.details) {
            projectView()
            tagsView()
            dueDateView()
            urlView()
        }
        .listRowBackground(theme.noteBackground)
    }

    func todoNoteSection() -> some View {
        Section(L10n.note) {
            TextField(L10n.placeholderNote, text: $note, axis: .vertical)
                .foregroundStyle(theme.primaryText)
                .textFieldStyle(.plain)
                .lineLimit(1...)
        }
        .listRowBackground(theme.noteBackground)
    }

    func projectView() -> some View {
        ZStack(alignment: .leading) {
            TextField(L10n.placeholderProject, text: $project)
                .foregroundStyle(theme.primaryText)
                .focused($isProjectFocused)
                .autocorrectionDisabled()
                .onSubmit {
                    if let suggestedProject {
                        let completion = AutocompleteSuggester.completionText(for: project, suggestion: suggestedProject)
                        if !completion.isEmpty {
                            project = suggestedProject
                        }
                    }
                    isProjectFocused = false
                }

            if isProjectFocused, let suggestedProject, !project.isEmpty {
                let completion = AutocompleteSuggester.completionText(for: project, suggestion: suggestedProject)
                if !completion.isEmpty {
                    HStack(spacing: 0) {
                        Text(project).foregroundStyle(.clear)
                        Text(completion).foregroundStyle(theme.secondaryText)
                    }
                    .allowsHitTesting(false)
                }

            }
        }
    }

    func tagsView() -> some View {
        VStack(alignment: .leading, spacing: Spacing.Semantic.elementGap) {
            FlowLayout(spacing: Spacing.Semantic.elementGap) {
                ForEach(tags, id: \.self) { tag in
                    Button {
                        tags.removeAll() { $0 == tag }
                    } label: {
                        HStack(spacing: Spacing.xxs) {
                            Text(tag).foregroundStyle(theme.primaryText)
                            Image(systemName: "xmark.circle.fill")
                                .font(.caption)
                                .foregroundStyle(theme.warning)
                        }
                    }
                }

                ZStack(alignment: .leading) {
                    TextField(L10n.placeholderTags, text: $tag)
                        .foregroundStyle(theme.primaryText)
                        .focused($isTagFocused)
                        .autocorrectionDisabled()
                        .onSubmit {
                            submitTag()
                        }

                    if isTagFocused, let suggestedTag, !tag.isEmpty {
                        let completion = AutocompleteSuggester.completionText(for: tag, suggestion: suggestedTag)
                        if !completion.isEmpty {
                            HStack(spacing: 0) {
                                Text(tag).foregroundStyle(.clear)
                                Text(completion).foregroundStyle(theme.secondaryText)
                            }
                            .allowsHitTesting(false)
                        }

                    }

                }
            }
        }
    }

    @ViewBuilder
    func dueDateView() -> some View {
        Toggle(L10n.placeholderDueDate, isOn: $showDueDatePicker)

        if showDueDatePicker {
            DatePicker("", selection: Binding(
                get: { dueDate ?? Date() },
                set: { dueDate = $0 }
            ), displayedComponents: .date)
            .datePickerStyle(.graphical)
        }
    }

    func urlView() -> some View {
        TextField(L10n.addUrl, text: $url)
            .focused($isUrlFocused)
            .keyboardType(.URL)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
    }
}

extension AddItemSheet {

    var suggestedProject: String? {
        AutocompleteSuggester.suggest(for: project, from: allProjects)
    }

    var suggestedTag: String? {
        AutocompleteSuggester.suggest(for: tag, from: allTags, excluding: tags)
    }

    func submitTag() {
        let cleaned = tag.trimmingCharacters(in: .whitespacesAndNewlines)

        if let suggestedTag {
            let completion = AutocompleteSuggester.completionText(for: cleaned, suggestion: suggestedTag)
            if !completion.isEmpty && !tags.contains(suggestedTag) {
                tags.append(suggestedTag)
            }
        } else if !cleaned.isEmpty && !tags.contains(cleaned) {
            tags.append(cleaned)
        }

        tag = ""
    }

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

// compiler didn't like `.buttonStyle(ifSelected ? .borderedProminent : .bordered)`
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
                    .padding(.vertical, Spacing.Semantic.itemSpacing)
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
                    .padding(.vertical, Spacing.Semantic.itemSpacing)
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

