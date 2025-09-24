import Foundation

struct HistoryEntry: Identifiable, Codable {
    let id: UUID
    let timerID: UUID?        // ← добавили
    let timerName: String
    let icon: String
    let duration: TimeInterval
    let date: Date
    
    init(timerID: UUID?, timerName: String, icon: String, duration: TimeInterval, date: Date = Date()) {
        self.id = UUID()
        self.timerID = timerID
        self.timerName = timerName
        self.icon = icon
        self.duration = duration
        self.date = date
    }
    
    // Утилиты форматирования (если нужно выводить в списке истории)
    var formattedDuration: String {
        let h = Int(duration) / 3600
        let m = (Int(duration) % 3600) / 60
        let s = Int(duration) % 60
        return h > 0 ? String(format: "%02d:%02d:%02d", h, m, s)
                     : String(format: "%02d:%02d", m, s)
    }
}
