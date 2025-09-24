import SwiftUI

struct ContentView: View {
    enum Mode { case list, stats }
    @State private var mode: Mode = .list
    
    @StateObject private var manager = TimerManager()
    @State private var isCompact = false
    @State private var showingAddTimer = false
    
    var body: some View {
        NavigationStack {   // 👈 ОБЯЗАТЕЛЬНО
            Group {
                if isCompact {
                    CompactTimerView(manager: manager, isCompact: $isCompact)
                } else {
                    switch mode {
                    case .list:
                        
                            List {
                                ForEach(manager.timers) { timer in
                                    TimerListRowView(timer: timer, timerManager: manager)
                                }
                                .onDelete { indexSet in
                                    for index in indexSet {
                                        let t = manager.timers[index]
                                        manager.removeTimer(t)
                                    }
                                }
                                NewTimerRowView(action: {showingAddTimer = true})
                            }
                            
                            
                        
                    case .stats:
                        HistoryByTimerView(manager: manager)
                    }
                }
            }
            .navigationTitle(mode == .list ? "Timers" : "Stats") // 👈 вот здесь меняется заголовок
            .onAppear {
                manager.loadTimers()
                manager.loadHistory()
            }
            .frame(
                minWidth: isCompact ? 170 : 350,
                idealWidth: isCompact ? 200 : 350,
                maxWidth: isCompact ? 230 : .infinity,
                minHeight: isCompact ? 170 : 400,
                idealHeight: isCompact ? 170 : 400,
                maxHeight: isCompact ? 170 : .infinity
            )
            .toolbar {
                if isCompact{
                    ToolbarItem(placement: .automatic) {
                                Button {
                                    withAnimation { isCompact = false }
                                } label: {
                                    Label("Expand", systemImage: "arrow.up.left.and.arrow.down.right")
                                }
                            }
                } else {
                    ToolbarItem(placement:.navigation) {
                        Button {
                            mode = .list
                        } label: {
                            Image(systemName: "list.bullet")
                        }
                    }
                    
                    ToolbarItemGroup(placement: .automatic) {
                        Button {
                            mode = .stats
                        } label: {
                            Label("Stats", systemImage: "chart.bar.doc.horizontal")
                        }
                        
                        Button {
                            withAnimation { isCompact.toggle() }
                        } label: {
                            Label("Compact Mode", systemImage: isCompact
                                  ? "arrow.up.left.and.arrow.down.right"
                                  : "arrow.down.right.and.arrow.up.left")
                        }
                    }
                }
               
            }
            .sheet(isPresented: $showingAddTimer) {
                AddTimerView(timerManager: manager, isPresented: $showingAddTimer)
            }
        }
    }
}
