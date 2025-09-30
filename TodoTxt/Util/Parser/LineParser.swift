//
//  LineParser.swift
//  TodoTxt
//
//  Created by Johan Wigmo on 2025-09-30.
//

protocol LineParser {
    func parse(line: String) -> Item?
}
