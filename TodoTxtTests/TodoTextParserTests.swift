//
//  TodoTextParserTests.swift
//  TodoTxtTests
//
//  Created by Johan Wigmo on 2025-10-31.
//

import Testing
@testable import TodoTxt

struct TodoTextParserTests {

    @Test("Extract priority A from text")
    func extractPriorityA() {
        let result = TodoTextParser.extractPriority(from: "(A) My important todo")

        #expect(result.priority == .A)
        #expect(result.title == "My important todo")
    }

    @Test("Extract priority Z from text")
    func extractPriorityZ() {
        let result = TodoTextParser.extractPriority(from: "(Z) Low priority task")

        #expect(result.priority == .Z)
        #expect(result.title == "Low priority task")
    }

    @Test("No priority returns nil and full text")
    func noPriority() {
        let result = TodoTextParser.extractPriority(from: "Regular todo")

        #expect(result.priority == nil)
        #expect(result.title == "Regular todo")
    }

    @Test("Priority with extra spaces")
    func priorityWithSpaces() {
        let result = TodoTextParser.extractPriority(from: "(B)  Todo with spaces")

        #expect(result.priority == .B)
        #expect(result.title == "Todo with spaces")
    }

    @Test("Priority in middle of text is ignored")
    func priorityInMiddle() {
        let result = TodoTextParser.extractPriority(from: "Todo (A) in middle")

        #expect(result.priority == nil)
        #expect(result.title == "Todo (A) in middle")
    }

    @Test("Invalid priority letter returns nil")
    func invalidPriority() {
        let result = TodoTextParser.extractPriority(from: "(a) lowercase")

        #expect(result.priority == nil)
        #expect(result.title == "(a) lowercase")
    }

    @Test("Format title with priority")
    func formatWithPriority() {
        let result = TodoTextParser.formatTitle("My todo", priority: .A)

        #expect(result == "(A) My todo")
    }

    @Test("Format title without priority")
    func formatWithoutPriority() {
        let result = TodoTextParser.formatTitle("My todo", priority: nil)

        #expect(result == "My todo")
    }

    // MARK: - Remove Priority Tests

    @Test("Remove priority prefix")
    func removePriority() {
        let result = TodoTextParser.removePriorityPrefix(from: "(A) My todo")

        #expect(result == "My todo")
    }

    @Test("Remove priority with no text after")
    func removePriorityOnly() {
        let result = TodoTextParser.removePriorityPrefix(from: "(B) ")

        #expect(result == "")
    }
}
