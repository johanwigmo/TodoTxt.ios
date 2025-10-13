//
//  TodoRepository.swift
//  TodoTxt
//
//  Created by Johan Wigmo on 2025-10-06.
//

import Foundation

enum RepositoryError: Error, Equatable {
    case invalidLineNumber
}

class TodoRepository {

    private(set) var lines: [FileLine] = []
    private(set) var currentFileUrl: URL?
    private let fileManager: FileManagerProtocol

    var items: [any Item] {
        lines.compactMap { $0.item }
    }

    init(fileManager: FileManagerProtocol = TodoFileManager()) {
        self.fileManager = fileManager
    }

    func loadFile(from url: URL) throws {
        lines = try fileManager.load(from: url)
        currentFileUrl = url
    }

    func saveFile() throws {
        try fileManager.save(lines: lines)
    }

    func updateItem(at lineNumber: Int, with item: any Item) throws {
        guard lineNumber >= 0 && lineNumber < lines.count else {
            throw RepositoryError.invalidLineNumber
        }

        lines[lineNumber] = FileLine(lineNumber: lineNumber, item: item)
    }

    func removeItem(at lineNumber: Int) throws {
        guard lineNumber >= 0 && lineNumber < lines.count else {
            throw RepositoryError.invalidLineNumber
        }

        lines.remove(at: lineNumber)
        renumberLines()
    }

    func moveItem(from source: Int, to destination: Int) throws {
        guard source >= 0 && source < lines.count else {
            throw RepositoryError.invalidLineNumber
        }
        guard destination >= 0 && destination <= lines.count else {
            throw RepositoryError.invalidLineNumber
        }

        let item = lines.remove(at: source)
        lines.insert(item, at: destination)
        renumberLines()
    }


    func addItem(_ item: any Item, at lineNumber: Int? = nil) {
        let newLineNumber = lineNumber ?? lines.count
        let newLine = FileLine(lineNumber: newLineNumber, rawContent: nil, item: item)

        if let lineNumber, lineNumber < lines.count {
            lines.insert(newLine, at: lineNumber)
            renumberLines()
        } else {
            lines.append(newLine)
        }
    }
}

private extension TodoRepository {

    func renumberLines() {
        lines = lines.enumerated().map { index, line in
            FileLine(lineNumber: index, rawContent: line.rawContent, item: line.item)
        }
    }
}
