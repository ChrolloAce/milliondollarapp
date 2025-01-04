import SwiftUI

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "list.bullet.clipboard")
                .font(.system(size: 48))
                .foregroundColor(Color(hex: "9CA3AF"))
            Text("No habits for today")
                .font(.headline)
                .foregroundColor(Color(hex: "4B5563"))
            Text("Add a new habit to get started")
                .font(.subheadline)
                .foregroundColor(Color(hex: "6B7280"))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }
} 