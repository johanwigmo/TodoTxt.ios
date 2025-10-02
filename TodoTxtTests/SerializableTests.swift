//
//  SerializableTests.swift
//  TodoTxtTests
//
//  Created by Johan Wigmo on 2025-10-02.
//

import Testing
import Foundation
@testable import TodoTxt

struct SerializableTests {

    var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyy-MM-dd"
        return formatter
    }()

    @Test("Serialize header")
    func serializeHeader() {
        let header = Header(title: "A header")
        let serialized = header.serialize()

        #expect(serialized == "# A header")
    }

    @Test("Serialize simple todo")
    func serializeLineWithTodoItem() {
        let todo = Todo(title: "Test todo")
        let serialized = todo.serialize()

        #expect(serialized == "Test todo")
    }

    @Test("Serialize a completed todo")
    func serializeCompletedTodo() {
        let todo = Todo(title: "Test todo", isCompleted: true)
        let serialized = todo.serialize()

        #expect(serialized == "x Test todo")
    }

    @Test("Serialize todo with completion date")
    func serializeTodoWithCompletionDate() {
        let date = dateFormatter.date(from: "2025-01-01")!
        let todo = Todo(title: "Test todo", isCompleted: true, completionDate: date)
        let serialized = todo.serialize()

        #expect(serialized == "x 2025-01-01 Test todo")
    }

    @Test("Serialize todo with priority")
    func serializeTodoWithPriority() {
        let todo = Todo(title: "Test todo", priority: .A)
        let serialized = todo.serialize()

        #expect(serialized == "(A) Test todo")
    }

    @Test("Serialize todo with a project")
    func serializedTodoWithProject() {
        let todo = Todo(title: "Test todo", project: "Test-Project")
        let serialized = todo.serialize()
        
        #expect(serialized == "Test todo +Test-Project")
    }

    @Test("Serialize todo with tags")
    func serializeTodoWithTags() {
        let todo = Todo(title: "Test todo", tags: ["tag1", "tag2"])
        let serialized = todo.serialize()

        #expect(serialized == "Test todo @tag1 @tag2")
    }

    @Test("Serialize todo with due date")
    func serializeTodoWithDueDate() {
        let date = dateFormatter.date(from: "2025-01-01")!
        let todo = Todo(title: "Test todo", dueDate: date)
        let serialized = todo.serialize()
        
        #expect(serialized == "Test todo due:2025-01-01")
    }

    @Test("Serialize todo with reccuring")
    func serializeTodoWithReccuring() {
        let todo = Todo(title: "Test todo", reccuring: "14d")
        let serialized = todo.serialize()
        
        #expect(serialized == "Test todo repeat:14d")
    }

    @Test("Serialize todo with url")
    func serializeTodoWithUrl() {
        let todo = Todo(title: "Test todo", url: "https://example.com")
        let serialized = todo.serialize()
        
        #expect(serialized == "Test todo url:https://example.com")
    }

    @Test("Serialize todo with note")
    func serializedTodoWithNote() {
        let todo = Todo(title: "Test todo", note: "This is a note")
        let serialized = todo.serialize()
        
        #expect(serialized == "Test todo note:\"This is a note\"")
    }

    @Test("Serialze todo with all fields")
    func serializeTodoWithAllFields() {
        let date = dateFormatter.date(from: "2025-01-01")!

        let todo = Todo(
            title: "Test todo",
            isCompleted: true,
            completionDate: date,
            priority: .B,
            project: "Project",
            tags: ["tag1", "tag2"],
            dueDate: date,
            reccuring: "7d",
            url: "https://example.com",
            note: "This is a note"
        )
        let serialized = todo.serialize()

        #expect(serialized == "x 2025-01-01 (B) Test todo +Project @tag1 @tag2 due:2025-01-01 repeat:7d url:https://example.com note:\"This is a note\"")
    }

    @Test("Serialize and parse")
    func serializeAndParse() {
        let date = dateFormatter.date(from: "2025-01-01")!

        let original = Todo(
            title: "Test todo",
            isCompleted: true,
            completionDate: date,
            priority: .B,
            project: "Project",
            tags: ["tag1", "tag2"],
            dueDate: date,
            reccuring: "7d",
            url: "https://example.com",
            note: "This is a note"
        )

        let serialized = original.serialize()

        let parser = TodoParser()
        guard let parsed = parser.parse(line: serialized) as? Todo else {
            Issue.record("Failed to parse serialized todo")
            return
        }

        #expect(parsed.title == original.title)
        #expect(parsed.isCompleted == original.isCompleted)
        #expect(parsed.completionDate == original.completionDate)
        #expect(parsed.priority == original.priority)
        #expect(parsed.project == original.project)
        #expect(parsed.tags == original.tags)
        #expect(parsed.dueDate == original.dueDate)
        #expect(parsed.reccuring == original.reccuring)
        #expect(parsed.url == original.url)
        #expect(parsed.note == original.note)

    }
}
