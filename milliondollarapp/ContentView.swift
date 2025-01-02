//
//  ContentView.swift
//  milliondollarapp
//
//  Created by Ernesto  Lopez on 1/1/25.
//

import SwiftUI

// Model for Habit
struct Habit: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var days: Set<Int> // 1-7 representing days of week
    var completedDates: Set<Date>
    var color: Color
    
    func isScheduledForToday() -> Bool {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: Date()) // 1 = Sunday, 7 = Saturday
        let adjustedWeekday = weekday == 1 ? 7 : weekday - 1 // Convert to 1 = Monday, 7 = Sunday
        return days.contains(adjustedWeekday)
    }
    
    func isCompletedToday() -> Bool {
        let calendar = Calendar.current
        let today = Date()
        return completedDates.first(where: { calendar.isDate($0, inSameDayAs: today) }) != nil
    }
}

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
}

struct ContentView: View {
    @StateObject private var habitStore = HabitStore()
    @State private var selectedTab = 0
    @State private var showingAddHabit = false
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(habitStore: habitStore, showingAddHabit: $showingAddHabit)
                .tabItem {
                    Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                    Text("Today")
                }
                .tag(0)
            
            ProgressView(habitStore: habitStore)
                .tabItem {
                    Image(systemName: selectedTab == 1 ? "chart.bar.fill" : "chart.bar")
                    Text("Progress")
                }
                .tag(1)
            
            SettingsView()
                .tabItem {
                    Image(systemName: selectedTab == 2 ? "gear.fill" : "gear")
                    Text("Settings")
                }
                .tag(2)
        }
        .tint(.indigo)
    }
}

struct HomeView: View {
    @ObservedObject var habitStore: HabitStore
    @Binding var showingAddHabit: Bool
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    TodayProgressCard(habits: habitStore.habits)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Today's Habits")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        ForEach(habitStore.habits.filter { $0.isScheduledForToday() }) { habit in
                            HabitRow(habit: habit) {
                                habitStore.toggleHabitCompletion(habit)
                            }
                        }
                    }
                }
                .padding(.vertical)
            }
            .background(.gray.opacity(0.1))
            .navigationTitle("Habits")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { showingAddHabit = true }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.indigo)
                    }
                }
            }
            .sheet(isPresented: $showingAddHabit) {
                AddHabitView(habitStore: habitStore)
            }
        }
    }
}

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
        .background(.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        .padding(.horizontal)
    }
}

struct CircularProgressView: View {
    let progress: Double
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.2), lineWidth: 8)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(Color.indigo, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut, value: progress)
        }
    }
}

struct HabitRow: View {
    let habit: Habit
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Circle()
                    .fill(habit.color)
                    .frame(width: 12, height: 12)
                
                Text(habit.name)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Image(systemName: habit.isCompletedToday() ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(habit.isCompletedToday() ? .green : .gray)
                    .font(.title3)
            }
            .padding()
            .background(.white)
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.horizontal)
    }
}

struct AddHabitView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var habitStore: HabitStore
    @State private var habitName = ""
    @State private var selectedDays: Set<Int> = []
    @State private var selectedColor = Color.blue
    
    let colors: [Color] = [.blue, .purple, .green, .orange, .pink, .red]
    let weekDays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Habit Name", text: $habitName)
                
                Section("Schedule") {
                    HStack {
                        ForEach(0..<7) { index in
                            Button(action: {
                                if selectedDays.contains(index + 1) {
                                    selectedDays.remove(index + 1)
                                } else {
                                    selectedDays.insert(index + 1)
                                }
                            }) {
                                Text(weekDays[index])
                                    .padding(8)
                                    .background(selectedDays.contains(index + 1) ? Color.indigo : Color.clear)
                                    .foregroundColor(selectedDays.contains(index + 1) ? .white : .primary)
                                    .cornerRadius(8)
                            }
                        }
                    }
                }
                
                Section("Color") {
                    HStack {
                        ForEach(colors, id: \.self) { color in
                            Circle()
                                .fill(color)
                                .frame(width: 30, height: 30)
                                .overlay(
                                    Circle()
                                        .stroke(Color.white, lineWidth: selectedColor == color ? 2 : 0)
                                )
                                .onTapGesture {
                                    selectedColor = color
                                }
                        }
                    }
                }
            }
            .navigationTitle("New Habit")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        let habit = Habit(name: habitName,
                                        days: selectedDays,
                                        completedDates: [],
                                        color: selectedColor)
                        habitStore.habits.append(habit)
                        dismiss()
                    }
                    .disabled(habitName.isEmpty || selectedDays.isEmpty)
                }
            }
        }
        .frame(minWidth: 300, minHeight: 400)
    }
}

struct ProgressView: View {
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

struct SettingsView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("Preferences") {
                    Toggle("Dark Mode", isOn: .constant(false))
                    Toggle("Notifications", isOn: .constant(true))
                }
                
                Section("About") {
                    Text("Version 1.0")
                    Text("Made with ❤️")
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    ContentView()
}
