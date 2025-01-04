import SwiftUI

struct HomeView: View {
    @ObservedObject var habitStore: HabitStore
    @Binding var showingAddHabit: Bool
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    TodayProgressCard(habits: habitStore.habits)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Today's Habits")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(Color(hex: "1F2937"))
                            .padding(.horizontal)
                        
                        ForEach(habitStore.habits.filter { $0.isScheduledForToday() }) { habit in
                            HabitRow(
                                habit: habit,
                                habitStore: habitStore,
                                action: { habitStore.toggleHabitCompletion(habit) }
                            )
                        }
                        
                        if habitStore.habits.filter({ $0.isScheduledForToday() }).isEmpty {
                            EmptyStateView()
                        }
                    }
                }
                .padding(.vertical, 24)
            }
            .background(Color(hex: "F3F4F6"))
            .navigationTitle("Habits")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { showingAddHabit = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(Color(hex: "7C3AED"))
                    }
                }
            }
        }
    }
} 