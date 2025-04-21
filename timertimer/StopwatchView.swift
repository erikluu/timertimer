//
//  StopwatchView.swift
//  timertimer
//
//  Created by Erik Luu on 4/19/25.
//
import SwiftUI

struct StopwatchView: View {
    @ObservedObject var stopwatch: Stopwatch
    
    var CIRCLE_WIDTH: CGFloat = 50
    var MAX_LAP_HEIGHT: CGFloat = 5 // Fixed height for lap times to prevent resizing
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 8) {
                // Large current lap time
                Text(formatTime(stopwatch.lapElapsed))
                    .font(.system(size: 36, weight: .medium, design: .monospaced))
                    .foregroundColor(.white)

                // Fixed height for lap times display (prevents resizing)
                VStack(spacing: 5) {
                    ScrollView(.horizontal, showsIndicators: true) {
                        HStack(spacing: 10) {
                            let lapCount = stopwatch.lapTimes.count
                            ForEach(Array(stopwatch.lapTimes.reversed().enumerated()), id: \.offset) { i, lap in
                                Text("Lap \(lapCount - i): \(formatTime(lap))")
                                    .font(.footnote)
                                    .foregroundColor(colorForLap(at: i))
                                    .frame(height: 20) // Consistent height for each lap time
                            }
                        }
                    }
                }
                .frame(height: MAX_LAP_HEIGHT) // Set a fixed height for lap times area
            }
            .padding(.leading)
            
            Spacer()
            
            // Control Buttons
            HStack(spacing: 12) {
                Button(action: {
                    stopwatch.isRunning ? stopwatch.stop() : stopwatch.start()
                }) {
                    Text(stopwatch.isRunning ? "Stop" : "Start")
                        .foregroundColor(stopwatch.isRunning ? .red : .green)
                        .frame(width: CIRCLE_WIDTH, height: CIRCLE_WIDTH)
                        .background(Circle().fill(Color.white.opacity(0.1)))
                        .overlay(Circle().stroke(stopwatch.isRunning ? Color.red : Color.green, lineWidth: 1))
                }
                
                Button(action: {
                    stopwatch.isRunning ? stopwatch.lap() : stopwatch.reset()
                }) {
                    Text(stopwatch.isRunning ? "Lap" : "Reset")
                        .foregroundColor(.white)
                        .frame(width: CIRCLE_WIDTH, height: CIRCLE_WIDTH)
                        .background(Circle().fill(Color.white.opacity(0.1)))
                        .overlay(Circle().stroke(Color.white, lineWidth: 1))
                }
            }
            .padding(.trailing)
        }
        .padding(.vertical, 10)
        .background(Color.black)
        .frame(maxWidth: .infinity) // Ensure the view takes up full space
    }
    
    // MARK: - Helpers
    
    func formatTime(_ interval: TimeInterval) -> String {
        let minutes = Int(interval) / 60
        let seconds = Int(interval) % 60
        let hundredths = Int((interval - floor(interval)) * 100)
        return String(format: "%02d:%02d.%02d", minutes, seconds, hundredths)
    }

    func colorForLap(at index: Int) -> Color {
        if stopwatch.lapTimes.count < 2 { return .white }
        
        guard let max = stopwatch.lapTimes.max(),
              let min = stopwatch.lapTimes.min() else { return .white }

        let lap = stopwatch.lapTimes[index]
        if lap == max {
            return .red
        } else if lap == min {
            return .green
        } else {
            return .white
        }
    }
}

struct StopwatchView_Previews: PreviewProvider {
    static var previews: some View {
        StopwatchView(stopwatch: Stopwatch())
    }
}
