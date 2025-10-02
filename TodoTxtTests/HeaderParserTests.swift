//
//  HeaderParserTests.swift
//  TodoTxtTests
//
//  Created by Johan Wigmo on 2025-09-30.
//

import Testing
@testable import TodoTxt

struct HeaderParserTests {

    let sut = HeaderParser()

    @Test("Parse a header")
    func parseHeader() {
        let input = "# Header"
        let result = sut.parse(line: input)

        #expect(result?.title == "Header")
    }

    @Test("Parse incorect header", arguments: ["## Header", "# ", "#", " # Test comment"])
    func parseIncorrectHeader(input: String) {
        let result = sut.parse(line: input)
        #expect(result == nil)
    }
}
