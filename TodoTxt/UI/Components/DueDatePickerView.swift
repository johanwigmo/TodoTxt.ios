//
//  DueDatePickerView.swift
//  TodoTxt
//
//  Created by Johan Wigmo on 2025-11-01.
//

import SwiftUI

struct DueDatePickerView: View {

    @Binding var date: Date
    let onSave: () -> Void
    let onRemove: () -> Void

    @Environment(\.theme) private var theme

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.Semantic.inlineGap) {
            DatePicker("", selection: $date, displayedComponents: [.date])
                .datePickerStyle(.graphical)
                .labelsHidden()
                .tint(theme.accentColor)

            HStack {
                Button(L10n.removeDue, action: onRemove)
                    .destructiveButton()

                Spacer()

                Button(L10n.setDue, action: onSave)
                    .actionButton()
            }
            .padding(.bottom, Spacing.Semantic.inlineGap)
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }
}

#Preview {
    DueDatePickerView(
        date: .constant(Date()),
        onSave: {},
        onRemove: {}
    )
    .padding()
    .previewBackground()
}
