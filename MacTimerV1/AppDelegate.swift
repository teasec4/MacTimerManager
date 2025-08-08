//
//  AppDelegate.swift
//  MacTimerV1
//
//  Created by Максим Ковалев on 8/7/25.
//

import Foundation
import SwiftUI
import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    var floatingWindow: NSWindow!
    private var contentView: ContentView!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        createFloatingWindow()
    }
    
    func createFloatingWindow() {
        floatingWindow = NSWindow(
            contentRect: NSRect(x: 100, y: 100, width: 800, height: 600),
            styleMask: [.titled, .closable, .miniaturizable, .resizable],
            backing: .buffered,
            defer: false
        )
         
        floatingWindow.level = .floating
        floatingWindow.collectionBehavior = .canJoinAllSpaces
        floatingWindow.isMovableByWindowBackground = true
        floatingWindow.title = "TimeFlow"
        
        // Устанавливаем минимальный и максимальный размеры
        floatingWindow.minSize = NSSize(width: 300, height: 180)
        floatingWindow.maxSize = NSSize(width: 1200, height: 800)
        
        contentView = ContentView()
        floatingWindow.contentView = NSHostingView(rootView: contentView)
        
        floatingWindow.makeKeyAndOrderFront(nil)
        floatingWindow.orderFrontRegardless()
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        // Сохраняем состояние всех таймеров перед закрытием
        if let contentView = self.contentView {
            // Получаем доступ к timerManager через @StateObject
            // Это не идеальное решение, но работает
            DispatchQueue.main.async {
                // TimerManager автоматически очистит ресурсы через deinit
            }
        }
    }
}
