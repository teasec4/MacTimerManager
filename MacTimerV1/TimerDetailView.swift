//
//  TimerDetailView.swift
//  MacTimerV1
//
//  Created by Максим Ковалев on 8/8/25.
//

import Foundation
import SwiftUI

struct TimerDetailView: View {
    @ObservedObject var timer: TimerModel
    let timerManager: TimerManager
    
    var body: some View {
        VStack(spacing: 30) {
            // Заголовок с иконкой и названием
            HStack {
                Text(timer.icon)
                    .font(.system(size: 50))
                
                VStack(alignment: .leading) {
                    Text(timer.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text(statusText)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            .padding(.horizontal)
            .background(Color(.gray.opacity(0.1)))
            
            Spacer()
            
            // Большой дисплей времени
            Text(timer.formattedTime)
                .font(.system(size: 72, weight: .thin, design: .monospaced))
                .foregroundColor(timer.isRunning ? .blue : .primary)
                .monospacedDigit()
            
            // Кнопки управления
            HStack(spacing: 20) {
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        if timer.isRunning {
                            timer.pause()
                        } else {
                            timer.start()
                        }
                    }
                } label: {
                    Label(timer.isRunning ? "Pause" : "Start",
                          systemImage: timer.isRunning ? "pause.fill" : "play.fill")
                        .frame(minWidth: 100)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        timer.stop()
                    }
                } label: {
                    Label("Stop", systemImage: "stop.fill")
                        .frame(minWidth: 100)
                }
                .buttonStyle(.bordered)
                .controlSize(.large)
                .disabled(timer.elapsedTime <= 0)
            }
            
            Spacer()
            
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(NSColor.textBackgroundColor))
    }
    
    private var statusText: String {
        if timer.isRunning {
            return "Running since \(formatStartTime())"
        } else if timer.isPaused {
            return "Paused"
        } else if timer.elapsedTime > 0 {
            return "Stopped"
        } else {
            return "Ready to start"
        }
    }
    
    private func formatStartTime() -> String {
        // Приблизительное время старта
        let startTime = Date().addingTimeInterval(-timer.elapsedTime)
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: startTime)
    }
    
    @ViewBuilder
    private var statisticsView: some View {
        VStack(spacing: 8) {
            Text("Session Statistics")
                .font(.headline)
                .foregroundColor(.secondary)
            
            HStack(spacing: 40) {
                statItem("Total Time", timer.formattedTime)
                statItem("Status", timer.isRunning ? "Active" : "Stopped")
            }
        }
        .padding()
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(12)
        .padding(.horizontal)
    }
    
    private func statItem(_ title: String, _ value: String) -> some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
        }
    }
}

#Preview {
    ContentView()
}
