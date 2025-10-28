//
//  Serializable.swift
//  TodoTxt
//
//  Created by Johan Wigmo on 2025-10-02.
//

import Foundation

protocol Serializable {
    func serialize() -> String
}

extension Header: Serializable {

    func serialize() -> String {
        return "# \(title)"
    }
}

extension Todo: Serializable {

    func serialize() -> String {
        var components: [String] = []

        if isCompleted {
            components.append("x")
        }

        if let completionDate {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            components.append(formatter.string(from: completionDate))
        }

        if let priority {
            components.append("(\(priority.rawValue))")
        }

        components.append(title)

        if let project {
            components.append("+\(project)")
        }

        for tag in tags {
            components.append("@\(tag)")
        }

        if let due {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            components.append("due:\(formatter.string(from: due))")
        }

        if let url {
            components.append("url:\(url)")
        }

        if let note {
            components.append("note:\"\(note)\"")
        }

        return components.joined(separator: " ")
    }
}
