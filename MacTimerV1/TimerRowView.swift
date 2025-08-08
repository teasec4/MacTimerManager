//
//  TimerRowView.swift
//  MacTimerV1
//
//  Created by Максим Ковалев on 8/7/25.
//

import Foundation
import SwiftUI

struct TimerRowView: View {
    @ObservedObject var timer: TimerModel
    let timerManager: TimerManager
    
    var body: some View {
        VStack{
            HStack{
                Text(timer.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                Image(systemName: "slider.horizontal.3")
                
            }
            
            Divider()
            VStack{
                
                
                Spacer()
                
                // Center section: Timer Display
                Text(timer.formattedTime)
                    .font(.system(size: 38, weight: .medium, design: .monospaced))
                    .foregroundColor(timer.isRunning ? Color.blue : Color.gray)
                    .frame(minWidth: 120, alignment: .center)
                
                Spacer()
                
                // Right section: Control Buttons
                ZStack {
                    if !timer.isRunning {
                        HStack {
                            Button(action: {
                                withAnimation {
                                    timer.start()
                                }
                            }) {
                                Image(systemName: "play.fill")
                                    .foregroundColor(.white)
                                    .frame(minWidth: 60)
                                    .padding()
                                    .background(Color.secondary)
                                    .clipShape(RoundedRectangle(cornerRadius: 16))
                                
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            
                            
                            Button(action: {
                                withAnimation {
                                    timer.stop()
                                }
                            }) {
                                Image(systemName: "stop.fill")
                                    .foregroundColor(.white)
                                    .frame(minWidth: 60)
                                    .padding()
                                    .background(Color.secondary)
                                    .clipShape(RoundedRectangle(cornerRadius: 16))
                                
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                        }
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                    
                    if timer.isRunning {
                        HStack {
                            Button(action: {
                                withAnimation {
                                    timer.pause()
                                }
                            }) {
                                Image(systemName: "pause.fill")
                                    .foregroundStyle(.white)
                                    .frame(minWidth: 120)
                                    .padding()
                                    .background(Color.secondary)
                                    .clipShape(RoundedRectangle(cornerRadius: 16))
                                
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                        }
                        .transition(.opacity)
                    }
                }
                .animation(.easeInOut(duration: 0.2), value: timer.isRunning)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
        .contextMenu{
            Button("Delete Timer", role: .destructive){
                timerManager.removeTimer(timer)
            }
        }
    }
}

#Preview {
    ContentView()
}
