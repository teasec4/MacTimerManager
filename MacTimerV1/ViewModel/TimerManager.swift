import Foundation
import Combine

@MainActor
class TimerManager: ObservableObject {
    @Published private(set) var timers: [TimerModel] = []
    @Published private(set) var history: [HistoryEntry] = []   // ← история

    private let timersKey  = "timers_data"
    private let historyKey = "history_data"
    
    // MARK: - CRUD timers
    func addTimer(name: String, icon: String) {
        let newTimer = TimerModel(name: name, icon: icon)
        timers.append(newTimer)
        saveTimers()
    }
    
    func removeTimer(_ timer: TimerModel) {
        timer.stop()
        timers.removeAll { $0.id == timer.id }
        saveTimers()
    }
    
    // MARK: - History
    func saveSession(from timer: TimerModel) {
        guard timer.elapsedTime > 0 else { return }
        let entry = HistoryEntry(
            timerID: timer.id,                   // ← сохраняем связь
            timerName: timer.name,
            icon: timer.icon,
            duration: timer.elapsedTime,
            date: Date()
        )
        history.append(entry)
        saveHistory()
        
        timer.stop()
        saveTimers()
    }
    
    // Суммы по дням для КОНКРЕТНОГО таймера (последующие 7-дневные мини-календари)
    func dailyTotals(for timer: TimerModel) -> [Date: TimeInterval] {
        let cal = Calendar.current
        return history.reduce(into: [Date: TimeInterval]()) { dict, entry in
            // back-compat: если старые записи без timerID, пробуем сопоставить по имени+иконке
            let sameTimer = (entry.timerID == timer.id) ||
                            (entry.timerID == nil && entry.timerName == timer.name && entry.icon == timer.icon)
            guard sameTimer else { return }
            let day = cal.startOfDay(for: entry.date)
            dict[day, default: 0] += entry.duration
        }
    }
    
    // Если вдруг захочешь агрегировать вообще за все таймеры (на будущее)
    var dailyTotalsAll: [Date: TimeInterval] {
        let cal = Calendar.current
        return history.reduce(into: [Date: TimeInterval]()) { dict, entry in
            let day = cal.startOfDay(for: entry.date)
            dict[day, default: 0] += entry.duration
        }
    }
    
    // MARK: - Persistence
    func saveTimers() {
        do {
            let data = try JSONEncoder().encode(timers)
            UserDefaults.standard.set(data, forKey: timersKey)
        } catch { print("❌ save timers:", error) }
    }
    
    func loadTimers() {
        guard let data = UserDefaults.standard.data(forKey: timersKey) else { return }
        do {
            timers = try JSONDecoder().decode([TimerModel].self, from: data)
        } catch {
            print("❌ load timers:", error)
            timers = []
        }
    }
    
    func saveHistory() {
        do {
            let data = try JSONEncoder().encode(history)
            UserDefaults.standard.set(data, forKey: historyKey)
        } catch { print("❌ save history:", error) }
    }
    
    func loadHistory() {
        guard let data = UserDefaults.standard.data(forKey: historyKey) else { return }
        do {
            history = try JSONDecoder().decode([HistoryEntry].self, from: data)
        } catch {
            print("❌ load history:", error)
            history = []
        }
    }
}
