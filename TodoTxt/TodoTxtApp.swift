//
//  TodoTxtApp.swift
//  TodoTxt
//
//  Created by Johan Wigmo on 2025-09-27.
//

import SwiftUI

@main
struct TodoTxtApp: App {
    var body: some Scene {
        WindowGroup {
            TodoListScreen(repository: SampleDataLoader.createSampleRepository())
                .theme(CatppuccinTheme())
        }
    }
}
