//
//  HistoryByTimerView.swift
//  MacTimerV1
//
//  Created by Максим Ковалев on 9/24/25.
//
import SwiftUI

struct HistoryByTimerView: View {
    @ObservedObject var manager: TimerManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(manager.timers) { timer in
                MiniCalendarView(manager: manager,timer: timer)
            }
        }
        .padding()
        .navigationTitle("History")
    }
}
