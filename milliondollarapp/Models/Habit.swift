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
    
    var currentStreak: Int {
        var streak = 0
        let calendar = Calendar.current
        var currentDate = Date()
        
        while true {
            if !days.contains(calendar.component(.weekday, from: currentDate)) {
                currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
                continue
            }
            
            if completedDates.contains(where: { calendar.isDate($0, inSameDayAs: currentDate) }) {
                streak += 1
                currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
            } else {
                break
            }
        }
        return streak
    }
    
    func isScheduledForToday() -> Bool {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: Date())
        let adjustedWeekday = weekday == 1 ? 7 : weekday - 1
        return days.contains(adjustedWeekday)
    }
    
    func isCompletedToday() -> Bool {
        let calendar = Calendar.current
        let today = Date()
        return completedDates.first(where: { calendar.isDate($0, inSameDayAs: today) }) != nil
    }
} 