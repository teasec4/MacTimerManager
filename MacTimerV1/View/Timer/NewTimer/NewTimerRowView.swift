//
//  NewTimerRowView.swift
//  MacTimerV1
//
//  Created by Максим Ковалев on 8/8/25.
//

import Foundation
import SwiftUI

struct NewTimerRowView: View {
    var action: () -> Void
    
    var body: some View {
        HStack {
            // Пустая иконка с серым фоном
            ZStack {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 28, height: 28)
                Text("+")
                    .font(.headline)
                    .foregroundColor(Color.gray)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Create New Timer")
                    .font(.headline)
                    .foregroundColor(Color.gray)
                    .lineLimit(1)
                
                Text("Tap to add a timer")
                    .font(.caption)
                    .foregroundColor(Color.gray.opacity(0.7))
            }
            
            Spacer()
        }
        .contentShape(Rectangle()) // чтобы тап был по всей области
        .onTapGesture {
            action()
        }
    }
}
