//
//  Theme.swift
//  TodoTxt
//
//  Created by Johan Wigmo on 2025-10-13.
//

import SwiftUI

protocol Theme {
    var priority: Color { get }
    var project: Color { get }
    var tag: Color { get }
    var completed: Color { get }
    var url: Color { get }
    var todoBackground: Color { get }
    var elevatedBackground: Color { get }
    var subtleBorder: Color { get }
    var accentBorder: Color { get }
    var shadowColor: Color { get }
}
