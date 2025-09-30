//
//  TodoParserTests.swift
//  TodoTxtTests
//
//  Created by Johan Wigmo on 2025-09-30.
//

import Testing
import Foundation
@testable import TodoTxt

struct TodoParserTests {

    let sut = TodoParser()

    @Test("Parse empty line")
    func parseEmpty() {
        let input = ""
        let result = sut.parse(line: input)
        
        #expect(result == nil)
    }

    @Test("Parse comment")
    func parseCommen() {
        let input = "#"
        let result = sut.parse(line: input)

        #expect(result == nil)
    }

    @Test("Parse simple todo")
    func parseSimpleTodo() {
        let input = " A simple todo"
        let result = sut.parse(line: input) as? Todo

        #expect(result?.title == "A simple todo")
        #expect(result?.isCompleted == false)
        #expect(result?.priority == nil)
        #expect(result?.completionDate == nil)
        #expect(result?.project == nil)
        #expect(result?.tags == [])
        #expect(result?.url == nil)
        #expect(result?.note == nil)
    }

    @Test("Parse completed todo")
    func parseCompletedTodo() {
        let input = "x A completed todo"
        let result = sut.parse(line: input) as? Todo

        #expect(result?.title == "A completed todo")
        #expect(result?.isCompleted == true)
        #expect(result?.completionDate == nil)
    }

    @Test("Parse completed todo with date")
    func parseCompletedTodoWithDate() {
        let input = "x 2025-01-01 A completed todo, with a completion date"
        let result = sut.parse(line: input) as? Todo

        #expect(result?.title == "A completed todo, with a completion date")
        #expect(result?.isCompleted == true)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let expectedDate = dateFormatter.date(from: "2025-01-01")
        #expect(result?.completionDate == expectedDate)
    }

    @Test("Parse completed todo with invalid date")
    func parseCompletedTodoWithInvalidDate() {
        let input = "x 2025-1-01 A completed todo, with a invalid date"
        let result = sut.parse(line: input) as? Todo

        #expect(result?.title == "2025-1-01 A completed todo, with a invalid date")
        #expect(result?.isCompleted == true)
        #expect(result?.completionDate == nil)
    }

    @Test("Parse todo with priority")
    func parseTodoWithPriority() {
        let input = "(A) A prioritized todo"
        let result = sut.parse(line: input) as? Todo

        #expect(result?.title == "A prioritized todo")
        #expect(result?.priority == .A)
    }

    @Test("Parse all priorities", arguments: ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"])
    func parseAllPriorities(priority: String) {
        let input = "(\(priority)) Priority \(priority) todo"
        let result = sut.parse(line: input) as? Todo

        #expect(result?.priority == TodoPriority(rawValue: priority))
    }

    @Test("Parse todo with project")
    func parseTodoWithProject() {
        let input = "A todo with a Work project +Work"
        let result = sut.parse(line: input) as? Todo

        #expect(result?.title == "A todo with a Work project")
        #expect(result?.project == "Work")
    }

    @Test("Parse todo with multi-word-project")
    func parseTodoWithMultiWordProject() {
        let input = "A todo with a long project +Long-Project-Name"
        let result = sut.parse(line: input) as? Todo
        
        #expect(result?.title == "A todo with a long project")
        #expect(result?.project == "Long-Project-Name")
    }

    @Test("Parse todo with tag")
    func parseTodoWithTag() {
        let input = "A todo with a tag @FirstTag"
        let result = sut.parse(line: input) as? Todo

        #expect(result?.title == "A todo with a tag")
        #expect(result?.tags == ["FirstTag"])
    }

    @Test("Parse todo with multiple tags")
    func parseTodoWithMultipleTags() {
        let input = "A todo with multiple tags @FirstTag @SecondTag"
        let result = sut.parse(line: input) as? Todo

        #expect(result?.title == "A todo with multiple tags")
        #expect(result?.tags == ["FirstTag", "SecondTag"])
    }

    @Test("Parse todo with url")
    func parseTodoWithUrl() {
        let input = "A todo with a URL url:https://example.com"
        let result = sut.parse(line: input) as? Todo

        #expect(result?.title == "A todo with a URL")
        #expect(result?.url == "https://example.com")
    }

    @Test("Parse todo with a note")
    func parseTodoWithNote() {
        let input = "A todo with a note note:\"This is a note\""
        let result = sut.parse(line: input) as? Todo

        #expect(result?.title == "A todo with a note")
        #expect(result?.note == "This is a note")
    }

    @Test("Parse a complex todo")
    func parseComplexTodo() {
        let input = "x 2025-01-01 (A) Complex todo +project @tag1 @tag2 url:https://example.com note:\"A complex note\""
        let result = sut.parse(line: input) as? Todo

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let expectedDate = dateFormatter.date(from: "2025-01-01")

        #expect(result?.title == "Complex todo")
        #expect(result?.isCompleted == true)
        #expect(result?.completionDate == expectedDate)
        #expect(result?.priority == .A)
        #expect(result?.project == "project")
        #expect(result?.tags == ["tag1", "tag2"])
        #expect(result?.url == "https://example.com")
        #expect(result?.note == "A complex note")
    }
}
