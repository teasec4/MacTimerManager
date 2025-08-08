//
//  TimerModel.swift
//  MacTimerV1
//
//  Created by Максим Ковалев on 8/7/25.
//

import Foundation
import Combine

class TimerModel: ObservableObject, Identifiable{
    let id = UUID()
    @Published var name: String
    @Published var icon: String
    @Published var elapsedTime: TimeInterval = 0
    @Published var isRunning: Bool = false
    @Published var isPaused: Bool = false
    
    private var startTime: Date?
    private var timer: Timer?
    
    init(name: String, icon: String) {
        self.name = name
        self.icon = icon
    }
    
    func start(){
        if isPaused{
            // continue
            startTime = Date().addingTimeInterval(-elapsedTime)
            isPaused = false
        } else {
            // new start
            startTime = Date()
            elapsedTime = 0
        }
        
        isRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true){ _ in
            if let startTime = self.startTime{
                self.elapsedTime = Date().timeIntervalSince(startTime)
            }
        }
    }
    
    func pause(){
        timer?.invalidate()
        timer = nil
        isRunning = false
        isPaused = true
    }
    
    func stop(){
        timer?.invalidate()
        timer = nil
        isRunning = false
        isPaused = false
        elapsedTime = 0
        startTime = nil
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
}
