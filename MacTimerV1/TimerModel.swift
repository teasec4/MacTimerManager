//
//  TimerModel.swift
//  MacTimerV1
//
//  Created by Максим Ковалев on 8/7/25.
//

import Foundation
import Combine

class TimerModel: ObservableObject, Identifiable, Hashable {
    let id: UUID
    @Published var name: String
    @Published var icon: String
    @Published var elapsedTime: TimeInterval = 0
    @Published var isRunning: Bool = false
    @Published var isPaused: Bool = false
    
    private var startTime: Date?
    private var timer: Timer?
    
    init(name: String, icon: String, elapsedTime: TimeInterval = 0, id: UUID = UUID()) {
        self.id = id
        self.name = name
        self.icon = icon
        self.elapsedTime = elapsedTime
    }
    
    func start() {
        if isPaused {
            // continue from pause
            startTime = Date().addingTimeInterval(-elapsedTime)
            isPaused = false
        } else {
            // new start
            startTime = Date()
            elapsedTime = 0
        }
        
        isRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if let startTime = self.startTime {
                self.elapsedTime = Date().timeIntervalSince(startTime)
            }
        }
    }
    
    func pause() {
        timer?.invalidate()
        timer = nil
        isRunning = false
        isPaused = true
    }
    
    func stop() {
        timer?.invalidate()
        timer = nil
        isRunning = false
        isPaused = false
        elapsedTime = 0
        startTime = nil
    }
    
    // Добавляем метод для очистки ресурсов
    func cleanup() {
        timer?.invalidate()
        timer = nil
        isRunning = false
    }
    
    var formattedTime: String {
        let hours = Int(elapsedTime) / 3600
        let minutes = (Int(elapsedTime) % 3600) / 60
        let seconds = Int(elapsedTime) % 60
        
        if hours > 0 {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
    
    // MARK: - Hashable
    static func == (lhs: TimerModel, rhs: TimerModel) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    // MARK: - Serialization
    func toDictionary() -> [String: Any] {
        return [
            "id": id.uuidString,
            "name": name,
            "icon": icon,
            "elapsedTime": elapsedTime,
            "isPaused": isPaused
            // Не сохраняем isRunning, так как при перезапуске приложения таймеры должны быть остановлены
        ]
    }
    
    static func fromDictionary(_ dict: [String: Any]) -> TimerModel? {
        guard let idString = dict["id"] as? String,
              let id = UUID(uuidString: idString),
              let name = dict["name"] as? String,
              let icon = dict["icon"] as? String else {
            return nil
        }
        
        let elapsedTime = dict["elapsedTime"] as? TimeInterval ?? 0
        let isPaused = dict["isPaused"] as? Bool ?? false
        
        let timer = TimerModel(name: name, icon: icon, elapsedTime: elapsedTime, id: id)
        timer.isPaused = isPaused
        
        return timer
    }
}
