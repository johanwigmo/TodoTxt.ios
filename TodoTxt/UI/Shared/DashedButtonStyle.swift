//
//  DashedButtonStyle.swift
//  TodoTxt
//
//  Created by Johan Wigmo on 2025-10-15.
//

import SwiftUI

struct DashedButtonStyle: ButtonStyle {

    @Environment(\.theme) private var theme

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(Spacing.xxs)
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.s)
                    .stroke(style: StrokeStyle(lineWidth: BorderWidth.thin, dash: [6]))
            )
            .foregroundStyle(theme.accentColor)
            .controlSize(.small)
            .opacity(configuration.isPressed ? 0.6 : 1)
    }
}
