//
//  AddTimerView.swift
//  MacTimerV1
//
//  Created by Максим Ковалев on 8/8/25.
//

import Foundation
import SwiftUI

struct AddTimerView: View {
    @ObservedObject var timerManager: TimerManager
    @Binding var isPresented: Bool
    
    @State private var timerName: String = ""
    @State private var selectedIcon: String = "💻"
    
    let availableIcons = ["💻", "📚", "🏃‍♂️", "🎨", "📝", "☕", "💡", "📱", "🔧", "🎵", "🧘‍♂️", "📊"]
    
    var body: some View {
        VStack(spacing:12){
            Text("Add New Timer")
                .font(.headline)
                .padding()
            
            TextField("Timer name", text: $timerName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onSubmit {
                    if canSave {
                        saveTimer()
                    }
                }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Choose Icon:")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 6), spacing: 8) {
                    ForEach(availableIcons, id: \.self) { icon in
                        Button(action: {
                            selectedIcon = icon
                        }) {
                            Text(icon)
                                .font(.title2)
                                .frame(width: 40, height: 40)
                                .background(selectedIcon == icon ? Color.blue.opacity(0.3) : Color.gray.opacity(0.1))
                                .cornerRadius(8)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            
            HStack(spacing: 12) {
                Button("Cancel") {
                    isPresented = false
                }
                .keyboardShortcut(.escape)
                
                Button("Add Timer") {
                    saveTimer()
                }
                .disabled(!canSave)
                .keyboardShortcut(.return)
            }
            .padding(.bottom)
        }
        
        .padding()
        .frame(width: 300, height: 280)
        .onAppear {
            timerName = ""
            selectedIcon = availableIcons.randomElement() ?? "💻"
        }
    }
    
    private var canSave: Bool {
        !timerName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private func saveTimer() {
        let cleanName = timerName.trimmingCharacters(in: .whitespacesAndNewlines)
        timerManager.addTimer(name: cleanName, icon: selectedIcon)
        isPresented = false
    }
}


