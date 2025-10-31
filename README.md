# Custom iOS frontend for todo.txt

Parsing [todo.txt](http://todotxt.org/) text files for visualization and interaction, to suit my workflow. Syncing via iCloud.

## Version planning

### v1.0.0

- [x] todo.txt parser
- [/] File management, fetch and update
- [x] Edit Header
- [x] Edit Todo
- [ ] Search
- [ ] iCloud sync
- [ ] Backup file content

### v1.1.0

- [ ] Support multiple files
- [ ] Filter by priority/projects/tags

### v1.2.0

- [ ] Theming
- [ ] Settings/Personalization


## Example file 

```
# Heading (Area of Interest)

A simple todo

x A completed todo
x 2025-01-01 A completed todo, with a completion date 

(A) A prioritized todo
(B) A less prioritized todo

A todo with a project +project
A todo with a tag @tag
A todo with multiple tags @tag1 @tag2

A todo with a due date due:2025-01-01
A todo with an url url:https://wigmo.dev
A todo with a note note:"This is a note"

x 2025-01-01 (A) A combination of everything +project @tag1 @tag2 due:2025-01-01 url:https://wigmo.dev note:"This is a note"
```
