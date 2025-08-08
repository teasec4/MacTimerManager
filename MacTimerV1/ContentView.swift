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
        .onChange(of: windowManager.isCompactMode) { newValue in
            // Автоматически выбираем первый запущенный таймер или первый в списке
            if newValue && selectedTimer == nil && !timerManager.timers.isEmpty {
                selectedTimer = sortedTimers.first(where: { $0.isRunning }) ?? sortedTimers.first
            }
        }
    }
    
    // MARK: - Full Mode View
    @ViewBuilder
    private var fullModeView: some View {
        HStack(spacing: 0) {
            // Sidebar
            VStack(spacing: 0) {
                // Заголовок сайдбара
//                HStack {
//                    Text("Timers")
//                        .font(.title2)
//                        .fontWeight(.bold)
//                    
//                    Spacer()
//                    
//                    // Кнопка компактного режима (сделаем её более заметной)
//                    Button {
//                        windowManager.setCompactMode(true)
//                    } label: {
//                        HStack(spacing: 4) {
//                            Image(systemName: "rectangle.compress.vertical")
//                                .font(.system(size: 14))
//                            Text("Compact")
//                                .font(.caption)
//                        }
//                        .padding(.horizontal, 8)
//                        .padding(.vertical, 4)
//                        .background(Color.accentColor.opacity(0.1))
//                        .cornerRadius(6)
//                    }
//                    .buttonStyle(.plain)
//                    .help("Switch to Compact Mode")
//                }
//                .padding(.horizontal, 16)
//                .padding(.vertical, 12)
//                .background(Color(NSColor.controlBackgroundColor))
//                
//                Divider()
                
                // Тулбар сортировки
                HStack {
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
                        HStack {
                            Image(systemName: sortOption.icon)
                            Text(sortOption.rawValue)
                            Image(systemName: "chevron.down")
                                .font(.caption)
                        }
                        .font(.caption)
                        .foregroundColor(.secondary)
                    }
                    .buttonStyle(.plain)
                    
                    Spacer()
                    
                    // Дополнительная кнопка компактного режима в тулбаре
                    
                    
                    // Быстрые действия
                    HStack(spacing: 8) {
                        Button{
                            showingAddTimer = true
                        } label: {
                            Image(systemName: "plus")
                                .font(.system(size: 14))
                        }
                        .buttonStyle(.plain)
                        
                        Button {
                            windowManager.setCompactMode(true)
                        } label: {
                            Image(systemName: "arrow.down.right.and.arrow.up.left")
                                .font(.system(size: 12))
                        }
                        .buttonStyle(.plain)
                        .help("Compact Mode")
                        
                        
                        Button{
                            showingSettings = true
                        } label: {
                            Image(systemName: "gear")
                                .font(.system(size: 14))
                        }
                        .buttonStyle(.plain)
                        
                        
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color(NSColor.controlBackgroundColor))
                
                Divider()
                
                // Список таймеров
                ScrollView {
                    LazyVStack(spacing: 2) {
                        ForEach(sortedTimers) { timer in
                            TimerListRowView(timer: timer, timerManager: timerManager)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(selectedTimer?.id == timer.id ?
                                            Color.accentColor.opacity(0.15) :
                                            Color.clear)
                                )
                                .contentShape(Rectangle()) // Делает всю область кликабельной
                                .onTapGesture {
                                    selectedTimer = timer
                                }
                                .animation(.easeInOut(duration: 0.2), value: selectedTimer?.id)
                        }
                    }
                    .padding(.vertical, 8)
                }
                .background(Color(NSColor.textBackgroundColor))
            }
            .frame(width: 180)
            .background(Color(NSColor.controlBackgroundColor))
            
            Divider()
            
            // Detail View
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
                            Text("\(timer.icon) \(timer.name)")
                            .tag(timer as TimerModel?)
                        }
                    }
                    .pickerStyle(.menu)
                    .frame(maxWidth: 160)
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
        // Этот код больше не используется, но оставляем для совместимости
        EmptyView()
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
//            HStack(spacing: 8) {
//                Text(timer.icon)
//                    .font(.title2)
//                
//                Text(timer.name)
//                    .font(.headline)
//                    .lineLimit(1)
//                
//                Spacer()
//                
//                // Статус индикатор
//                if timer.isRunning {
//                    Circle()
//                        .fill(Color.green)
//                        .frame(width: 8, height: 8)
//                } else if timer.isPaused {
//                    Circle()
//                        .fill(Color.orange)
//                        .frame(width: 8, height: 8)
//                }
//            }
            Spacer()
            // Большое время
            Text(timer.formattedTime)
                .font(.system(size: 42, weight: .thin, design: .monospaced))
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
            Spacer()
        }
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}



#Preview {
    ContentView()
}
