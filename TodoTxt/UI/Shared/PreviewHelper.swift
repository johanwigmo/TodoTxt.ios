//
//  PreviewHelper.swift
//  TodoTxt
//
//  Created by Johan Wigmo on 2025-10-14.
//

import SwiftUI

#if DEBUG

struct PreviewBackground<Content: View>: View {
    let theme: Theme
    let content: Content

    init(theme: Theme = CatppuccinTheme(), @ViewBuilder content: () -> Content) {
        self.theme = theme
        self.content = content()
    }

    var body: some View {
        ZStack {
            theme.primaryBackground
                .ignoresSafeArea()

            content
        }
        .theme(theme)
    }
}

extension View {
    func previewBackground(theme: Theme = CatppuccinTheme()) -> some View {
        PreviewBackground(theme: theme) {
            self
        }
    }
}

#endif
