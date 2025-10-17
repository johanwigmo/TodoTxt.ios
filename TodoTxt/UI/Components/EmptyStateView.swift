//
//  EmptyStateView.swift
//  TodoTxt
//
//  Created by Johan Wigmo on 2025-10-14.
//

import SwiftUI

struct EmptyStateView: View {

    let onLoadFile: () -> Void
    @Environment(\.theme) private var theme

    var body: some View {
        VStack(spacing: Spacing.l) {
            Image(systemName: "text.document")
                .font(.system(size: IconSize.xl))
                .foregroundStyle(theme.secondaryText)

            Text(L10n.emptyStateTitle)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(theme.primaryText)

            Text(L10n.emptyStateDescription)
                .font(.subheadline)
                .foregroundStyle(theme.secondaryText)

            Button {
                onLoadFile()
            } label: {
                Label(L10n.loadFile, systemImage: "folder")
                    .font(.headline)
                    .foregroundStyle(theme.buttonText)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(theme.accentColor)
            .controlSize(.large)
            .padding(.horizontal, 40)
            .padding(.top, Spacing.xs)
        }
        .padding()
    }
}

#Preview {
    EmptyStateView(onLoadFile: {})
        .previewBackground()
}
