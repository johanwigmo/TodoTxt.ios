//
//  HeaderRowView.swift
//  TodoTxt
//
//  Created by Johan Wigmo on 2025-10-15.
//

import SwiftUI

struct HeaderRowView: View {

    let header: Header
    let onUpdate: (Header?) -> Void

    @Environment(\.theme) private var theme

    @State private var editedHeader: String = ""
    @State private var showDeleteAlert: Bool = false
    @FocusState private var focusTextField: Bool

    var body: some View {
        TextField(L10n.placeHolderHeader, text: $editedHeader)
            .font(.system(.title, design: .monospaced))
            .fontWeight(.semibold)
            .foregroundStyle(theme.heading)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, Spacing.Semantic.itemSpacing)
            .focused($focusTextField)
            .id(header.id)
            .onSubmit {
                saveHeader()
            }
            .alert(L10n.deleteItem, isPresented: $showDeleteAlert) {
                Button(L10n.delete, role: .destructive) {
                    onUpdate(nil)
                }
                Button(L10n.cancel, role: .cancel) {
                    focusTextField = true
                }
            } message: {
                Text(L10n.deleteHeaderDescription)
            }
            .onAppear {
                editedHeader = "# \(header.title)"
            }
    }

    private func saveHeader() {
        if !editedHeader.isEmpty {
            let cleaned = editedHeader
                .replacingOccurrences(of: "#", with: "")
                .trimmingCharacters(in: .whitespaces)
            var updated = header
            updated.title = cleaned
            onUpdate(updated)
            editedHeader = "# \(cleaned)"
        } else {
            showDeleteAlert = true
        }
    }
}

#Preview {
    HeaderRowView(header: Header(title: "Shopping"), onUpdate: { _ in })
        .previewBackground()
}
