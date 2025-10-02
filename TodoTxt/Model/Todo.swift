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
    let title: String
    let isCompleted: Bool
    let completionDate: Date?
    let priority: TodoPriority?
    let project: String?
    let tags: [String]
    let dueDate: Date?
    let reccuring: String? // Cannot use keyword `repeat`
    let url: String?
    let note: String?

    init(
        title: String,
        isCompleted: Bool = false,
        completionDate: Date? = nil,
        priority: TodoPriority? = nil,
        project: String? = nil,
        tags: [String] = [],
        dueDate: Date? = nil,
        reccuring: String? = nil,
        url: String? = nil,
        note: String? = nil
    ) {
        self.title = title
        self.isCompleted = isCompleted
        self.completionDate = completionDate
        self.priority = priority
        self.project = project
        self.tags = tags
        self.dueDate = dueDate
        self.reccuring = reccuring
        self.url = url
        self.note = note
    }
}
