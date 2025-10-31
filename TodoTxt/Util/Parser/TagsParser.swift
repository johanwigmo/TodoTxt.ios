//
//  TagsParser.swift
//  TodoTxt
//
//  Created by Johan Wigmo on 2025-10-31.
//

import Foundation

struct TagsParser {

    static func parse(_ text: String) -> [String] {
        text.split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
    }

    static func currentTag(from text: String) ->  String {
        text.split(separator: ",")
            .last?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    }

    static func append(_ tag: String, to text: String) -> String {
        var components = parse(text)
        if !components.isEmpty {
            components.removeLast()
        }
        components.append(tag)
        return components.joined(separator: ", ") + ", "
    }
}
