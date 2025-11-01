//
//  ProjectField.swift
//  TodoTxt
//
//  Created by Johan Wigmo on 2025-11-01.
//

import SwiftUI

struct ProjectField: View {

    @Binding var project: String
    let allProjects: [String]
    @FocusState.Binding var isFocused: Bool
    var font: Font? = nil
    var color: Color? = nil

    @Environment(\.theme) private var theme

    private var cleanedProject: String {
        project
            .replacingOccurrences(of: "+", with: "")
            .trimmingCharacters(in: .whitespaces)
    }

    private var suggestedProject: String? {
        AutocompleteSuggester.suggest(for: cleanedProject, from: allProjects)
    }

    var body: some View {
        AutocompleteTextField(
            placeholder: project.isEmpty ? L10n.placeholderProject : "",
            text: $project,
            suggestion: suggestedProject,
            font: font ?? .system(.caption, design: .monospaced),
            color: color ?? theme.project,
            isFocused: $isFocused,
            onSubmit: applyAutocompletion
        )
    }

    private func applyAutocompletion() {
        if let suggestedProject, !project.isEmpty {
            let completion = AutocompleteSuggester.completionText(for: project, suggestion: suggestedProject)
            
            if !completion.isEmpty {
                project = suggestedProject
            }
        }
    }
}
