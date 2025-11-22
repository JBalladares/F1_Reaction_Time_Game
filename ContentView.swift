//
//  ContentView.swift
//  QuickTap
//
//
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    @Environment(AppModel.self) private var appModel
    @State private var enlarge = false
    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace
    @Environment(\.pushWindow) private var pushWindow
    @Environment(\.dismissWindow) private var dismissWindow
    
    private var isGameOpen: Bool {
        appModel.immersiveSpaceState == .open
    }
    
    var body: some View {
        VStack(spacing: 50) {
            Text("F1 Reaction Time Trainer")
                .font(.system(size: 50, weight: .bold, design: .rounded))
            
            VStack(spacing: 15) {
                if !isGameOpen {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("How to Play:")
                        Text("1. Watch the lights turn on")
                        Text("2. Wait for the green GO button")
                        Text("3. Tap it as fast as you can!")
                        Text("4. See your reaction time")
                    }
                    .font(.title)
                    .padding(.all)
                    .glassBackgroundEffect()
                }
                
                Button {
                    Task {
                        if isGameOpen {
                            appModel.immersiveSpaceState = .inTransition
                            await dismissImmersiveSpace()
                            if appModel.pushWindowOpen {
                                dismissWindow(id: "PushWindow")
                            }
                            appModel.immersiveSpaceState = .closed
                        } else {
                            appModel.immersiveSpaceState = .inTransition
                            await openImmersiveSpace(id: "GameOne")
                            pushWindow(id: "PushWindow")
                        }
                    }
                } label: {
                    HStack {
                        Image(systemName: isGameOpen ? "stop.circle.fill" : "play.circle.fill")
                            .font(.title2)
                        Text(isGameOpen ? "Stop Game" : "Start Game")
                            .font(.title3)
                            .fontWeight(.semibold)
                    }
                    .padding()
                    .foregroundColor(.white)
                }
//                .buttonStyle(.borderedProminent)
                .background(isGameOpen ? Color.red : Color.green)
                .cornerRadius(30)
                .disabled(appModel.immersiveSpaceState == .inTransition)
            }
            .padding(.horizontal)
        }
        .padding()
    }
}

#Preview(windowStyle: .plain) {
    ContentView()
        .environment(AppModel())
}
