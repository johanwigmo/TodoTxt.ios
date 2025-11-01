//
//  TextFieldModifiers.swift
//  TodoTxt
//
//  Created by Johan Wigmo on 2025-11-01.
//

import SwiftUI

struct PlainTextFieldStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .textFieldStyle(.plain)
            .autocorrectionDisabled()
    }
}

struct URLTextFieldStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .textFieldStyle(.plain)
            .keyboardType(.URL)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
    }
}

extension View {

    func plainTextField() -> some View {
        modifier(PlainTextFieldStyle())
    }

    func urlTextField() -> some View {
        modifier(URLTextFieldStyle())
    }
}
