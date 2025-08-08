//
//  ContentView.swift
//  MacTimerV1
//
//  Created by Максим Ковалев on 8/7/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var timerManager = TimerManager()
    @State private var showingAddTimer = false
    
    var body: some View {
        ScrollView{
            Button(action: {
                showingAddTimer = true
            }) {
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(.blue)
                    .font(.title2)
            }
            .buttonStyle(PlainButtonStyle())
            
            LazyVStack(spacing:8){
                ForEach(timerManager.timers){timer in
                    TimerRowView(timer: timer, timerManager: timerManager)
                }
            }
            .padding(.horizontal)
            
            if timerManager.timers.isEmpty {
                Button("+ Add Your First Timer") {
                    showingAddTimer = true
                }
                .padding()
                
            }
        }
        .padding()
        .frame(width: 320, height: 200)
        .background(Color(NSColor.windowBackgroundColor))
        .sheet(isPresented:$showingAddTimer){
            AddTimerView(timerManager:timerManager, isPresented: $showingAddTimer)
        }
        .onAppear{
            timerManager.loadTimers()
        }
    }
    
}



//#Preview {
//    ContentView()
//}
