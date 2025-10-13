//
//  CatppuccinTheme.swift
//  TodoTxt
//
//  Created by Johan Wigmo on 2025-10-13.
//

import SwiftUI

struct CatppuccinTheme: Theme {
    var priority: Color { Color("Catppuccin/Red")}
    var project: Color { Color("Catppuccin/Blue")}
    var tag: Color { Color("Catppuccin/Yellow")}
    var completed: Color { Color("Catppuccin/Green")}
    var url: Color { Color("Catppuccin/Mauve")}
    var todoBackground: Color { Color("Catppuccin/Surface0")}
    var elevatedBackground: Color { Color("Catppuccin/Surface1")}
    var subtleBorder: Color { Color("Catppuccin/Overlay0")}
    var accentBorder: Color { Color("Catppuccin/Overlay1")}
    var shadowColor: Color { Color("Catppuccin/Crust")}
}
