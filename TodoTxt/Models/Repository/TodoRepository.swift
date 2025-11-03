//
//  TodoRepository.swift
//  TodoTxt
//
//  Created by Johan Wigmo on 2025-10-06.
//

import Foundation

enum RepositoryError: Error, Equatable {
    case invalidId
}

@Observable
class TodoRepository {

    var lines: [FileLine] = []
    var currentFileUrl: URL?
    private let fileManager: FileManagerProtocol

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

    func updateItem(id: UUID, with item: any Item) throws {
        guard let index = lines.firstIndex(where: { $0.item?.id == id }) else {
            throw RepositoryError.invalidId
        }

        lines[index] = FileLine(lineNumber: index, item: item)
    }

    func removeItem(id: UUID) throws {
        guard let index = lines.firstIndex(where: { $0.item?.id == id }) else {
            throw RepositoryError.invalidId
        }

        lines.remove(at: index)
        renumberLines()
    }

    func moveItem(from source: Int, to destination: Int) throws {
        guard source >= 0 && source < lines.count else {
            throw RepositoryError.invalidId
        }
        guard destination >= 0 && destination <= lines.count else {
            throw RepositoryError.invalidId
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

extension TodoRepository {

    var items: [any Item] {
        lines.compactMap { $0.item }
    }

    var allProjects: [String] {
        let projects = items.compactMap { item -> String? in
            guard let todo = item as? Todo else { return nil }
            return todo.project
        }
        return Array(Set(projects)).sorted()
    }

    var allTags: [String] {
        let tags = items.compactMap { item -> [String]? in
            guard let todo = item as? Todo else { return nil }
            return todo.tags
        }.flatMap { $0 }
        return Array(Set(tags)).sorted()
    }
}
