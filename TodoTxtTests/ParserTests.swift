//
//  ParserTests.swift
//  TodoTxtTests
//
//  Created by Johan Wigmo on 2025-09-27.
//

import Testing
@testable import TodoTxt

struct ParserTests {

    let sut = Parser()

    @Test("Parse multiple todos")
    func parseMultipleTodos() {
        let input =
            """
            This is my first todo
            
            x This is a completed todo
            """
        let result = sut.parse(input)

        #expect(result.count == 2)
        #expect(result[0] is Todo)
        #expect(result[1] is Todo)
    }

    @Test("Parse multiple Headers")
    func parseMultipleHeaders() {
        let input =
        """
        
        # First Header
        #
        # Second Header
        """
        let result = sut.parse(input)

        #expect(result.count == 2)
        #expect(result[0] is Header)
        #expect(result[1] is Header)
    }

    @Test("Parse different items")
    func parseDifferentItems() {
        let input =
        """
        #
        # First Header
        #
        
        This is my first todo
        This is my second todo
        
        #
        # Second Header
        #
        
        This is my third todo
        """
        let result = sut.parse(input)

        #expect(result.count == 5)
        #expect(result[0] is Header)
        #expect(result[1] is Todo)
        #expect(result[2] is Todo)
        #expect(result[3] is Header)
        #expect(result[4] is Todo)
    }
}
