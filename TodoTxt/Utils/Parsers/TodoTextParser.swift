//
//  TodoTextHelper.swift
//  TodoTxt
//
//  Created by Johan Wigmo on 2025-10-31.
//

import Foundation

struct TodoTextParser {

    static func extractPriority(from text: String) -> (priority: TodoPriority?, title: String) {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)

        guard let match = trimmed.firstMatch(of: Pattern.priorityAndTitle) else {
            return (nil, trimmed)
        }

        let priority = TodoPriority(rawValue: String(match.1))
//        let title = String(match.2)
        let title = match.2.map(String.init) ?? ""

        return (priority, title)
    }

    static func formatTitle(_ title: String, priority: TodoPriority?) -> String {
        if let priority {
            return "(\(priority.rawValue)) \(title)"
        }
        return title
    }

    static func removePriorityPrefix(from text: String) -> String {
        extractPriority(from: text).title
    }
}
