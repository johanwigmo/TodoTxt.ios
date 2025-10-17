//
//  HeaderRowView.swift
//  TodoTxt
//
//  Created by Johan Wigmo on 2025-10-15.
//

import SwiftUI

struct HeaderRowView: View {

    let header: Header
    @Environment(\.theme) private var theme

    var body: some View {
        Text("# \(header.title)")
            .font(.system(.title2, design: .monospaced))
            .fontWeight(.semibold)
            .foregroundStyle(theme.heading)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, Spacing.Semantic.rowInternalSpacing)
    }
}

#Preview {
    HeaderRowView(header: Header(title: "Shopping"))
        .previewBackground()
}
