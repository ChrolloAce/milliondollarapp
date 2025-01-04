import SwiftUI

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