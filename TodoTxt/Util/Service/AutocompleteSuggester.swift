//
//  AutoCompleteSuggester.swift
//  TodoTxt
//
//  Created by Johan Wigmo on 2025-10-31.
//

import Foundation

struct AutocompleteSuggester {

    static func suggest(
        for searchTerm: String,
        from allOptions: [String] = [],
        excluding excludeOptions: [String] = []
    ) -> String? {
        let cleaned = searchTerm.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleaned.isEmpty else { return allOptions.first }

        return allOptions
            .filter { !excludeOptions.contains($0) }
            .first { $0.localizedCaseInsensitiveContains(searchTerm) }
    }

    static func completionText(for searchTerm: String, suggestion: String) -> String {
        let cleaned = searchTerm.trimmingCharacters(in: .whitespacesAndNewlines)
        guard suggestion.lowercased().hasPrefix(cleaned.lowercased()) else {
            return ""
        }
        return String(suggestion.dropFirst(cleaned.count))
    }
}
