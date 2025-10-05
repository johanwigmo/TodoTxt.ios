//
//  FileLineTests.swift
//  TodoTxtTests
//
//  Created by Johan Wigmo on 2025-10-02.
//

import Testing
@testable import TodoTxt

struct FileLineTests {

    @Test("Serialize line with header item")
    func serializedLineWithHeaderItem() {
        let header = Header(title: "Header")
        let line = FileLine(lineNumber: 0, item: header)

        let serialized = line.serialize()
        #expect(serialized == "# Header")
    }

    @Test("Serialize line with todo Item")
    func serializedLineWithTodoItem() {
        let todo = Todo(title: "Test todo", priority: .A)
        let line = FileLine(lineNumber: 0, item: todo)

        let serialized = line.serialize()
        #expect(serialized == "(A) Test todo")
    }

    @Test("Serialize line without item")
    func serializeLineWithoutItem() {
        let line = FileLine(lineNumber: 0, rawContent: " # Test comment")

        let serialized = line.serialize()
        #expect(serialized == " # Test comment")
    }

    @Test("Serialize empty line")
    func serializeEmptyLine() {
        let line = FileLine(lineNumber: 0, rawContent: "")
        
        let serialized = line.serialize()
        #expect(serialized == "")
    }

    @Test("Serialize line with whitespace")
    func serializeLineWithWhitespace() {
        let line = FileLine(lineNumber: 0, rawContent: " ")
        
        let serialized = line.serialize()
        #expect(serialized == " ")
    }

    @Test("Line number is preserved")
    func lineNumberIsPreserved() {
        let expected = 42
        let todo = Todo(title: "Test todo")
        let line = FileLine(lineNumber: expected, item: todo)

        #expect(line.lineNumber == expected)
    }

    @Test("Each line has unique id")
    func eachLineHasUniqueId() {
        let line1 = FileLine(lineNumber: 0, rawContent: "Line 1")
        let line2 = FileLine(lineNumber: 0, rawContent: "Line 2")

        #expect(line1.id != line2.id)
    }
}
