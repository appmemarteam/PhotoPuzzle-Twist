import SwiftUI

struct SettingsView: View {
    @Bindable var settings = SettingsStore.shared
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Feedback") {
                    Toggle("Haptics", isOn: $settings.hapticsEnabled)
                    Toggle("Sound", isOn: $settings.soundEnabled)
                }
                
                Section("About") {
                    LabeledContent("Version", value: "1.0.0")
                    Text("Made with ♥ by AppMemar")
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                Button("Done") { dismiss() }
            }
        }
    }
}
