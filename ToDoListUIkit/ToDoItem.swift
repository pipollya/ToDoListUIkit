import Foundation

struct ToDoItem: Codable{
    var name: String
    var isCompleted: Bool = false
    var id: UUID = UUID()
}
