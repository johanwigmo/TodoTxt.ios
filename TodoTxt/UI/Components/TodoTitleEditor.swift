//
//  TodoTitleEditor.swift
//  TodoTxt
//
//  Created by Johan Wigmo on 2025-11-01.
//

import SwiftUI

struct TodoTitleEditor: View {

    let title: String
    let priority: TodoPriority?
    let isCompleted: Bool
    @Binding var editedTitle: String
    @Binding var isEditing: Bool
    @FocusState.Binding var isFocused: Bool

    let onSave: () -> Void
    let onDelete: () -> Void

    @Environment(\.theme) private var theme
    @State private var showDeleteAlert = false

    var body: some View {
        VStack {
            if isEditing {
                TextField(L10n.placeholderTitle, text: $editedTitle, axis: .vertical)
                    .monospacedBody()
                    .plainTextField()
                    .lineLimit(1...)
                    .focused($isFocused)
                    .onSubmit(handleSave)
                    .onAppear {
                        editedTitle = priorityAndTitleCombined
                        isFocused = true
                    }
            } else {
                Text(styledTitle)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .onTapGesture {
                        isEditing = true 
                    }
            }
        }
        .alert(L10n.deleteItem, isPresented: $showDeleteAlert) {
            Button(L10n.delete, role: .destructive, action: onDelete)
            Button(L10n.cancel, role: .cancel) {
                editedTitle = priorityAndTitleCombined
                isFocused = true
            }
        } message: {
            Text(L10n.deleteTodoDescription)
        }
    }

    private var priorityAndTitleCombined: String {
        let priorityPrefix = priority.map { "(\($0.rawValue)) " } ?? ""
        return "\(priorityPrefix)\(title)"
    }

    private var styledTitle: AttributedString {
        var result = AttributedString()

        if let priority {
            var priorityText = AttributedString("(\(priority.rawValue)) ")
            priorityText.font = .system(.body, design: .monospaced).bold()
            priorityText.foregroundColor = theme.priority

            result.append(priorityText)
        }

        var titleText = AttributedString(title)
        titleText.font = .system(.body, design: .monospaced)
        titleText.foregroundColor = isCompleted ? theme.secondaryText : theme.primaryText

        if isCompleted {
            titleText.strikethroughStyle = .single
        }

        result.append(titleText)
        return result
    }

    private func handleSave() {
        let trimmed = editedTitle.trimmingCharacters(in: .whitespacesAndNewlines)

        if trimmed.isEmpty {
            showDeleteAlert = true
            return
        }

        onSave()
    }
}

#Preview {
    VStack(spacing: Spacing.l) {
        TodoTitleEditor(
            title: "Buy groceries",
            priority: .A,
            isCompleted: false,
            editedTitle: .constant(""),
            isEditing: .constant(false),
            isFocused: FocusState<Bool>().projectedValue,
            onSave: {},
            onDelete: {}
        )

        TodoTitleEditor(
            title: "Review budget",
            priority: .A,
            isCompleted: true,
            editedTitle: .constant(""),
            isEditing: .constant(false),
            isFocused: FocusState<Bool>().projectedValue,
            onSave: {},
            onDelete: {}
        )
    }
    .padding()
    .previewBackground()
}
