//
//  ContentView.swift
//  milliondollarapp
//
//  Created by Ernesto  Lopez on 1/1/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var habitStore = HabitStore()
    @StateObject private var taskStore = TaskStore()
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
            
            TaskView(taskStore: taskStore)
                .tabItem {
                    Image(systemName: selectedTab == 1 ? "checklist" : "checklist")
                    Text("Tasks")
                }
                .tag(1)
            
            HabitProgressView(habitStore: habitStore)
                .tabItem {
                    Image(systemName: selectedTab == 2 ? "chart.bar.fill" : "chart.bar")
                    Text("Progress")
                }
                .tag(2)
            
            SettingsView()
                .tabItem {
                    Image(systemName: selectedTab == 3 ? "gear.fill" : "gear")
                    Text("Settings")
                }
                .tag(3)
        }
        .tint(Color(hex: "7C3AED"))
        .onAppear {
            NotificationManager.shared.requestAuthorization()
        }
    }
}
