import SwiftUI

struct TaskView: View {
    @ObservedObject var taskStore: TaskStore
    @State private var showingAddProject = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(taskStore.projects) { project in
                    ProjectView(project: project, taskStore: taskStore)
                }
            }
            .navigationTitle("Tasks")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { showingAddProject = true }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(Color(hex: "7C3AED"))
                    }
                }
            }
            .sheet(isPresented: $showingAddProject) {
                AddProjectView(taskStore: taskStore)
            }
        }
    }
}

struct ProjectView: View {
    let project: Project
    let taskStore: TaskStore
    @State private var showingAddTask = false
    
    var body: some View {
        DisclosureGroup {
            VStack(alignment: .leading, spacing: 8) {
                ForEach(project.tasks) { task in
                    TaskRow(task: task, projectColor: project.color)
                }
                
                Button(action: { showingAddTask = true }) {
                    Label("Add Task", systemImage: "plus")
                        .font(.subheadline)
                        .foregroundColor(project.color)
                }
                .padding(.top, 8)
            }
        } label: {
            HStack {
                Circle()
                    .fill(project.color)
                    .frame(width: 12, height: 12)
                Text(project.name)
                    .font(.headline)
                Spacer()
                Text("\(project.tasks.filter { !$0.isCompleted }.count) remaining")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
    }
}

struct TaskRow: View {
    let task: Task
    let projectColor: Color
    
    var body: some View {
        HStack {
            Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                .foregroundColor(task.isCompleted ? projectColor : .gray)
            
            VStack(alignment: .leading) {
                Text(task.title)
                    .strikethrough(task.isCompleted)
                
                if let dueDate = task.dueDate {
                    Text(dueDate, style: .date)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(.leading)
    }
} 