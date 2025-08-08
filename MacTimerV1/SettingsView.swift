//
//  SettingsView.swift
//  MacTimerV1
//
//  Created by Максим Ковалев on 8/8/25.
//

import Foundation
import SwiftUI

struct SettingsView: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Settings")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Settings will be implemented here")
                .foregroundColor(.secondary)
            
            Button("Close") {
                isPresented = false
            }
        }
        .padding(40)
        .frame(width: 300, height: 200)
    }
}
