import Foundation
import Combine

@MainActor
class TimerModel: ObservableObject, Identifiable, Codable {
    enum State: String, Codable {
        case stopped, running, paused
    }
    
    let id: UUID
    @Published var name: String
    @Published var icon: String
    @Published var elapsedTime: TimeInterval
    @Published var state: State
    
    private var timer: Timer?
    private var startDate: Date?
    
    // MARK: - Init
    init(id: UUID = UUID(),
         name: String,
         icon: String,
         elapsedTime: TimeInterval = 0,
         state: State = .stopped) {
        self.id = id
        self.name = name
        self.icon = icon
        self.elapsedTime = elapsedTime
        self.state = state
    }
    
    // MARK: - Control
    @MainActor
    func start() {
        guard state != .running else { return }

        if state == .paused {
            startDate = Date().addingTimeInterval(-elapsedTime)
        } else {
            startDate = Date()
            elapsedTime = 0
        }

        state = .running

        // Сначала убьём старый таймер, если был
        timer?.invalidate()

        // Создаём новый и добавляем в common run loop mode
        let t = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            Task { @MainActor in
                guard let self = self, let startDate = self.startDate else { return }
                self.elapsedTime = Date().timeIntervalSince(startDate)
            }
        }
        RunLoop.main.add(t, forMode: .common)
        timer = t
    }
    
    @MainActor
    func pause() {
        guard state == .running else { return }
        timer?.invalidate()
        timer = nil
        state = .paused
    }

    @MainActor
    func stop() {
        timer?.invalidate()
        timer = nil
        startDate = nil
        elapsedTime = 0
        state = .stopped
    }

    deinit {
        timer?.invalidate()
    }
    
    // MARK: - Codable
    enum CodingKeys: String, CodingKey {
        case id, name, icon, elapsedTime, state
    }
    
    required convenience init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        let id = try c.decode(UUID.self, forKey: .id)
        let name = try c.decode(String.self, forKey: .name)
        let icon = try c.decode(String.self, forKey: .icon)
        let elapsedTime = try c.decode(TimeInterval.self, forKey: .elapsedTime)
        let state = try c.decode(State.self, forKey: .state)
        self.init(id: id, name: name, icon: icon, elapsedTime: elapsedTime, state: state)
    }
    
    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(id, forKey: .id)
        try c.encode(name, forKey: .name)
        try c.encode(icon, forKey: .icon)
        try c.encode(elapsedTime, forKey: .elapsedTime)
        try c.encode(state, forKey: .state)
    }
    
    // MARK: - UI Helpers
    var formattedTime: String {
        let h = Int(elapsedTime) / 3600
        let m = (Int(elapsedTime) % 3600) / 60
        let s = Int(elapsedTime) % 60
        return h > 0 ? String(format: "%02d:%02d:%02d", h, m, s)
                     : String(format: "%02d:%02d", m, s)
    }
}

extension TimerModel {
    var isRunning: Bool { state == .running }
    var isPaused: Bool { state == .paused }
}
