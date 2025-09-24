import SwiftUI

struct AddTimerView: View {
    @ObservedObject var timerManager: TimerManager
    @Binding var isPresented: Bool
    
    @State private var timerName: String = ""
    @State private var selectedIcon: String = "⏱"
    
    let availableIcons = ["⏱", "💻", "📚", "🏃‍♂️", "🎨", "📝", "☕", "💡", "📱", "🔧", "🎵", "🧘‍♂️", "📊"]
    
    var body: some View {
        VStack(spacing:5) {
            Text("New Timer")
                .font(.headline)
            
            TextField("Timer name", text: $timerName)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
         
            
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 8) {
                    ForEach(availableIcons, id: \.self) { icon in
                        Text(icon)
                            .font(.largeTitle)
                            .frame(maxWidth: .infinity)
                            .padding(8)
                            .background(selectedIcon == icon ? Color.accentColor.opacity(0.3) : Color.clear)
                            .cornerRadius(8)
                            .onTapGesture { selectedIcon = icon }
                    }
                }
                .padding()
            }
             
            
            
            HStack {
                Button("Cancel") { isPresented = false }
                Spacer()
                Button("Add") {
                    timerManager.addTimer(name: timerName.isEmpty ? "Untitled" : timerName,
                                          icon: selectedIcon)
                    isPresented = false
                }
                .disabled(timerName.trimmingCharacters(in: .whitespaces).isEmpty)
            }
            .padding(.horizontal)
        }
        .padding()
        .frame(minWidth: 200, maxWidth: 250, minHeight: 200, maxHeight: 250)
    }
}

