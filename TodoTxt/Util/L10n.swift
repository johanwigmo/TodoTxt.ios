//
//  L10n.swift
//  TodoTxt
//
//  Created by Johan Wigmo on 2025-10-14.
//

enum L10n {

    // MARK: Navigation
    static let defaultTitle = String(localized: "Todo")

    // MARK: Empty State
    static let emptyStateTitle = String(localized: "No todo list loaded")
    static let emptyStateDescription = String(localized: "Load a todo.txt file to get started")

    // MARK: Actions
    static let loadFile = String(localized: "Load file")
    static let newTodo = String(localized: "New todo")
    static let addProject = String(localized: "+Project")
    static let addTag = String(localized: "@Tag")
    static let addDue = String(localized: "Add due date")
    static let addNote = String(localized: "Add note")
    static let addUrl = String(localized: "Add url")
    static let openUrl = String(localized: "Open")

    static let setDue = String(localized: "Set due date")
    static let removeDue = String(localized: "Remove due date")


    // MARK: Alert
    static let deleteItem = String(localized: "Delete Item?")
    static let deleteTodoDescription = String(localized: "The title cannot be empty.")
    static let deleteHeaderDescription = String(localized: "A header cannot be empty.")

    static let delete = String(localized: "Delete")
    static let cancel = String(localized: "Cancel")

    // Mark: Placeholders
    static let placeholderTitle = String(localized: "Title")
    static let placeHolderHeader = String(localized: "Header")
}
