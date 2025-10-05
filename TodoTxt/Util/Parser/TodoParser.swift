//
//  TodoParser.swift
//  TodoTxt
//
//  Created by Johan Wigmo on 2025-09-30.
//

import Foundation

class TodoParser: LineParser {

    private let dateFormatter: DateFormatter

    init() {
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateFormat = "yyyy-MM-dd"
    }

    func parse(line: String) -> Item? {
        guard !line.isEmpty else { return nil }
        guard !line.hasPrefix(" ") else { return nil }
        guard !line.hasPrefix("#") else { return nil }

        var workingCopy = String(line.drop(while: { $0.isWhitespace }))

        let isCompleted = extractIsCompleted(&workingCopy)
        let completionDate = extractCompletionDate(&workingCopy)
        let priority = extractPriority(&workingCopy)

        let project = extractProject(&workingCopy)
        let tags = extractTags(&workingCopy)
        let due = extractDue(&workingCopy)
        let reccuring = extractReccuring(&workingCopy)
        let url = extractUrl(&workingCopy)
        let note = extractNote(&workingCopy)
        let title = workingCopy.trimmingCharacters(in: .whitespaces)

        return Todo(
            title: title,
            isCompleted: isCompleted,
            completionDate: completionDate,
            priority: priority,
            project: project,
            tags: tags,
            dueDate: due,
            reccuring: reccuring,
            url: url,
            note: note
        )
    }
}

private extension TodoParser {
    func extractIsCompleted(_ text: inout String) -> Bool {
        let isCompleted = text.hasPrefix("x ")
        text.removeFirst(isCompleted ? 2 : 0)
        return isCompleted
    }

    func extractCompletionDate(_ text: inout String) -> Date? {
        // "yyyy-MM-dd "
        let pattern = /^\d{4}-\d{2}-\d{2}\s+/

        guard let match = text.firstMatch(of: pattern) else { return nil }
        let dateString = String(text[match.range]).trimmingCharacters(in: .whitespaces)

        guard let date = dateFormatter.date(from: dateString) else { return nil }
        text.removeSubrange(match.range)
        return date
    }

    func extractPriority(_ text: inout String) -> TodoPriority? {
        let pattern = /^\(([A-Z])\)\s?/

        guard let match = text.firstMatch(of: pattern) else { return nil }
        let priorityString = String(match.1)

        guard let priority = TodoPriority(rawValue: priorityString) else { return nil }
        text.removeSubrange(match.range)

        return priority
    }

    func extractProject(_ text: inout String) -> String? {
        let pattern = /(?:^|\s)\+([A-Za-z0-9-]+)/
        return extractSingleData(&text, pattern: pattern)
    }

    func extractTags(_ text: inout String) -> [String] {
        let pattern = /(?:^|\s)@([A-Za-z0-9-]+)/

        var tags = [String]()
        while let match = text.firstMatch(of: pattern) {
            tags.append(String(match.1))
            text.removeSubrange(match.range)
        }

        return tags
    }

    func extractDue(_ text: inout String) -> Date? {
        let pattern = /(?:^|\s)due:(\d{4}-\d{2}-\d{2})/

        guard let match = text.firstMatch(of: pattern) else { return nil }
        let dateString = String(match.1)

        guard let date = dateFormatter.date(from: dateString) else { return nil }
        text.removeSubrange(match.range)
        return date
    }

    func extractReccuring(_ text: inout String) -> String? {
        let pattern = /(?:^|\s)repeat:([^\s]+)/
        return extractSingleData(&text, pattern: pattern)
    }

    func extractUrl(_ text: inout String) -> String? {
        let pattern = /(?:^|\s)url:([^\s]+)/
        return extractSingleData(&text, pattern: pattern)
    }

    func extractNote(_ text: inout String) -> String? {
        let pattern = /(?:^|\s)note:"([^"]+)"/
        return extractSingleData(&text, pattern: pattern)
    }
}

private extension TodoParser {

    func extractSingleData(_ text: inout String, pattern: Regex<(Substring, Substring)>) -> String? {
        guard let match = text.firstMatch(of: pattern) else { return nil }
        let found = String(match.1)
        text.removeSubrange(match.range)

        while let match = text.firstMatch(of: pattern) {
            text.removeSubrange(match.range)
        }

        return found
    }
}
