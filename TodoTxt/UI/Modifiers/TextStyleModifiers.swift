//
//  TextStyleModifiers.swift
//  TodoTxt
//
//  Created by Johan Wigmo on 2025-11-01.
//

import SwiftUI

struct MonospacedCaptionStyle: ViewModifier {
    @Environment(\.theme) private var theme
    let color: Color?

    init(color: Color? = nil){
        self.color = color
    }

    func body(content: Content) -> some View {
        content
            .font(.system(.caption, design: .monospaced))
            .foregroundStyle(color ?? theme.secondaryText)
    }
}

struct MonospacedBodyStyle: ViewModifier {
    @Environment(\.theme) private var theme
    let color: Color?

    init(color: Color? = nil){
        self.color = color
    }

    func body(content: Content) -> some View {
        content
            .font(.system(.body, design: .monospaced))
            .foregroundStyle(color ?? theme.primaryText)
    }
}

extension View {

    func monospacedCaption(color: Color? = nil) -> some View {
        self.modifier(MonospacedCaptionStyle(color: color))
    }

    func monospacedBody(color: Color? = nil) -> some View {
        self.modifier(MonospacedBodyStyle(color: color))
    }
}
