import SwiftUI
import Cocoa

@main
struct MacTimerV1App: App {
    // Привязываем AppDelegate к SwiftUI App Lifecycle
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}
