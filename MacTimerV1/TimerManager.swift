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
    
    init(){
        timers.append(TimerModel(name: "Work", icon: "💻"))
    }
    
    func addTimer(name:String, icon:String){
        let newTimer = TimerModel(name: name, icon: icon)
        timers.append(newTimer)
        saveTimers()
    }
    
    func removeTimer(_ timer:TimerModel){
        timer.stop()
        if let index = timers.firstIndex(where: {$0.id == timer.id}){
            timers.remove(at: index)
            saveTimers()
        }
    }
    
    func saveTimers(){
        let timerData = timers.map {timer in
                [
                    "name" : timer.name,
                    "icon" : timer.icon
                ]
        }
        UserDefaults.standard.set(timerData, forKey: "SavedTimers")
    }
    
    func loadTimers(){
        if let savedData = UserDefaults.standard.array(forKey: "SavedTimers") as?[[String:String]] {
            timers = savedData.compactMap {data in
                guard let name = data["name"], let icon = data["icon"] else {return nil}
                return TimerModel(name:name, icon:icon)
            }
        }
        
        if timers.isEmpty{
            timers.append(TimerModel(name:"Work", icon:"💻"))
        }
    }
    
}
