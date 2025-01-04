import SwiftUI

struct AddProjectView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var taskStore: TaskStore
    @State private var projectName = ""
    @State private var selectedColor = Color.blue
    
    let colors: [Color] = [.blue, .purple, .green, .orange, .pink, .red]
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Project Name", text: $projectName)
                
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
            .navigationTitle("New Project")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        let project = Project(name: projectName,
                                           tasks: [],
                                           isExpanded: true,
                                           color: selectedColor)
                        taskStore.addProject(project)
                        dismiss()
                    }
                    .disabled(projectName.isEmpty)
                }
            }
        }
    }
} 