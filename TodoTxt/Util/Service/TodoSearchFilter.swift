//
//  TodoSearchFilter.swift
//  TodoTxt
//
//  Created by Johan Wigmo on 2025-10-29.
//

import Foundation

struct TodoSearchFilter {

    static func filter(items: [any Item], searchText: String) -> [any Item] {
        let trimmedSearch = searchText.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedSearch.isEmpty else {
            return items
        }

        let lowercasedSearch = trimmedSearch.lowercased()

        return items.filter { item in

            if item.title.lowercased().contains(lowercasedSearch) {
                return true
            }

            if let todo = item as? Todo {
                if let project = todo.project, project.lowercased().contains(lowercasedSearch) {
                    return true
                }

                if todo.tags.contains(where: { $0.lowercased().contains(lowercasedSearch) }) {
                    return true
                }

                if let note = todo.note, note.lowercased().contains(lowercasedSearch) {
                    return true
                }
            }

            return false
        }
    }
}
