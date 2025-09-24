//
//  CompactTimerDetailView.swift
//  MacTimerV1
//
//  Created by Максим Ковалев on 9/24/25.
//
import SwiftUI

struct CompactTimerDetailView: View {
    @ObservedObject var timer: TimerModel
    
    var body: some View {
        VStack(spacing: 16) {
            Text(timer.formattedTime)
                .font(.system(size: 48, weight: .thin, design: .monospaced))
                .foregroundColor(timer.isRunning ? .blue : .primary)
                .monospacedDigit()
            
            HStack(spacing: 20) {
                Button(timer.isRunning ? "Pause" : "Start") {
                    timer.isRunning ? timer.pause() : timer.start()
                }
                .buttonStyle(.borderedProminent)
                
                Button("Stop") {
                    timer.stop()
                }
                .buttonStyle(.bordered)
                .disabled(timer.elapsedTime == 0)
            }
        }
        .padding()
    }
}
