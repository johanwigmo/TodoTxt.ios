//
//  TodoSearchFilterTests.swift
//  TodoTxtTests
//
//  Created by Johan Wigmo on 2025-10-29.
//

import Testing
import Foundation
@testable import TodoTxt

struct TodoSearchFilterTests {

    @Test("Empty search returns all items")
    func emptySearchReturnsAllItems() {
        let items: [any Item] = [
            Header(title: "Work"),
            Todo(title: "Finish report"),
            Todo(title: "Send email"),
        ]

        let result = TodoSearchFilter.filter(items: items, searchText: "")
        #expect(result.count == 3)
    }

    @Test("Whitespace-only search returns all items")
    func whitespaceOnlySearchReturnsAllItems() {
        let items: [any Item] = [
            Header(title: "Work"),
            Todo(title: "Finish report"),
            Todo(title: "Send email"),
        ]

        let result = TodoSearchFilter.filter(items: items, searchText: "   ")
        #expect(result.count == 3)
    }

    @Test("Search matches header title")
    func searchmatchesHeaderTitle() {
        let items: [any Item] = [
            Header(title: "Work Projects"),
            Header(title: "Personal Goals"),
            Todo(title: "Buy milk")
        ]

        let result = TodoSearchFilter.filter(items: items, searchText: "projects")
        #expect(result.count == 1)
        #expect(result.first?.title == "Work Projects")
    }

    @Test("Search matches todo title")
    func searchMatchesTodoTitle() {
        let items: [any Item] = [
            Todo(title: "Buy groceries"),
            Todo(title: "Finish report"),
        ]

        let result = TodoSearchFilter.filter(items: items, searchText: "report")
        #expect(result.count == 1)
        #expect(result.first?.title == "Finish report")
    }

    @Test("Search is case insensitive")
    func searchIsCaseInsensitive() {
        let items: [any Item] = [
            Todo(title: "Buy Groceries"),
            Todo(title: "FINISH REPORT")
        ]

        let result = TodoSearchFilter.filter(items: items, searchText: "GrOcErIeS")
        #expect(result.count == 1)
        #expect(result.first?.title == "Buy Groceries")
    }

    @Test("Search matches project name")
    func searchMatchesProjectName() {
        let items: [any Item] = [
            Todo(title: "Fix bug", project: "AppRewrite"),
            Todo(title: "Write tests", project: "Testing"),
            Todo(title: "Review code")
        ]

        let result = TodoSearchFilter.filter(items: items, searchText: "apprewrite")
        #expect(result.count == 1)
        #expect(result.first?.title == "Fix bug")
    }

    @Test("Search matches partial project name")
    func searchMatchesPartialProjectName() {
        let items: [any Item] = [
            Todo(title: "Task 1", project: "WebsiteRedesign"),
            Todo(title: "Task 2", project: "AppRewrite")
        ]

        let result = TodoSearchFilter.filter(items: items, searchText: "website")
        #expect(result.count == 1)
    }

    @Test("Search matches single tag")
    func searchMatchesSingleTag() {
        let items: [any Item] = [
            Todo(title: "Task 1", tags: ["urgent", "work"]),
            Todo(title: "Task 2", tags: ["personal"]),
            Todo(title: "Task 3", tags: ["work"]),
        ]

        let result = TodoSearchFilter.filter(items: items, searchText: "urgent")
        #expect(result.count == 1)
        #expect(result.first?.title == "Task 1")
    }

    @Test("Search matches any tag in array")
    func searchMatchesAnyTag() {
        let items: [any Item] = [
            Todo(title: "Task 1", tags: ["urgent", "work", "important"]),
            Todo(title: "Task 2", tags: ["personal"])
        ]

        let result = TodoSearchFilter.filter(items: items, searchText: "important")
        #expect(result.count == 1)
    }

    @Test("Search matches partial tag")
    func searchMatchesPartialTag() {
        let items: [any Item] = [
            Todo(title: "Task", tags: ["programming"])
        ]

        let result = TodoSearchFilter.filter(items: items, searchText: "prog")
        #expect(result.count == 1)
    }

    @Test("Search matches note content")
    func searchMatchesNote() {
        let items: [any Item] = [
            Todo(title: "Task 1", note: "Remember to check the documentation"),
            Todo(title: "Task 2", note: "Call before 5pm"),
            Todo(title: "Task 3")
        ]

        let result = TodoSearchFilter.filter(items: items, searchText: "documentation")
        #expect(result.count == 1)
        #expect(result.first?.title == "Task 1")
    }

    @Test("Search returns multiple matching items")
        func searchReturnsMultipleMatches() {
            let items: [any Item] = [
                Todo(title: "Buy coffee"),
                Todo(title: "Coffee meeting at 3pm"),
                Todo(title: "Send email"),
                Header(title: "Coffee Shop Ideas")
            ]

            let result = TodoSearchFilter.filter(items: items, searchText: "coffee")
            #expect(result.count == 3)
        }

        @Test("Search matches across different fields")
        func searchMatchesAcrossFields() {
            let items: [any Item] = [
                Todo(title: "Review project", project: "WebApp"),
                Todo(title: "WebApp deployment", project: "Infrastructure"),
                Todo(title: "Update docs", tags: ["webapp"])
            ]

            let result = TodoSearchFilter.filter(items: items, searchText: "webapp")
            #expect(result.count == 3)
        }

        @Test("Search with no matches returns empty array")
        func searchWithNoMatchesReturnsEmpty() {
            let items: [any Item] = [
                Todo(title: "Buy groceries"),
                Todo(title: "Finish report")
            ]

            let result = TodoSearchFilter.filter(items: items, searchText: "nonexistent")
            #expect(result.isEmpty)
        }

        @Test("Search with empty items array returns empty")
        func searchWithEmptyItemsReturnsEmpty() {
            let items: [any Item] = []

            let result = TodoSearchFilter.filter(items: items, searchText: "test")
            #expect(result.isEmpty)
        }

        @Test("Search handles todos with nil optional fields")
        func searchHandlesNilFields() {
            let items: [any Item] = [
                Todo(title: "Simple task", project: nil, tags: [], note: nil)
            ]

            let result = TodoSearchFilter.filter(items: items, searchText: "task")
            #expect(result.count == 1)
        }

        @Test("Search with special characters")
        func searchWithSpecialCharacters() {
            let items: [any Item] = [
                Todo(title: "Task #1 - Important!"),
                Todo(title: "Email: john@example.com")
            ]

            let result = TodoSearchFilter.filter(items: items, searchText: "#1")
            #expect(result.count == 1)

            let result2 = TodoSearchFilter.filter(items: items, searchText: "john@")
            #expect(result2.count == 1)
        }
}
