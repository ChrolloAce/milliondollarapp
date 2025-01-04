import SwiftUI

struct AddTaskView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var project: Project
    @State private var taskTitle = ""
    @State private var dueDate = Date()
    @State private var hasDate = false
    @State private var notes = ""
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Task Title", text: $taskTitle)
                
                Toggle("Add Due Date", isOn: $hasDate)
                
                if hasDate {
                    DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)
                }
                
                Section("Notes") {
                    TextEditor(text: $notes)
                        .frame(height: 100)
                }
            }
            .navigationTitle("New Task")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        let task = Task(title: taskTitle,
                                      isCompleted: false,
                                      dueDate: hasDate ? dueDate : nil,
                                      notes: notes.isEmpty ? nil : notes)
                        project.tasks.append(task)
                        dismiss()
                    }
                    .disabled(taskTitle.isEmpty)
                }
            }
        }
    }
} 