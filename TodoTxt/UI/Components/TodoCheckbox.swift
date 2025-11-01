//
//  TodoCheckbox.swift
//  TodoTxt
//
//  Created by Johan Wigmo on 2025-11-01.
//

import SwiftUI

struct TodoCheckbox: View {

    let isCompleted: Bool
    let action: () -> Void

    @Environment(\.theme) private var theme

    var body: some View {
        Button(action: action) {
            Image(systemName: isCompleted ? "checkmark.square.fill" : "square")
                .font(.title2)
                .foregroundStyle(isCompleted ? theme.completed : theme.secondaryText)
                .frame(width: IconSize.l, height: IconSize.l)
                .padding(.vertical, -Spacing.xxs)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    VStack(spacing: Spacing.m) {
        TodoCheckbox(isCompleted: false, action: {})
        TodoCheckbox(isCompleted: true, action: {})
    }
    .padding()
    .previewBackground()
}
