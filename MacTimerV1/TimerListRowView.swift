//
//  TimerListRowView.swift
//  MacTimerV1
//
//  Created by Максим Ковалев on 8/8/25.
//

import Foundation
import SwiftUI

struct TimerListRowView: View {
    @ObservedObject var timer: TimerModel
    let timerManager: TimerManager
    
    var body: some View {
        HStack {
            // Иконка и статус
            ZStack {
                Text(timer.icon)
                    .font(.title3)
                
                // Индикатор активности
                if timer.isRunning {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 8, height: 8)
                        .offset(x: 12, y: -12)
                }
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(timer.name)
                    .font(.headline)
                    .lineLimit(1)
                
                HStack {
                    Text(timer.formattedTime)
                        .font(.caption)
                        .foregroundColor(timer.isRunning ? .blue : .secondary)
                    
                    if timer.isRunning {
                        Text("• Running")
                            .font(.caption2)
                            .foregroundColor(.green)
                    } else if timer.isPaused {
                        Text("• Paused")
                            .font(.caption2)
                            .foregroundColor(.orange)
                    }
                }
            }
            
            Spacer()
            
            // Быстрые кнопки управления
            HStack(spacing: 4) {
                Button {
                    if timer.isRunning {
                        timer.pause()
                    } else {
                        timer.start()
                    }
                } label: {
                    Image(systemName: timer.isRunning ? "pause.fill" : "play.fill")
                        .font(.caption)
                        .foregroundColor(timer.isRunning ? .orange : .green)
                }
                .buttonStyle(.plain)
                
                Button {
                    timer.stop()
                } label: {
                    Image(systemName: "stop.fill")
                        .font(.caption)
                        .foregroundColor(.red)
                }
                .buttonStyle(.plain)
                .opacity(timer.elapsedTime > 0 ? 1 : 0.3)
                .disabled(timer.elapsedTime <= 0)
            }
        }
        .contextMenu {
            Button("Start/Pause") {
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
        .padding(.vertical, 2)
    }
}
