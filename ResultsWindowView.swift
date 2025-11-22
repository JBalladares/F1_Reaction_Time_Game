//
//  ResultsWindowView.swift
//  QuickTap
//
//
//

import SwiftUI

struct ResultsWindowView: View {
    @Environment(AppModel.self) private var appModel
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace
    @Environment(\.dismissWindow) private var dismissWindow
    @Environment(\.openWindow) private var openWindow
    
    var body: some View {
        VStack(spacing: 30) {
            if appModel.reactionTime < 0 {
                Text("TOO EARLY!")
                    .font(.system(size: 50, weight: .bold, design: .rounded))
                    .foregroundStyle(.red)
                    .padding(.top)
                
                Text("You tapped before the light turned green!")
                    .font(.title2)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Text("Wait for the GO signal next time")
                    .font(.title3)
                    .foregroundStyle(.orange)
            } else {
                Text("Reaction Time")
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .padding(.top)
                
                Text(String(format: "%.3f", appModel.reactionTime))
                    .font(.system(size: 80, weight: .bold, design: .rounded))
                    .foregroundStyle(.green)
                
                Text("seconds")
                    .font(.title2)
                    .foregroundStyle(.secondary)

                Group {
                    if appModel.reactionTime < 0.200 {
                        Text("F1 Driver Level!")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundStyle(.yellow)
                    } else if appModel.reactionTime < 0.300 {
                        Text("Excellent!")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundStyle(.green)
                    } else if appModel.reactionTime < 0.400 {
                        Text("Good")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundStyle(.blue)
                    } else {
                        Text("Keep Practicing")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundStyle(.orange)
                    }
                }
            }
            
            Spacer()
            
            HStack(spacing: 10) {
                Button {
                    appModel.shouldRestartGame = true
                    dismissWindow(id: "ResultsWindow")
                } label: {
                    Label("Play Again", systemImage: "arrow.clockwise")
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .tint(.green)
                .padding()
                
                Button {
                    Task {
                        dismissWindow(id: "ResultsWindow")
                        try? await Task.sleep(for: .milliseconds(200))
                        await dismissImmersiveSpace()
                        if appModel.pushWindowOpen {
                            dismissWindow(id: "PushWindow")
                        }
                    }
                } label: {
                    HStack {
                        Image(systemName: "xmark.circle")
                        Text("Exit Game")
                    }
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .tint(.red)
                .padding()
            }

        }
        .glassBackgroundEffect()
        .frame(width: 600, height: 400)
    }
}

#Preview {
    ResultsWindowView()
        .environment(AppModel())
}
