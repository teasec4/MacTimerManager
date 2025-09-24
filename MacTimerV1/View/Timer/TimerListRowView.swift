import SwiftUI

struct TimerListRowView: View {
    @ObservedObject var timer: TimerModel
    let timerManager: TimerManager
    
    var body: some View {
        HStack {
            // Иконка
            Text(timer.icon)
                .font(.title3)
            
            // Имя и время
            VStack(alignment: .leading, spacing: 2) {
                Text(timer.name)
                    .font(.headline)
                    .lineLimit(1)
                
                Text(timer.formattedTime)
                    .font(.caption)
                    .foregroundColor(timer.isRunning ? .blue : .secondary)
            }
            
            Spacer()
            
            // Кнопки управления
            HStack(spacing: 8) {
                Button("Save Session") {
                    timerManager.saveSession(from: timer)
                    timer.stop() // сбрасываем таймер
                }
                .buttonStyle(.bordered)
                .disabled(timer.elapsedTime == 0)
                .opacity(timer.elapsedTime == 0 ? 0.3 : 1.0)
                
                Button {
                    timer.isRunning ? timer.pause() : timer.start()
                } label: {
                    Image(systemName: timer.isRunning ? "pause.fill" : "play.fill")
                        .foregroundColor(timer.isRunning ? .orange : .green)
                }
                .buttonStyle(.borderless)
                
                Button {
                    timer.stop()
                } label: {
                    Image(systemName: "stop.fill")
                        .foregroundColor(.red)
                }
                .buttonStyle(.plain)
                .disabled(timer.elapsedTime == 0)
                .opacity(timer.elapsedTime == 0 ? 0.3 : 1.0)
            }
        }
        .padding(.vertical, 4)
        .contextMenu {
            Button(timer.isRunning ? "Pause" : "Start") {
                timer.isRunning ? timer.pause() : timer.start()
            }
            Button("Stop") {
                timer.stop()
            }
            .disabled(timer.elapsedTime <= 0)
            
            Divider()
            
            Button("Duplicate") {
                timerManager.addTimer(name: "\(timer.name) Copy", icon: timer.icon)
            }
            Button("Delete", role: .destructive) {
                timerManager.removeTimer(timer)
            }
        }
    }
}
