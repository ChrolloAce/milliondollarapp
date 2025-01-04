import SwiftUI

struct HabitProgressView: View {
    @ObservedObject var habitStore: HabitStore
    
    var body: some View {
        NavigationStack {
            List(habitStore.habits) { habit in
                VStack(alignment: .leading, spacing: 8) {
                    Text(habit.name)
                        .font(.headline)
                    
                    HStack {
                        ForEach(1...7, id: \.self) { day in
                            Circle()
                                .fill(habit.days.contains(day) ? habit.color : Color.gray.opacity(0.3))
                                .frame(width: 20, height: 20)
                        }
                    }
                }
            }
            .navigationTitle("Progress")
        }
    }
} 