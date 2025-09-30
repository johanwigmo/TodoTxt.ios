//
//  Parser.swift
//  TodoTxt
//
//  Created by Johan Wigmo on 2025-09-27.
//

import Foundation

class Parser {

    let lineParsers: [LineParser]

    init(lineParsers: [LineParser] = [HeaderParser(), TodoParser()]) {
        self.lineParsers = lineParsers
    }

    func parse(_ input: String) -> [Item] {
        let lines = input.components(separatedBy: .newlines)
        let items = lines.compactMap {
            let trimmed = $0.trimmingCharacters(in: .whitespaces)
            return parse(line: trimmed)
        }
        return items
    }
}

private extension Parser {

    func parse(line: String) -> Item? {
        guard !line.isEmpty else { return nil }

        for parser in lineParsers {
            guard let item = parser.parse(line: line) else { continue }
            return item
        }

        return nil
    }
}
