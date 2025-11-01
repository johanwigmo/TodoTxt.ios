//
//  ListRowModifiers.swift
//  TodoTxt
//
//  Created by Johan Wigmo on 2025-11-01.
//

import SwiftUI

struct TodoListRowStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .listRowInsets(.vertical, Spacing.Semantic.stackSpacing)
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
    }
}

struct HeaderListRowStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .listRowInsets(.vertical, Spacing.Semantic.stackSpacing)
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
    }
}

extension View {

    func todoListRow() -> some View {
        modifier(TodoListRowStyle())
    }

    func headerListRow() -> some View {
        modifier(HeaderListRowStyle())
    }
}
