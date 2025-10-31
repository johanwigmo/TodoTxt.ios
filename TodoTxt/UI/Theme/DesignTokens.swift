//
//  DesignTokens.swift
//  TodoTxt
//
//  Created by Johan Wigmo on 2025-10-14.
//

import SwiftUI

enum Spacing {
    static let xxs: CGFloat = 4
    static let xs: CGFloat = 8
    static let s: CGFloat = 12
    static let m: CGFloat = 16
    static let l: CGFloat = 24
    static let xl: CGFloat = 32
    static let xxl: CGFloat = 48

    enum Semantic {
        static let elementGap: CGFloat = Spacing.xs
        static let itemSpacing: CGFloat = Spacing.s
        static let contentPadding: CGFloat = Spacing.m
        static let sectionSpacin: CGFloat = Spacing.l
        
        static let rowInternalSpacing: CGFloat = Spacing.xs
    }
}

enum IconSize {
    static let s: CGFloat = 16
    static let m: CGFloat = 24
    static let l: CGFloat = 28
    static let xl: CGFloat = 64
}

enum CornerRadius {
    static let s: CGFloat = 6
    static let m: CGFloat = 12
}

enum BorderWidth {
    static let thin: CGFloat = 1
    static let medium: CGFloat = 2
    static let thick: CGFloat = 3
}

enum Layout {
    static let toolbarHeight: CGFloat = 60
    static let bottomContentPadding: CGFloat = 80
}

extension View {

    func contentPadding() -> some View {
        self.padding(Spacing.Semantic.contentPadding)
    }
}
