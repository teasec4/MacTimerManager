//
//  ContentView.swift
//  MacTimerV1
//
//  Created by Максим Ковалев on 8/7/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var timerManager = TimerManager()
    @StateObject private var windowManager = WindowManager.shared
    @State private var showingAddTimer = false
    @State private var showingSettings = false
    @State private var selectedTimer: TimerModel?
    @State private var sortOption: SortOption = .name
    
    enum SortOption: String, CaseIterable {
        case name = "Name"
        case timeElapsed = "Time"
        case status = "Status"
        
        var icon: String{
            switch self{
            case .name: return "textformat.abc"
            case .timeElapsed: return "clock"
            case .status: return "circle.fill"
            }
        }
    }
    
    var sortedTimers: [TimerModel] {
        switch sortOption {
        case .name:
            return timerManager.timers.sorted { $0.name < $1.name }
        case .timeElapsed:
            return timerManager.timers.sorted { $0.elapsedTime > $1.elapsedTime }
        case .status:
            return timerManager.timers.sorted { timer1, timer2 in
                // Сначала активные таймеры
                if timer1.isRunning && !timer2.isRunning {
                    return true
                }
                if !timer1.isRunning && timer2.isRunning {
                    return false
                }
                
                // Потом приостановленные
                if timer1.isPaused && !timer2.isPaused && !timer2.isRunning {
                    return true
                }
                if !timer1.isPaused && timer2.isPaused && !timer1.isRunning {
                    return false
                }
                
                // Если статусы одинаковые, сортируем по имени
                return timer1.name < timer2.name
            }
        }
    }
    
    var body: some View {
        Group {
            if windowManager.isCompactMode {
                compactModeView
            } else {
                fullModeView
            }
        }
        .onAppear{
            timerManager.loadTimers()
        }
        .sheet(isPresented:$showingAddTimer){
            AddTimerView(timerManager:timerManager, isPresented: $showingAddTimer)
        }
        .sheet(isPresented:$showingSettings){
            SettingsView(isPresented:$showingSettings)
        }
    }
    
    // MARK: - Full Mode View
    @ViewBuilder
    private var fullModeView: some View {
        NavigationSplitView{
            sidebarContent
        } detail: {
            detailContent
        }
    }
    
    // MARK: - Compact Mode View
    @ViewBuilder
    private var compactModeView: some View {
        VStack(spacing: 0) {
            // Компактная панель инструментов
            HStack {
                // Кнопка возврата к полному режиму
                Button {
                    windowManager.setCompactMode(false)
                } label: {
                    Image(systemName: "sidebar.left")
                        .font(.system(size: 14))
                }
                .buttonStyle(.plain)
                .help("Show Sidebar")
                
                Spacer()
                
                // Селектор таймера
                if !timerManager.timers.isEmpty {
                    Picker("Timer", selection: $selectedTimer) {
                        ForEach(sortedTimers) { timer in
                            HStack {
                                Text(timer.icon)
                                Text(timer.name)
                            }
                            .tag(timer as TimerModel?)
                        }
                    }
                    .pickerStyle(.menu)
                    .frame(maxWidth: 150)
                }
                
                Spacer()
                
                // Быстрые действия
                HStack(spacing: 8) {
                    Button {
                        showingAddTimer = true
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 14))
                    }
                    .buttonStyle(.plain)
                    .help("Add Timer")
                    
                    Button {
                        showingSettings = true
                    } label: {
                        Image(systemName: "gear")
                            .font(.system(size: 14))
                    }
                    .buttonStyle(.plain)
                    .help("Settings")
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color(NSColor.controlBackgroundColor))
            
            // Компактный вид таймера
            if let selectedTimer = selectedTimer {
                CompactTimerView(timer: selectedTimer, timerManager: timerManager)
            } else {
                VStack(spacing: 16) {
                    Image(systemName: "clock.badge.plus")
                        .font(.system(size: 40))
                        .foregroundColor(.secondary)
                    
                    Text("No Timer Selected")
                        .font(.title3)
                        .foregroundColor(.secondary)
                    
                    if timerManager.timers.isEmpty {
                        Button("Create Your First Timer") {
                            showingAddTimer = true
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
    
    @ViewBuilder
    private var sidebarContent: some View {
        List(selection:$selectedTimer){
            ForEach(sortedTimers) {timer in
                TimerListRowView(timer:timer, timerManager: timerManager)
                    .tag(timer)
            }
        }
        .navigationTitle("Timers")
        .toolbar{
            ToolbarItemGroup(placement: .primaryAction){
                // Кнопка компактного режима
                Button {
                    windowManager.setCompactMode(true)
                } label: {
                    Image(systemName: "sidebar.left.badge.minus")
                }
                .help("Compact Mode")
                
                Menu{
                    ForEach(SortOption.allCases, id:\.self){option in
                        Button{
                            sortOption = option
                        } label: {
                            HStack{
                                Image(systemName:option.icon)
                                Text(option.rawValue)
                                if sortOption == option{
                                    Image(systemName:"checkmark")
                                }
                            }
                        }
                    }
                } label: {
                    Image(systemName: "arrow.up.arrow.down")
                } primaryAction: {
                    sortOption = sortOption == .name ? .timeElapsed : .name
                }
                
                // Settings
                Button{
                    showingSettings = true
                } label: {
                    Image(systemName: "gear")
                }
                
                // Add a new timer
                Button{
                    showingAddTimer = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .frame(minWidth: 200)
    }
    
    
    @ViewBuilder
    private var detailContent: some View {
        if let selectedTimer = selectedTimer {
            TimerDetailView(timer:selectedTimer, timerManager:timerManager)
        } else {
            VStack(spacing: 20) {
                Image(systemName: "clock.badge.plus")
                    .font(.system(size: 60))
                    .foregroundColor(.secondary)
                
                Text("Select a Timer")
                    .font(.title2)
                    .foregroundColor(.secondary)
                
                Text("Choose a timer from the sidebar to view details and controls")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
                    .frame(maxWidth: 300)
                
                if timerManager.timers.isEmpty {
                    Button("Create Your First Timer") {
                        showingAddTimer = true
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

// MARK: - Compact Timer View
struct CompactTimerView: View {
    @ObservedObject var timer: TimerModel
    let timerManager: TimerManager
    
    var body: some View {
        VStack(spacing: 12) {
            // Заголовок с иконкой и именем
            HStack(spacing: 8) {
                Text(timer.icon)
                    .font(.title2)
                
                Text(timer.name)
                    .font(.headline)
                    .lineLimit(1)
                
                Spacer()
                
                // Статус индикатор
                if timer.isRunning {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 8, height: 8)
                } else if timer.isPaused {
                    Circle()
                        .fill(Color.orange)
                        .frame(width: 8, height: 8)
                }
            }
            
            // Большое время
            Text(timer.formattedTime)
                .font(.system(size: 36, weight: .thin, design: .monospaced))
                .foregroundColor(timer.isRunning ? .blue : .primary)
                .monospacedDigit()
            
            // Компактные кнопки управления
            HStack(spacing: 12) {
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        if timer.isRunning {
                            timer.pause()
                        } else {
                            timer.start()
                        }
                    }
                } label: {
                    Image(systemName: timer.isRunning ? "pause.fill" : "play.fill")
                        .font(.system(size: 18))
                        .foregroundColor(timer.isRunning ? .orange : .green)
                        .frame(width: 32, height: 32)
                        .background(Color.secondary.opacity(0.1))
                        .cornerRadius(8)
                }
                .buttonStyle(.plain)
                
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        timer.stop()
                    }
                } label: {
                    Image(systemName: "stop.fill")
                        .font(.system(size: 18))
                        .foregroundColor(.red)
                        .frame(width: 32, height: 32)
                        .background(Color.secondary.opacity(0.1))
                        .cornerRadius(8)
                }
                .buttonStyle(.plain)
                .disabled(timer.elapsedTime <= 0)
                .opacity(timer.elapsedTime > 0 ? 1 : 0.3)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
