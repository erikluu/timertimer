//
//  StopwatchView.swift
//  timertimer
//
//  Created by Erik Luu on 4/19/25.
//
import SwiftUI

struct StopwatchView: View {
    @ObservedObject var stopwatch: Stopwatch
    
    private var fastestLap: TimeInterval? {
        stopwatch.lapTimes.min()
    }
    
    private var slowestLap: TimeInterval? {
        stopwatch.lapTimes.max()
    }
    
    var body: some View {
        HStack(alignment: .center) {
            // Current Lap Time
            Text(formatTime(stopwatch.lapElapsed))
                .font(.system(size: 20, weight: .bold, design: .monospaced))
                .frame(width: 100, alignment: .leading)
            
            // Lap Times ScrollView
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(Array(stopwatch.lapTimes.reversed().enumerated()), id: \.offset) { index, lap in
                        Text(formatTime(lap))
                            .font(.system(size: 14, design: .monospaced))
                            .padding(6)
                            .background(
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(colorForLap(lap))
                            )
                            .foregroundColor(.white)
                    }
                }
            }
            .frame(height: 44)

            // Buttons on the right
            VStack(spacing: 8) {
                Button(action: {
                    stopwatch.isRunning ? stopwatch.stop() : stopwatch.start()
                }) {
                    Text(stopwatch.isRunning ? "Stop" : "Start")
                        .font(.caption)
                        .frame(width: 60)
                        .padding(6)
                        .background(stopwatch.isRunning ? Color.red : Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                Button(action: {
                    stopwatch.isRunning ? stopwatch.lap() : stopwatch.reset()
                }) {
                    Text(stopwatch.isRunning ? "Lap" : "Reset")
                        .font(.caption)
                        .frame(width: 60)
                        .padding(6)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
        }
        .padding(.horizontal)
    }

    // MARK: - Helper Functions
    
    private func formatTime(_ interval: TimeInterval) -> String {
        let minutes = Int(interval) / 60
        let seconds = Int(interval) % 60
        let hundredths = Int((interval - floor(interval)) * 100)
        return String(format: "%02d:%02d.%02d", minutes, seconds, hundredths)
    }

    private func colorForLap(_ lap: TimeInterval) -> Color {
        if stopwatch.lapTimes.count <= 1 { return .gray }
        if lap == fastestLap { return .green }
        if lap == slowestLap { return .red }
        return .blue
    }
}



struct StopwatchView_Previews: PreviewProvider {
    static var previews: some View {
        StopwatchView(stopwatch: Stopwatch())
    }
}

