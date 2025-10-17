//
//  Theme.swift
//  TodoTxt
//
//  Created by Johan Wigmo on 2025-10-13.
//

import SwiftUI

protocol Theme {

    var primaryBackground: Color { get }
    // Todo items
    var priority: Color { get }
    var project: Color { get }
    var tag: Color { get }
    var completed: Color { get }
    var url: Color { get }

    // UI elements
    var todoBackground: Color { get }
    var elevatedBackground: Color { get }
    var subtleBorder: Color { get }
    var accentBorder: Color { get }
    var shadowColor: Color { get }

    // Text
    var primaryText: Color { get }
    var secondaryText: Color { get }
    var heading: Color { get }

    // Interactive
    var accentColor: Color { get }
    var buttonBackground: Color { get }
    var buttonText: Color { get }
}

private struct ThemeKey: EnvironmentKey {
    static let defaultValue: Theme = CatppuccinTheme()
}

extension EnvironmentValues {
    var theme: Theme {
        get { self[ThemeKey.self] }
        set { self[ThemeKey.self] = newValue }
    }
}

extension View {
    func theme(_ theme: Theme) -> some View {
        environment(\.theme, theme)
    }
}
