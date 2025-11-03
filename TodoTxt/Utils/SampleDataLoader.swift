//
//  SampleDataLoader.swift
//  TodoTxt
//
//  Created by Johan Wigmo on 2025-10-17.
//

import Foundation

#if DEBUG

enum SampleDataLoader {

    static func createSampleRepository() -> TodoRepository {
        let repo = TodoRepository()

        let sampleLines: [FileLine] = [
            FileLine(lineNumber: 0, item: Header(title: "Work")),
            FileLine(lineNumber: 1, item: Todo(
                title: "Review Q4 budget proposal",
                priority: .A,
                project: "Work",
                tags: ["urgent", "finance"]
            )),
            FileLine(lineNumber: 2, item: Todo(
                title: "Read design documentation",
                project: "Work"
            )),
            FileLine(lineNumber: 3, item: Todo(
                title: "Schedule team meeting",
                project: "Work",
                tags: ["meetings"]
            )),
            FileLine(lineNumber: 4, item: Todo(
                title: "Send client proposal",
                isCompleted: true,
                completionDate: Date(),
                project: "Freelance",
                tags: ["client"]
            )),

            FileLine(lineNumber: 5, item: Header(title: "Personal")),
            FileLine(lineNumber: 6, item: Todo(
                title: "Buy groceries for the week",
                priority: .B,
                project: "Personal",
                tags: ["shopping"],
                note: "Don't forget: milk, eggs, bread, coffee beans"
            )),
            FileLine(lineNumber: 7, item: Todo(
                title: "Water the plants",
                project: "Home"
            )),
            FileLine(lineNumber: 8, item: Todo(
                title: "Call mom",
                project: "Personal",
                tags: ["family"]
            )),
            FileLine(lineNumber: 9, item: Todo(
                title: "Plan weekend trip",
                isCompleted: true,
                completionDate: Date(),
                priority: .C,
                project: "Personal",
                tags: ["travel"],
                url: "https://www.booking.com",
                note: "Check flights to Copenhagen"
            )),

            FileLine(lineNumber: 10, item: Header(title: "Projects")),
            FileLine(lineNumber: 11, item: Todo(
                title: "Research new project management tools",
                project: "Work",
                tags: ["research"],
                url: "https://www.notion.so"
            )),
            FileLine(lineNumber: 12, item: Todo(
                title: "Update portfolio website",
                project: "Freelance",
                tags: ["development"],
                note: "Add recent projects and update tech stack"
            )),
            FileLine(lineNumber: 13, item: Todo(
                title: "Learn SwiftUI animations",
                project: "Learning",
                tags: ["swift"]
            )),

            FileLine(lineNumber: 14, item: Header(title: "Shopping List")),
            FileLine(lineNumber: 15, item: Todo(
                title: "Buy milk",
                project: "Shopping",
                tags: ["groceries"]
            )),
            FileLine(lineNumber: 16, item: Todo(
                title: "Get coffee beans",
                project: "Shopping",
                tags: ["groceries"]
            )),
            FileLine(lineNumber: 17, item: Todo(
                title: "Pick up dry cleaning",
                project: "Errands"
            )),

            // Ideas Section
            FileLine(lineNumber: 18, item: Header(title: "Ideas")),
            FileLine(lineNumber: 19, item: Todo(
                title: "Write blog post about design patterns",
                project: "Blog",
                tags: ["writing"]
            )),
            FileLine(lineNumber: 20, item: Todo(
                title: "Start podcast about iOS development",
                project: "Side-project",
                tags: ["podcast"]
            )),
        ]

        for line in sampleLines {
            if let item = line.item {
                repo.addItem(item, at: line.lineNumber)
            }
        }

        repo.currentFileUrl = URL(fileURLWithPath: "/sample/todo.txt")

        return repo
    }

    static var sampleTodos: [Todo] {
        [
            Todo(title: "Bare minimum todo"),
            Todo(
                title: "Review Q4 budget proposal",
                priority: .A,
                project: "Work",
                tags: ["urgent", "finance"],
                url: "https://budget.example.com",
                note: "Check with Sarah before the meeting"
            ),
            Todo(
                title: "Buy groceries",
                priority: .B,
                tags: ["shopping"],
                note: "Milk, eggs, bread"
            ),
            Todo(
                title: "Water the plants",
                project: "Home"
            ),
            Todo(
                title: "Send client proposal",
                isCompleted: true,
                completionDate: Date(),
                project: "Freelance",
                tags: ["client"]
            )
        ]
    }
}

#endif
