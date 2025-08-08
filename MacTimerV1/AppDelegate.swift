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
    
    func applicationDidFinishLaunching(_ aNotification: Notification){
        createFloatingWindow()
    }
    
    func  createFloatingWindow(){
        floatingWindow = NSWindow(
            contentRect: NSRect(x:100, y:100, width:320,height: 200),
            styleMask: [.titled, .closable, .miniaturizable],
            backing: .buffered,
            defer: false
        )
         
        floatingWindow.level = .floating
        floatingWindow.collectionBehavior = .canJoinAllSpaces
        floatingWindow.isMovableByWindowBackground = true
        floatingWindow.title = "TimeFlow"
        
        let contentView = ContentView()
        floatingWindow.contentView = NSHostingView(rootView: contentView)
        
        floatingWindow.makeKeyAndOrderFront(nil)
        floatingWindow.orderFrontRegardless()
    
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
            return true
        }
}
