import SwiftUI

struct TodayProgressCard: View {
    let habits: [Habit]
    
    var progress: Double {
        let todayHabits = habits.filter { $0.isScheduledForToday() }
        guard !todayHabits.isEmpty else { return 0 }
        return Double(todayHabits.filter { $0.isCompletedToday() }.count) / Double(todayHabits.count)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Today's Progress")
                .font(.headline)
                .foregroundColor(.gray)
            
            HStack {
                Text("\(Int(progress * 100))%")
                    .font(.system(size: 34, weight: .bold))
                Spacer()
                CircularProgressView(progress: progress)
                    .frame(width: 50, height: 50)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        .padding(.horizontal)
    }
} 