//
//  ButtonStyleModifiers.swift
//  TodoTxt
//
//  Created by Johan Wigmo on 2025-11-01.
//

import SwiftUI

struct ActionButtonStyle: ViewModifier {
    @Environment(\.theme) private var theme

    func body(content: Content) -> some View {
        content
            .font(.system(.caption, design: .monospaced))
            .fontWeight(.medium)
            .foregroundStyle(theme.buttonText)
            .buttonStyle(.borderedProminent)
            .tint(theme.accentColor)
            .controlSize(.small)
    }
}

struct PlainActionButtonStyle: ViewModifier {
    @Environment(\.theme) private var theme

    func body(content: Content) -> some View {
        content
            .font(.system(.caption, design: .monospaced))
            .foregroundStyle(theme.accentColor)
            .buttonStyle(.plain)
            .controlSize(.small)
    }
}

struct DestructiveButtonStyle: ViewModifier {
    @Environment(\.theme) private var theme

    func body(content: Content) -> some View {
        content
            .font(.system(.caption, design: .monospaced))
            .fontWeight(.medium)
            .foregroundStyle(theme.buttonText)
            .buttonStyle(.borderedProminent)
            .tint(theme.warning)
            .controlSize(.small)
    }
}

extension View {

    func actionButton() -> some View {
        modifier(ActionButtonStyle())
    }

    func plainActionButton() -> some View {
        modifier(PlainActionButtonStyle())
    }

    func destructiveButton() -> some View {
        modifier(DestructiveButtonStyle())
    }
}
