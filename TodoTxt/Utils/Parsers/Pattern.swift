//
//  Pattern.swift
//  TodoTxt
//
//  Created by Johan Wigmo on 2025-10-25.
//

enum Pattern {
    static let completed = /^x\s+/
    static let completionDate = /^\d{4}-\d{2}-\d{2}\s+/
    static let priority = /^\(([A-Z])\)\s?/
    static let project = /(?:^|\s)\+([A-Za-z0-9-]+)/
    static let tags = /(?:^|\s)@([A-Za-z0-9-]+)/
    static let dueDate = /(?:^|\s)due:(\d{4}-\d{2}-\d{2})/
    static let reccuring = /(?:^|\s)repeat:([^\s]+)/
    static let url = /(?:^|\s)url:([^\s]+)/
    static let note = /(?:^|\s)note:"([^"]+)"/

//    static let priorityAndTitle = /^\(([A-Z])\)\s+(.+)$/
    static let priorityAndTitle = /^\(([A-Z])\)(?:\s+(.+))?$/
}
