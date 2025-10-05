//
//  TodoFileManagerTests.swift
//  TodoTxtTests
//
//  Created by Johan Wigmo on 2025-10-05.
//

import Testing
import Foundation
@testable import TodoTxt

struct TodoFileManagerTests {

    @Test("Load file successfully")
    func loadFileSuccess() throws {
        let tempUrl = createTempFile(content:
        """
        # Work
        (A) Important task +Work @Online
        x 2025-01-01 Completed task
        
            # This is a comment
        (B) Another task +Personal
        """)

        let manager = TodoFileManager()
        let lines = try manager.load(from: tempUrl)

        #expect(lines.count == 6)
        #expect(lines[0].item is Header)
        #expect(lines[1].item is Todo)
        #expect(lines[2].item is Todo)
        #expect(lines[3].item == nil)
        #expect(lines[4].item == nil)
        #expect(lines[5].item is Todo)

        try? FileManager.default.removeItem(at: tempUrl)
    }

    @Test("Load preserves raw content")
    func loadPreservesRawContent() throws {
        let content =
        """
        # Header
        (A) A task
            Incorrect task
            # A comment
        """
        let tempUrl = createTempFile(content: content)

        let manager = TodoFileManager()
        let lines = try manager.load(from: tempUrl)

        #expect(lines[0].rawContent == "# Header")
        #expect(lines[1].rawContent == "(A) A task")
        #expect(lines[2].rawContent == "    Incorrect task")
        #expect(lines[3].rawContent == "    # A comment")

        try? FileManager.default.removeItem(at: tempUrl)
    }

    @Test("Load file not found")
    func loadFileNotFound() throws {
        let manager = TodoFileManager()
        let nonExistentUrl = URL(fileURLWithPath: "/tmp/nonexistent-\(UUID().uuidString).txt")

        #expect(throws: FileManagerError.fileNotFound) {
            try manager.load(from: nonExistentUrl)
        }
    }

    @Test("Save file successfully")
    func saveFileSuccess() throws {
        let tempUrl = FileManager.default.temporaryDirectory
            .appendingPathComponent("test-\(UUID().uuidString).txt")

        // Create file
        try "Initial content".write(to: tempUrl, atomically: true, encoding: .utf8)

        let manager = TodoFileManager()
        _ = try manager.load(from: tempUrl)

        let lines = [
            FileLine(lineNumber: 0, rawContent: "# Header", item: Header(title: "Header")),
            FileLine(lineNumber: 1, rawContent: "(A) A todo", item: Todo(title: "A todo", priority: .A)),
            FileLine(lineNumber: 2, rawContent: "    # A comment", item: nil)
        ]

        try manager.save(lines: lines)

        let savedContent = try String(contentsOf: tempUrl, encoding: .utf8)
        let expectedContent =
        """
        # Header
        (A) A todo
            # A comment
        """

        #expect(savedContent == expectedContent)

        try? FileManager.default.removeItem(at: tempUrl)
    }

    @Test("Save without loading throws error")
    func saveWithoutLoadingThrowsError() throws {
        let manager = TodoFileManager()

        let lines: [FileLine] = [
            FileLine(lineNumber: 0, item: Todo(title: "Todo"))
        ]

        #expect(throws: FileManagerError.noFileLoaded) {
            try manager.save(lines: lines)
        }
    }

    @Test("Save and load")
    func saveAndLoad() throws {
        let tempUrl = FileManager.default.temporaryDirectory
            .appending(path: "saveandload-\(UUID().uuidString).txt")

        let originalContent =
        """
        # Work
        (A) Important todo +Work @Online
        x 2025-01-01 Completed todo
        
        (B) Another todo note:"Some notes" url:https://example.com
        """

        try originalContent.write(to: tempUrl, atomically: true, encoding: .utf8)

        let manager = TodoFileManager()
        var lines = try manager.load(from: tempUrl)

        // Modify
        if let todo = lines[1].item as? Todo{
            let modified = Todo(
                title: "Modified todo",
                isCompleted: false,
                completionDate: nil,
                priority: todo.priority,
                project: todo.project,
                tags: todo.tags,
                url: todo.url,
                note: todo.note
            )
            lines[1] = FileLine(lineNumber: 1, item: modified)
        }

        try manager.save(lines: lines)

        let reloadedLines = try manager.load(from: tempUrl)

        #expect(reloadedLines.count == 5)
        #expect((reloadedLines[1].item as? Todo)?.title == "Modified todo")

        try? FileManager.default.removeItem(at: tempUrl)
    }

    @Test("Preserve non-parseable lines")
    func preserveNonParseableLines() throws {
        let content =
        """
        # Header
        Normal todo
            # This line should be preserved
        
        Another todo
        """
        let tempUrl = createTempFile(content: content)

        let manager = TodoFileManager()
        let lines = try manager.load(from: tempUrl)

        #expect(lines[2].rawContent == "    # This line should be preserved")
        #expect(lines[2].item == nil)
        #expect(lines[3].rawContent == "")
        #expect(lines[3].item == nil)

        try? FileManager.default.removeItem(at: tempUrl)
    }

    @Test("Handle empty file")
    func handleEmptyFile() throws {
        let tempUrl = createTempFile(content: "")

        let manager = TodoFileManager()
        let lines = try manager.load(from: tempUrl)

        #expect(lines.count == 0)

        try? FileManager.default.removeItem(at: tempUrl)
    }
}

private func createTempFile(content: String) -> URL {
    let tempUrl = FileManager.default.temporaryDirectory
        .appendingPathComponent("test-\(UUID().uuidString).txt")
    try? content.write(to: tempUrl, atomically: true, encoding: .utf8)
    return tempUrl
}
