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
    var noteBackground: Color { get }
    var urlBackground: Color { get }
    var activeBorder: Color { get }
    var inactiveBorder: Color { get }

    // Text
    var primaryText: Color { get }
    var secondaryText: Color { get }
    var heading: Color { get }

    // Interactive
    var accentColor: Color { get }
    var buttonText: Color { get }

    // Misc
    var warning: Color { get }
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
