import SwiftUI

struct SettingsView: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Settings")
                .font(.title)
            Text("Здесь будут настройки приложения")
                .foregroundColor(.secondary)
            
            Button("Close") {
                isPresented = false
            }
            .keyboardShortcut(.escape)
        }
        .padding()
        .frame(width: 300, height: 200)
    }
}

#Preview {
    SettingsView(isPresented: .constant(true))
}
