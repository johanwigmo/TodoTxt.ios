//
//  TodoRowView.swift
//  TodoTxt
//
//  Created by Johan Wigmo on 2025-10-15.
//

import SwiftUI

struct BaseTodoRowView: View {

    let todo: Todo
    let isExpanded: Bool
    let onTap: () -> Void
    @Environment(\.theme) private var theme

    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top, spacing: Spacing.Semantic.rowInternalSpacing){
                checkbox()
                VStack(alignment: .leading) {
                    priorityAndTitle()
                    projectAndTags()
                    url()
                        .padding(.top, Spacing.Semantic.itemSpacing)
                    note()
                        .padding(.top, Spacing.Semantic.rowInternalSpacing)
                    metaButtons()
                        .padding(.top, Spacing.Semantic.rowInternalSpacing)
                }
            }
        }
        .onTapGesture(perform: onTap)
    }

    @ViewBuilder
    private func checkbox() -> some View {
        Button {

        } label: {
            Image(systemName: todo.isCompleted ? "checkmark.square.fill" : "square")
                .font(.title2)
                .foregroundStyle(todo.isCompleted ? theme.completed : theme.secondaryText)
                .frame(width: IconSize.l, height: IconSize.l)
                .padding(.vertical, -Spacing.xxs)
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private func priorityAndTitle() -> some View {
        var priority: AttributedString {
            if let priority = todo.priority {
                var text = AttributedString("(\(priority.rawValue)) ")
                text.font = .system(.body, design: .monospaced).bold()
                text.foregroundColor = theme.priority
                return text
            } else {
                return ""
            }
        }

        var title: AttributedString {
            var text = AttributedString(todo.title)
            text.font = .system(.body, design: .monospaced)
            text.foregroundColor = todo.isCompleted ? theme.secondaryText : theme.primaryText
            text.strikethroughStyle = todo.isCompleted ? .single : .none
            return text
        }

        Text(priority + title)
    }

    @ViewBuilder
    private func projectAndTags() -> some View {
        FlowLayout(spacing: Spacing.Semantic.elementGap) {
            if let project = todo.project {
                Text("+\(project)")
                    .font(.system(.subheadline, design: .monospaced))
                    .foregroundStyle(theme.project)
            } else {
                Button {
                    // TODO: Add project
                } label: {
                    Text(L10n.addProject)
                        .font(.system(.subheadline, design: .monospaced))
                        .foregroundStyle(theme.secondaryText)
                }
            }

            ForEach(todo.tags, id: \.self) { tag in
                Text("@\(tag)")
                    .font(.system(.subheadline, design: .monospaced))
                    .foregroundStyle(theme.tag)
            }

            Button {
                // TODO: Add tag
            } label: {
                Text(L10n.addTag)
                    .font(.system(.subheadline, design: .monospaced))
                    .foregroundStyle(theme.secondaryText)
            }
        }
    }

    @ViewBuilder
    private func url() -> some View {
        if let url = todo.url, isExpanded {
            HStack(spacing: Spacing.Semantic.elementGap) {
                Text(url)
                    .font(.system(.subheadline, design: .monospaced))
                    .foregroundStyle(theme.url)
                    .lineLimit(1)
                    .truncationMode(.middle)

                Spacer()

                Button {
                    // TODO: Open url
                } label: {
                    Text(L10n.openUrl)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(theme.buttonText)
                }
                .buttonStyle(.borderedProminent)
                .tint(theme.url)
                .controlSize(.small)
            }
            .padding(Spacing.Semantic.contentPadding)
            .background(theme.elevatedBackground)
            .containerShape(.rect(cornerRadius: CornerRadius.s))
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.s)
                    .stroke(theme.subtleBorder.opacity(0.3), lineWidth: BorderWidth.thin)
            )
            .fixedSize(horizontal: false, vertical: true)
        }
    }

    @ViewBuilder
    private func note() -> some View {
        if let note = todo.note, isExpanded {
            Text(note)
                .font(.system(.subheadline, design: .monospaced))
                .italic()
                .foregroundStyle(theme.secondaryText)
                .padding(Spacing.Semantic.contentPadding)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(theme.todoBackground)
                .clipShape(RoundedRectangle(cornerRadius: CornerRadius.s))
                .overlay(
                    RoundedRectangle(cornerRadius: CornerRadius.s)
                        .stroke(theme.accentBorder.opacity(0.3), lineWidth: BorderWidth.thin)
                )
        }
    }

    @ViewBuilder
    private func metaButtons() -> some View {
        if isExpanded && !todo.isCompleted {
            HStack(spacing: Spacing.Semantic.itemSpacing) {
                if todo.url == nil {
                    Button {
                        // TODO: Add URL
                    } label: {
                        Label(L10n.addUrl, systemImage: "plus")
                            .font(.subheadline)
                            .foregroundStyle(theme.accentColor)
                            .padding(.horizontal, Spacing.Semantic.elementGap)
                    }
                    .buttonStyle(DashedButtonStyle())
                }

                if todo.note == nil {
                    Button {
                        // TODO: Add Note
                    } label: {
                        Label(L10n.addNote, systemImage: "plus")
                            .font(.subheadline)
                            .foregroundStyle(theme.accentColor)
                            .padding(.horizontal, Spacing.Semantic.elementGap)
                    }
                    .buttonStyle(DashedButtonStyle())
                }
            }
        }
    }
}

#Preview("Collapsed") {
    List(SampleDataLoader.sampleTodos) { todo in
        BaseTodoRowView(todo: todo, isExpanded: false, onTap: {})
    }
    .previewBackground()
    .listStyle(.plain)
}

#Preview("Expanded") {
    List(SampleDataLoader.sampleTodos) { todo in
        BaseTodoRowView(todo: todo, isExpanded: true, onTap: {})
    }
    .previewBackground()
    .listStyle(.plain)
}
