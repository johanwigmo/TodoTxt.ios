//
//  CatppuccinTheme.swift
//  TodoTxt
//
//  Created by Johan Wigmo on 2025-10-13.
//

import SwiftUI

struct CatppuccinTheme: Theme {

    var primaryBackground: Color { Color("Catppuccin/Base") }

    var priority: Color { Color("Catppuccin/Mauve") }
    var project: Color { Color("Catppuccin/Green") }
    var tag: Color { Color("Catppuccin/Yellow") }
    var completed: Color { Color("Catppuccin/Green") }
    var url: Color { Color("Catppuccin/Mauve") }

    var noteBackground: Color { Color("Catppuccin/Surface0") }
    var urlBackground: Color { Color("Catppuccin/Surface1") }
    var activeBorder: Color { Color("Catppuccin/Lavender") }
    var inactiveBorder: Color { Color("Catppuccin/Overlay0") }

    var primaryText: Color { Color("Catppuccin/Text") }
    var secondaryText: Color { Color("Catppuccin/Subtext1") }
    var heading: Color { Color("Catppuccin/Text") }

    var accentColor: Color { Color("Catppuccin/Blue") }
    var buttonText: Color { Color("Catppuccin/Base") }

    var warning: Color { Color("Catppuccin/Red") }
}
