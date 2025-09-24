import SwiftUI

struct CompactTimerView: View {
    @ObservedObject var manager: TimerManager
    @Binding var isCompact: Bool
    @State private var selectedTimerID: UUID?
    
    var body: some View {
        VStack {
            // тулбар
            HStack {
                Spacer()
                Picker("", selection: $selectedTimerID) {
                    ForEach(manager.timers) { t in
                        Text("\(t.icon) \(t.name)")
                            .tag(t.id as UUID?)
                    }
                }
                .pickerStyle(.menu)
                
                Spacer()
                
               
            }
            
            // выбранный таймер
            if let id = selectedTimerID,
               let timer = manager.timers.first(where: { $0.id == id }) {
                CompactTimerDetailView(timer: timer)
            } else {
                Text("No Timer Selected")
                    .foregroundColor(.secondary)
                    .padding()
            }
        }
        .onAppear {
            if selectedTimerID == nil {
                selectedTimerID = manager.timers.first?.id
            }
        }
    }
}
