import SwiftUI

struct HabitRow: View {
    let habit: Habit
    let habitStore: HabitStore
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Circle()
                    .fill(habit.color.opacity(0.15))
                    .overlay(
                        Circle()
                            .fill(habit.color)
                            .frame(width: 8, height: 8)
                    )
                    .frame(width: 24, height: 24)
                
                Text(habit.name)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(Color(hex: "1F2937"))
                
                Spacer()
                
                Text("\(habit.currentStreak)🔥")
                    .font(.subheadline)
                    .foregroundColor(.orange)
                
                Image(systemName: habit.isCompletedToday() ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(habit.isCompletedToday() ? Color(hex: "10B981") : Color(hex: "D1D5DB"))
                    .font(.title3)
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 20)
            .background(Color.white)
            .cornerRadius(16)
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.horizontal)
    }
} 