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
    static let add = String(localized: "Add")
    static let addTodo = String(localized: "Add todo")
    static let addHeader = String(localized: "Add header")

    static let addProject = String(localized: "+Project")
    static let addTag = String(localized: "@Tag")
    static let addDue = String(localized: "Add due date")
    static let addNote = String(localized: "Add note")
    static let addUrl = String(localized: "Add url")

    static let openUrl = String(localized: "Open")

    static let delete = String(localized: "Delete")
    static let cancel = String(localized: "Cancel")
    static let clear = String(localized: "Clear")

    static let setDue = String(localized: "Set due date")
    static let removeDue = String(localized: "Remove due date")

    // MARK: Alert
    static let deleteItem = String(localized: "Delete Item?")
    static let deleteTodoDescription = String(localized: "The title cannot be empty.")
    static let deleteHeaderDescription = String(localized: "A header cannot be empty.")


    // MARK: Placeholders
    static let placeholderSearch = String(localized: "Search")
    static let placeholderTitle = String(localized: "Add title")
    static let placeHolderHeader = String(localized: "Add header")
    static let placeholderProject = String(localized: "Add project")
    static let placeholderTags = String(localized: "Add tags")
    static let placeholderDueDate = String(localized: "Add due date")
    static let placeholderUrl = String(localized: "Add url")
    static let placeholderNote = String(localized: "Add note")

    // MARK: Misc
    static let details = String(localized: "Details")
    static let header = String(localized: "Header")
    static let todo = String(localized: "Todo")
    static let priority = String(localized: "Priority")
    static let note = String(localized: "Note")

}
