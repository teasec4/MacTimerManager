//
//  MiniCalendarView.swift
//  MacTimerV1
//
//  Created by Максим Ковалев on 9/24/25.
//
import SwiftUI

struct MiniCalendarView: View {
    @ObservedObject var manager: TimerManager
    let timer: TimerModel
    
    private let cal = Calendar.current
    
    private var last7Days: [Date] {
        let today = cal.startOfDay(for: Date())
        return (0..<7).compactMap { cal.date(byAdding: .day, value: -$0, to: today) }.reversed()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // подпись таймера
            Text("\(timer.icon) \(timer.name)")
                .font(.headline)
            
            VStack(spacing: 4) {
                // ряд с датами сверху
                HStack(spacing: 6) {
                    ForEach(last7Days, id: \.self) { day in
                        Text(shortDate(day))
                            .font(.caption2)
                            .foregroundColor(.secondary)
                            .frame(width: 22)
                    }
                }
                
                // ряд с квадратиками
                HStack(spacing: 6) {
                    let totals = manager.dailyTotals(for: timer)
                    ForEach(last7Days, id: \.self) { day in
                        RoundedRectangle(cornerRadius: 4)
                            .fill(color(for: totals[day] ?? 0))
                            .frame(width: 22, height: 22)
                            .help("\(fullDate(day)) — \(formatDuration(totals[day] ?? 0))")
                    }
                }
            }
        }
        .padding(.vertical, 6)
    }
    
    private func color(for t: TimeInterval) -> Color {
        switch t {
        case 0:         return .gray.opacity(0.18)
        case ..<1800:   return .green.opacity(0.4)  // < 30m
        case ..<3600:   return .green.opacity(0.7)  // < 1h
        default:        return .green                // ≥ 1h
        }
    }
    
    private func shortDate(_ d: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "E" // Mon, Tue...
        return f.string(from: d)
    }
    
    private func fullDate(_ d: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "E, d MMM"
        return f.string(from: d)
    }
    
    private func formatDuration(_ t: TimeInterval) -> String {
        let h = Int(t) / 3600
        let m = (Int(t) % 3600) / 60
        return h > 0 ? "\(h)h \(m)m" : "\(m)m"
    }
}
