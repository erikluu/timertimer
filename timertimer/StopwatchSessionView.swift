//
//  StopwatchSessionView.swift
//  timertimer
//
//  Created by Erik Luu on 4/19/25.
//


import SwiftUI

struct StopwatchSessionView: View {
    @State private var stopwatches: [Stopwatch] = [Stopwatch(), Stopwatch(), Stopwatch()]  // Example for 3 stopwatches
    @State private var isRunning = false
    
    var body: some View {
        VStack {
            ForEach(stopwatches) { stopwatch in
                StopwatchView(stopwatch: stopwatch)
            }
            
            HStack {
                Button(action: {
                    if isRunning {
                        stopAll()
                    } else {
                        startAll()
                    }
                }) {
                    Text(isRunning ? "Global Stop" : "Global Start")
                        .padding()
                        .background(isRunning ? Color.red : Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
    }
    
    private func startAll() {
        for stopwatch in stopwatches {
            stopwatch.start()
        }
        isRunning = true
    }
    
    private func stopAll() {
        for stopwatch in stopwatches {
            stopwatch.stop()
        }
        isRunning = false
    }
}

struct StopwatchSessionView_Previews: PreviewProvider {
    static var previews: some View {
        StopwatchSessionView()
    }
}


