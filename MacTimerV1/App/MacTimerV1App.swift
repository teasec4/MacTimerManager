import SwiftUI

@main
struct MacTimerV1App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowLevel(.floating)
        .windowResizability(.contentSize)
    }
}
