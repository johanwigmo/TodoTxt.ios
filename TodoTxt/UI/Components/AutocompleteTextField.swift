//
//  AutocompleteTextField.swift
//  TodoTxt
//
//  Created by Johan Wigmo on 2025-11-01.
//

import SwiftUI

struct AutocompleteTextField: View {

    let placeholder: String
    @Binding var text: String
    let suggestion: String?
    let font: Font
    let color: Color
    let onSubmit: () -> Void

    @FocusState.Binding var isFocused: Bool

    init(
        placeholder: String,
        text: Binding<String>,
        suggestion: String?,
        font: Font = .system(.caption, design: .monospaced),
        color: Color,
        isFocused: FocusState<Bool>.Binding,
        onSubmit: @escaping () -> Void
    ) {
        self.placeholder = placeholder
        self._text = text
        self.suggestion = suggestion
        self.font = font
        self.color = color
        self._isFocused = isFocused
        self.onSubmit = onSubmit
    }

    var body: some View {
        ZStack(alignment: .leading) {
            TextField(placeholder, text: $text)
                .font(font)
                .foregroundStyle(color)
                .plainTextField()
                .focused($isFocused)
                .onSubmit(onSubmit)

            if isFocused, let suggestion, !text.isEmpty {
                let completion = AutocompleteSuggester.completionText(for: text, suggestion: suggestion)

                if !completion.isEmpty {
                    HStack(spacing: 0) {
                        Text(text).font(font).foregroundStyle(.clear)
                        Text(completion).font(font).foregroundStyle(color.opacity(0.4))
                    }
                    .allowsHitTesting(false)
                }
            }
        }
    }
}
