//
//  TagChipList.swift
//  TodoTxt
//
//  Created by Johan Wigmo on 2025-11-01.
//

import SwiftUI

struct TagChipList: View {

    @Binding var tags: [String]
    @Binding var inputTag: String
    let allTags: [String]
    @FocusState.Binding var isFocused: Bool

    @Environment(\.theme) private var theme

    private var cleanedTag: String {
        inputTag
            .replacingOccurrences(of: "@", with: "")
            .trimmingCharacters(in: .whitespaces)
    }

    private var suggestedTag: String? {
        AutocompleteSuggester.suggest(for: cleanedTag, from: allTags, excluding: tags)
    }

    var body: some View {
        FlowLayout(spacing: Spacing.Semantic.inlineGap) {
            ForEach(tags, id: \.self) {tag in
                tagChip(tag)
            }

            tagInputField()
        }
    }

    private func tagChip(_ tag: String) -> some View {
        Button {
            tags.removeAll { $0 == tag }
        } label: {
            HStack(spacing: Spacing.xxs) {
                Text(tag).foregroundStyle(theme.primaryText)
                Image(systemName: "xmark.circle.fill")
                    .font(.body)
                    .foregroundStyle(theme.warning)
            }
        }
    }

    private func tagInputField() -> some View {
        AutocompleteTextField(
            placeholder: L10n.placeholderTags,
            text: $inputTag,
            suggestion: suggestedTag,
            font: .body,
            color: theme.primaryText,
            isFocused: $isFocused,
            onSubmit: submitTag
        )
    }

    private func submitTag() {
        let cleaned = inputTag.trimmingCharacters(in: .whitespacesAndNewlines)

        if let suggestedTag {
            let completion = AutocompleteSuggester.completionText(for: cleaned, suggestion: suggestedTag)

            if !completion.isEmpty && !tags.contains(suggestedTag) {
                tags.append(suggestedTag)
            }
        } else if !cleaned.isEmpty && !tags.contains(cleaned) {
            tags.append(cleaned)
        }

        inputTag = ""
    }
}
