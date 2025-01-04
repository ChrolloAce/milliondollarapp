import SwiftUI

struct Task: Identifiable, Hashable {
    let id = UUID()
    var title: String
    var isCompleted: Bool
    var dueDate: Date?
    var notes: String?
}

struct Project: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var tasks: [Task]
    var isExpanded: Bool
    var color: Color
} 