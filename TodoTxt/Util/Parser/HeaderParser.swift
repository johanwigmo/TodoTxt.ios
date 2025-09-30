//
//  HeaderParser.swift
//  TodoTxt
//
//  Created by Johan Wigmo on 2025-09-30.
//

class HeaderParser: LineParser {

    func parse(line: String) -> Item? {
        let pattern = /^#\s+(.+)$/

        guard let match = line.firstMatch(of: pattern) else { return nil }

        return Header(title: match.1.trimmingCharacters(in: .whitespaces))
    }
}
