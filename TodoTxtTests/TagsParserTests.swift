//
//  TagsParserTests.swift
//  TodoTxtTests
//
//  Created by Johan Wigmo on 2025-10-31.
//

import Testing
@testable import TodoTxt

struct TagsParserTests {
    
    @Test("Parse single tag")
    func parseSingle() {
        let result = TagsParser.parse("urgent")
        
        #expect(result == ["urgent"])
    }
    
    @Test("Parse multiple tags")
    func parseMultiple() {
        let result = TagsParser.parse("urgent, important, work")
        
        #expect(result == ["urgent", "important", "work"])
    }
    
    @Test("Parse with extra spaces")
    func parseWithSpaces() {
        let result = TagsParser.parse("urgent  ,  important  , work")
        
        #expect(result == ["urgent", "important", "work"])
    }
    
    @Test("Parse empty string returns empty array")
    func parseEmpty() {
        let result = TagsParser.parse("")
        
        #expect(result.isEmpty)
    }
    
    @Test("Get current tag from single tag")
    func currentTagSingle() {
        let result = TagsParser.currentTag(from: "urgent")
        
        #expect(result == "urgent")
    }
    
    @Test("Get current tag from multiple tags")
    func currentTagMultiple() {
        let result = TagsParser.currentTag(from: "urgent, import")
        
        #expect(result == "import")
    }
    
    @Test("Append tag to empty string")
    func appendToEmpty() {
        let result = TagsParser.append("urgent", to: "")
        
        #expect(result == "urgent, ")
    }
    
    @Test("Append tag to existing tags")
    func appendToExisting() {
        let result = TagsParser.append("work", to: "urgent, imp")
        
        #expect(result == "urgent, work, ")
    }
}
