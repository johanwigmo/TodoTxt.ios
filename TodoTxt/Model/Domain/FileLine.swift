//
//  FileLine.swift
//  TodoTxt
//
//  Created by Johan Wigmo on 2025-10-02.
//

import Foundation

struct FileLine: Identifiable {
    let id = UUID()
    let lineNumber: Int
    let rawContent: String?
    let item: (any Item)?

    init(lineNumber: Int, rawContent: String? = nil, item: (any Item)? = nil) {
        self.lineNumber = lineNumber
        self.rawContent = rawContent
        self.item = item
    }
}

extension FileLine: Serializable {
    
    func serialize() -> String {
        guard let item  else {
            return rawContent ?? ""
        }

        if let header = item as? Header {
            return header.serialize()
        }

        if let todo = item as? Todo {
            return todo.serialize()
        }

        return rawContent ?? ""
    }
}
