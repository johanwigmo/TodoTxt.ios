//
//  TodoRepositoryTests.swift
//  TodoTxtTests
//
//  Created by Johan Wigmo on 2025-10-06.
//

import Testing
import Foundation
@testable import TodoTxt

struct TodoRepositoryTests {

    @Test("Load file updates lines")
    func loadFileUpdatesLines() throws {
        let mockFileManager = MockFileManager()
        let repository = TodoRepository(fileManager: mockFileManager)
        let url = URL(fileURLWithPath: "/test.txt")

        try repository.loadFile(from: url)

        #expect(repository.lines.count == 3)
        #expect(repository.currentFileUrl == url)
    }

    @Test("Save file without loading throws error")
    func saveFileWithoutLoadingThrowsError() throws {
        let repository = TodoRepository()

        #expect(throws: FileManagerError.noFileLoaded) {
            try repository.saveFile()
        }
    }

    @Test("Save file calls file manager")
    func saveFileCallsFileManager() throws {
        let mockFileManager = MockFileManager()
        let repository = TodoRepository(fileManager: mockFileManager)
        let url = URL(fileURLWithPath: "/tests.txt")

        try repository.loadFile(from: url)
        try repository.saveFile()

        #expect(mockFileManager.saveCalled)
        #expect(mockFileManager.savedLines?.count == 3)
    }

    @Test("Update item by ID")
    func updateItemById() throws {
        let mockFileManager = MockFileManager()
        let repository = TodoRepository(fileManager: mockFileManager)

        try repository.loadFile(from: URL(fileURLWithPath: "/test.txt"))

        let idToUpdate = repository.lines[1].item?.id ?? UUID()

        let newTodo = Todo(title: "Updated todo", priority: .A)
        try repository.updateItem(id: idToUpdate, with: newTodo)

        let updatedItem = repository.lines[1].item as? Todo
        #expect(updatedItem?.title == "Updated todo")
        #expect(updatedItem?.priority == .A)
    }

    @Test("Update item with invalid ID throws error")
    func updateItemWithInvalidIDThrowsError() throws {
        let mockFileManager = MockFileManager()
        let repository = TodoRepository(fileManager: mockFileManager)

        try repository.loadFile(from: URL(fileURLWithPath: "/test.txt"))

        let newTodo = Todo(title: "Updated todo")

        let invalidID = UUID()

        #expect(throws: RepositoryError.invalidId) {
            try repository.updateItem(id: invalidID, with: newTodo)
        }
    }

    @Test("Remove item renumbers lines")
    func removeItemRenumbersLines() throws {
        let mockFileManager = MockFileManager()
        let repository = TodoRepository(fileManager: mockFileManager)

        try repository.loadFile(from: URL(fileURLWithPath: "/test.txt"))
        let item = repository.lines[0].item!
        try repository.removeItem(id: item.id)

        for (index, line) in repository.lines.enumerated() {
            #expect(line.lineNumber == index)
        }
    }

    @Test("Remove item with invalid line number throws error")
    func removeItemWithinvalidIdThrowsError() throws {
        let mockFileManager = MockFileManager()
        let repository = TodoRepository(fileManager: mockFileManager)
        
        try repository.loadFile(from: URL(fileURLWithPath: "/test.txt"))

        let newTodo = Todo(title: "Invalid Todo")
        #expect(throws: RepositoryError.invalidId) {
            try repository.removeItem(id: newTodo.id)
        }
    }

    @Test("Add item at end")
    func addItemAtEnd() throws {
        let mockFileManager = MockFileManager()
        let repository = TodoRepository(fileManager: mockFileManager)
        
        try repository.loadFile(from: URL(fileURLWithPath: "/test.txt"))

        let initialCount = repository.lines.count
        let newTodo = Todo(title: "New todo")
        repository.addItem(newTodo)

        #expect(repository.lines.count == initialCount + 1)
        #expect((repository.lines.last?.item as? Todo)?.title == "New todo")
    }

    @Test("Add item at specific position")
    func addItemAtSpecificPosition() throws {
        let mockFileManager = MockFileManager()
        let repository = TodoRepository(fileManager: mockFileManager)

        try repository.loadFile(from: URL(fileURLWithPath: "/test.txt"))

        let newTodo = Todo(title: "Inserted todo")
        repository.addItem(newTodo, at: 1)

        #expect((repository.lines[1].item as? Todo)?.title == "Inserted todo")
    }

    @Test("Add item renumbers subsequent lines")
    func addItemRenumbersSubsequentLines() throws {
        let mockFileManager = MockFileManager()
        let repository = TodoRepository(fileManager: mockFileManager)
        
        try repository.loadFile(from: URL(fileURLWithPath: "/test.txt"))
        
        let newTodo = Todo(title: "Inserted todo")
        repository.addItem(newTodo, at: 1)

        for (index, line)in repository.lines.enumerated() {
            #expect(line.lineNumber == index)
        }
    }

    @Test("Get items returns only parsed items")
    func getItemsReturnsOnlyParsedItems() throws {
        let mockFileManager = MockFileManager()
        let repository = TodoRepository(fileManager: mockFileManager)

        try repository.loadFile(from: URL(fileURLWithPath: "/test.txt"))

        let items = repository.items
        #expect(items.count == 2)
    }

    @Test("Move item updates line numbers")
    func moveItemUpdatesLineNumbers() throws {
        let mockFileManager = MockFileManager()
        let repository = TodoRepository(fileManager: mockFileManager)

        try repository.loadFile(from: URL(fileURLWithPath: "/test.txt"))

        try repository.moveItem(from: 0, to: 2)

        #expect(repository.lines[0].item is Todo)
        #expect(repository.lines[1].item == nil)
        #expect(repository.lines[2].item is Header)

        for (index, line) in repository.lines.enumerated() {
            #expect(line.lineNumber == index)
        }
    }

    @Test("Move item from end to beginning")
    func moveItemFromEndToBeginning() throws {
        let mockFileManager = MockFileManager()
        let repository = TodoRepository(fileManager: mockFileManager)
        
        try repository.loadFile(from: URL(fileURLWithPath: "/test.txt"))

        try repository.moveItem(from: 2, to: 0)

        #expect(repository.lines[0].item == nil)
        #expect(repository.lines[2].item is Todo)
    }

    @Test("Move item with invalid source throws error")
    func moveItemWithInvalidSourceThrowsError() throws {
        let mockFileManager = MockFileManager()
        let repository = TodoRepository(fileManager: mockFileManager)

        try repository.loadFile(from: URL(fileURLWithPath: "/test.txt"))

        #expect(throws: RepositoryError.invalidId){
            try repository.moveItem(from: 10, to: 0)
        }
    }

    @Test("Move item with invalid destination throws error")
    func moveItemWithInvalidDestinationThrowsError() throws {
        let mockFileManager = MockFileManager()
        let repository = TodoRepository(fileManager: mockFileManager)

        try repository.loadFile(from: URL(fileURLWithPath: "/test.txt"))

        #expect(throws: RepositoryError.invalidId){
            try repository.moveItem(from: 0, to: 10)
        }
    }
}

class MockFileManager: FileManagerProtocol {

    var saveCalled = false
    var savedLines: [FileLine]?
    private var loadedUrl: URL?

    func load(from url: URL) throws -> [FileLine] {
        loadedUrl = url
        return [
            FileLine(lineNumber: 0, item: Header(title: "Header")),
            FileLine(lineNumber: 1, item: Todo(title: "Todo", priority: .A)),
            FileLine(lineNumber: 2, rawContent: "    # Comment")
        ]
    }

    func save(lines: [FileLine]) throws {
        guard loadedUrl != nil else {
            throw FileManagerError.noFileLoaded
        }

        saveCalled = true
        savedLines = lines
    }
}
