import SwiftUI

class TaskStore: ObservableObject {
    @Published var projects: [Project] = []
    
    func addProject(_ project: Project) {
        projects.append(project)
    }
    
    func toggleTask(_ task: Task, in project: Project) {
        guard let projectIndex = projects.firstIndex(where: { $0.id == project.id }),
              let taskIndex = projects[projectIndex].tasks.firstIndex(where: { $0.id == task.id }) else { return }
        
        projects[projectIndex].tasks[taskIndex].isCompleted.toggle()
    }
} 