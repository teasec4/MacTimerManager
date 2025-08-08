//
//  TimerManager.swift
//  MacTimerV1
//
//  Created by Максим Ковалев on 8/8/25.
//

import Foundation
import SwiftUI
import Combine

class TimerManager: ObservableObject {
    @Published var timers: [TimerModel] = []
    
    init() {
        // Больше не создаем дефолтный таймер в init, сделаем это в loadTimers()
    }
    
    func addTimer(name: String, icon: String) {
        let newTimer = TimerModel(name: name, icon: icon)
        timers.append(newTimer)
        saveTimers()
    }
    
    func removeTimer(_ timer: TimerModel) {
        // Останавливаем и очищаем ресурсы таймера
        timer.cleanup()
        
        if let index = timers.firstIndex(where: { $0.id == timer.id }) {
            timers.remove(at: index)
            saveTimers()
        }
    }
    
    func saveTimers() {
        let timerData = timers.map { timer in
            timer.toDictionary()
        }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: timerData, options: [])
            UserDefaults.standard.set(data, forKey: "SavedTimers")
        } catch {
            print("Failed to save timers: \(error)")
        }
    }
    
    func loadTimers() {
        // Сначала очищаем все активные таймеры
        stopAllTimers()
        
        if let data = UserDefaults.standard.data(forKey: "SavedTimers") {
            do {
                if let timerArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                    timers = timerArray.compactMap { TimerModel.fromDictionary($0) }
                }
            } catch {
                print("Failed to load timers: \(error)")
                timers = []
            }
        }
        
        // Если нет сохраненных таймеров, создаем дефолтный
        if timers.isEmpty {
            timers.append(TimerModel(name: "Work", icon: "💻"))
            saveTimers() // Сохраняем дефолтный таймер
        }
    }
    
    // MARK: - Cleanup methods
    
    func stopAllTimers() {
        for timer in timers {
            timer.cleanup()
        }
    }
    
    deinit {
        stopAllTimers()
    }
}
