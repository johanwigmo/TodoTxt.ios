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

    func parse(line: String) -> (any Item)? {
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
            due: due,
            url: url,
            note: note
        )
    }
}

private extension TodoParser {

    func extractIsCompleted(_ text: inout String) -> Bool {
        extract(from: &text, pattern: Pattern.completed) { _ in true } ?? false
    }

    func extractCompletionDate(_ text: inout String) -> Date? {
        extract(from: &text, pattern: Pattern.completionDate) {
            dateFormatter.date(from: $0.trimmingCharacters(in: .whitespaces))
        }
    }

    func extractPriority(_ text: inout String) -> TodoPriority? {
        extract(from: &text, pattern: Pattern.priority) {
            TodoPriority(rawValue: $0)
        }
    }

    func extractProject(_ text: inout String) -> String? {
        extract(from: &text, pattern: Pattern.project) { $0 }
    }

    func extractTags(_ text: inout String) -> [String] {
        extractAll(from: &text, pattern: Pattern.tags) { $0 }
    }

    func extractDue(_ text: inout String) -> Date? {
        extract(from: &text, pattern: Pattern.dueDate) {
            dateFormatter.date(from: $0.trimmingCharacters(in: .whitespaces))
        }
    }

    func extractUrl(_ text: inout String) -> String? {
        extract(from: &text, pattern: Pattern.url) { $0 }
    }

    func extractNote(_ text: inout String) -> String? {
        extract(from: &text, pattern: Pattern.note) { $0 }
    }
}

private extension TodoParser {

    func extract<T, R>(
        from text: inout String,
        pattern: R,
        transform: (String) -> T?
    ) -> T? where R: RegexComponent {
        guard let match = text.firstMatch(of: pattern) else { return nil }

        let matchedString: String
        if let tuple = match.output as? (Substring, Substring) {
            matchedString = String(tuple.1)
        } else {
            matchedString = String(text[match.range])
        }

        let trimmed = matchedString.trimmingCharacters(in: .whitespaces)
        guard let value = transform(trimmed) else { return nil }

        text.removeSubrange(match.range)

        return value
    }

    func extractAll<T>(
        from text: inout String,
        pattern: Regex<(Substring, Substring)>,
        transform: (String) -> T?
    ) -> [T] {
        var results = [T]()
        while let match = text.firstMatch(of: pattern) {
            let matchedString = String(match.1)
            if let value = transform(matchedString) {
                results.append(value)
            }
            text.removeSubrange(match.range)
        }
        return results
    }
}
