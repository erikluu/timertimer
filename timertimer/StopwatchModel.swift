import Foundation
import Combine

class Stopwatch: ObservableObject, Identifiable {
    @Published var isRunning = false
    @Published var totalElapsed: TimeInterval = 0
    @Published var lapElapsed: TimeInterval = 0
    @Published var lapTimes: [TimeInterval] = []
    
    private var startTime: Date?
    private var lastLapTime: Date?
    private var timer: Timer?
    
    func start() {
        if timer == nil {
            startTime = Date()
            lastLapTime = startTime
        }
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
            DispatchQueue.main.async {
                self.updateElapsedTime()
            }
        }
        isRunning = true
    }
    
    func reset() {
        timer?.invalidate()
        timer = nil
        totalElapsed = 0
        lapElapsed = 0
        lapTimes.removeAll()
    }
        
    func stop() {
        timer?.invalidate()
        isRunning = false
    }
    
    func lap() {
        lapTimes.append(lapElapsed)
        lastLapTime = Date()
        lapElapsed = 0
    }
    
    // ========================================================================
    
    private func updateElapsedTime() {
        if let start = startTime, let lastLap = lastLapTime {
            totalElapsed = Date().timeIntervalSince(start)
            lapElapsed = Date().timeIntervalSince(lastLap)
        }
    }
}
