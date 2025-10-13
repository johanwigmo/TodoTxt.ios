//
//  ThemeManager.swift
//  TodoTxt
//
//  Created by Johan Wigmo on 2025-10-13.
//

import SwiftUI

@Observable
class ThemeManager {
    static let shared = ThemeManager()

    var current: Theme = CatppuccinTheme()

    private init() {}

    func setTheme(_ theme: Theme) {
        current = theme
    }
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

extension Color {
    static func themed(_ keyPath: KeyPath<Theme, Color>) -> Color {
        return ThemeManager.shared.current[keyPath: keyPath]
    }
}
