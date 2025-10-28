//
//  TodoFileManager.swift
//  TodoTxt
//
//  Created by Johan Wigmo on 2025-10-05.
//

import Foundation

class TodoFileManager: FileManagerProtocol {

    private let lineParsers: [LineParser]
    private let fileManager: FileManager
    private var currentFileUrl: URL?

    init(lineParsers: [LineParser] = [HeaderParser(), TodoParser()], fileManager: FileManager = .default) {
        self.lineParsers = lineParsers
        self.fileManager = fileManager
    }

    func load(from url: URL) throws -> [FileLine] {
        guard fileManager.fileExists(atPath: url.path()) else {
            throw FileManagerError.fileNotFound
        }

        guard let content = try? String(contentsOf: url, encoding: .utf8) else {
            throw FileManagerError.invalidEncoding
        }

        currentFileUrl = url
        return parseContent(content)
    }

    func save(lines: [FileLine]) throws {
        guard let url = currentFileUrl else {
            throw FileManagerError.noFileLoaded
        }

        let content = lines.map { $0.serialize() }.joined(separator: "\n")

        guard let data = content.data(using: .utf8) else {
            throw FileManagerError.invalidEncoding
        }

        do {
            try data.write(to: url, options: .atomic)
        } catch {
            throw FileManagerError.writeFailed
        }
    }
}

private extension TodoFileManager {

    func parseContent(_ content: String) -> [FileLine] {
        guard !content.isEmpty else { return [] }
        
        let rawLines = content.components(separatedBy: .newlines)

        return rawLines.enumerated().map { index, line in
            let item = parseLine(line)
            return FileLine(lineNumber: index, rawContent: line, item: item)
        }
    }

    func parseLine(_ line: String) -> (any Item)? {
        guard !line.isEmpty else { return nil }

        for lineParser in lineParsers {
            guard let item = lineParser.parse(line: line) else { continue }
            return item
        }

        return nil
    }
}
