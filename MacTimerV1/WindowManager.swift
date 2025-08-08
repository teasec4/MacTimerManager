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
    
    private let fullSize = NSSize(width: 400, height: 400)
    private let compactSize = NSSize(width: 240, height: 230)
    
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
            x: max(0, newOriginX), // Не даем окну уйти за край экрана
            y: max(0, newOriginY),
            width: targetSize.width,
            height: targetSize.height
        )
        
        // Устанавливаем ограничения размера окна в зависимости от режима
        if isCompactMode {
            window.minSize = NSSize(width: 300, height: 180)
            window.maxSize = NSSize(width: 400, height: 250)
        } else {
            window.minSize = NSSize(width: 600, height: 400)
            window.maxSize = NSSize(width: 1200, height: 800)
        }
        
        // Анимированное изменение размера
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.4
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
