import SwiftUI

class HabitStore: ObservableObject {
    @Published var habits: [Habit] = []
    
    func toggleHabitCompletion(_ habit: Habit) {
        if let index = habits.firstIndex(where: { $0.id == habit.id }) {
            var updatedHabit = habit
            if habit.isCompletedToday() {
                let today = Date()
                updatedHabit.completedDates = updatedHabit.completedDates.filter { date in
                    !Calendar.current.isDate(date, inSameDayAs: today)
                }
            } else {
                updatedHabit.completedDates.insert(Date())
            }
            habits[index] = updatedHabit
        }
    }
    
    func addHabit(_ habit: Habit) {
        habits.append(habit)
    }
    
    func updateHabit(_ habit: Habit) {
        if let index = habits.firstIndex(where: { $0.id == habit.id }) {
            habits[index] = habit
        }
    }
} 