import SwiftUI

struct Habit: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var days: Set<Int>
    var completedDates: Set<Date>
    var color: Color
    var goal: HabitGoal
    var reminder: HabitReminder?
    
    struct HabitGoal: Hashable {
        var type: GoalType
        var target: Int
        var current: Int
        
        enum GoalType: String, Hashable {
            case completion = "Completion"
            case counter = "Counter"
        }
    }
    
    struct HabitReminder: Hashable {
        var time: Date
        var isEnabled: Bool
        var identifier: String
    }
    
    // ... rest of the Habit implementation ...
} 