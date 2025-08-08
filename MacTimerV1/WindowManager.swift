//
//  WindowManager.swift
//  MacTimerV1
//
//  Created by Максим Ковалев on 8/8/25.
//

import Foundation
import Cocoa
import SwiftUI
import Combine

class WindowManager: ObservableObject {
    static let shared = WindowManager()
    
    @Published var isCompactMode: Bool = false
    
    private let fullSize = NSSize(width: 800, height: 600)
    private let compactSize = NSSize(width: 320, height: 200)
    
    private init() {}
    
    func toggleCompactMode() {
        guard let window = NSApp.keyWindow else { return }
        
        isCompactMode.toggle()
        
        let targetSize = isCompactMode ? compactSize : fullSize
        let currentFrame = window.frame
        
        // Центрируем новое окно относительно текущего
        let newOriginX = currentFrame.origin.x + (currentFrame.width - targetSize.width) / 2
        let newOriginY = currentFrame.origin.y + (currentFrame.height - targetSize.height) / 2
        
        let newFrame = NSRect(
            x: newOriginX,
            y: newOriginY,
            width: targetSize.width,
            height: targetSize.height
        )
        
        // Анимированное изменение размера
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.3
            context.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            window.animator().setFrame(newFrame, display: true)
        })
        
        // Изменяем заголовок окна
        window.title = isCompactMode ? "TimeFlow - Compact" : "TimeFlow"
    }
    
    func setCompactMode(_ compact: Bool) {
        if isCompactMode != compact {
            toggleCompactMode()
        }
    }
}
