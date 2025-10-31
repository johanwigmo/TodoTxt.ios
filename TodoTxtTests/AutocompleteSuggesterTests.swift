//
//  AutocompleteSuggesterTests.swift
//  TodoTxtTests
//
//  Created by Johan Wigmo on 2025-10-31.
//

import Testing
@testable import TodoTxt

struct AutocompleteSuggesterTests {
    
    @Test("Suggest from empty search returns first option")
    func emptySearch() {
        let result = AutocompleteSuggester.suggest(
            for: "",
            from: ["Work", "Personal", "Shopping"]
        )
        
        #expect(result == "Work")
    }
    
    @Test("Suggest matching option")
    func matchingOption() {
        let result = AutocompleteSuggester.suggest(
            for: "Wor",
            from: ["Work", "Personal", "Shopping"]
        )
        
        #expect(result == "Work")
    }
    
    @Test("Suggest case insensitive")
    func caseInsensitive() {
        let result = AutocompleteSuggester.suggest(
            for: "work",
            from: ["Work", "Personal", "Shopping"]
        )
        
        #expect(result == "Work")
    }
    
    @Test("Suggest excluding options")
    func excludingOptions() {
        let result = AutocompleteSuggester.suggest(
            for: "o",
            from: ["Work", "Shopping", "Home"],
            excluding: ["Work"]
        )
        
        #expect(result == "Shopping")
    }
    
    @Test("No matching suggestion returns nil")
    func noMatch() {
        let result = AutocompleteSuggester.suggest(
            for: "xyz",
            from: ["Work", "Personal", "Shopping"]
        )
        
        #expect(result == nil)
    }
    
    @Test("Completion text for partial match")
    func completionText() {
        let result = AutocompleteSuggester.completionText(
            for: "Wor",
            suggestion: "Work"
        )
        
        #expect(result == "k")
    }
    
    @Test("Completion text case insensitive")
    func completionTextCaseInsensitive() {
        let result = AutocompleteSuggester.completionText(
            for: "wor",
            suggestion: "Work"
        )
        
        #expect(result == "k")
    }
}
