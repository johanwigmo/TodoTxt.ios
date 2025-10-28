//
//  Todo.swift
//  TodoTxt
//
//  Created by Johan Wigmo on 2025-09-27.
//

import Foundation

enum TodoPriority: String, CaseIterable, Comparable {
    case A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V, W, X, Y, Z

    static func < (lhs: TodoPriority, rhs: TodoPriority) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}

struct Todo: Item {

    let id = UUID()
    var title: String
    var isCompleted: Bool
    var completionDate: Date?
    var priority: TodoPriority?
    var project: String?
    var tags: [String]
    var due: Date?
    var url: String?
    var note: String?

    init(
        title: String,
        isCompleted: Bool = false,
        completionDate: Date? = nil,
        priority: TodoPriority? = nil,
        project: String? = nil,
        tags: [String] = [],
        due: Date? = nil,
        url: String? = nil,
        note: String? = nil
    ) {
        self.title = title
        self.isCompleted = isCompleted
        self.completionDate = completionDate
        self.priority = priority
        self.project = project
        self.tags = tags
        self.due = due
        self.url = url
        self.note = note
    }
}
