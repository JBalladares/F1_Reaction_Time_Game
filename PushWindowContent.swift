//
//  PushWindowContent.swift
//  QuickTap
//
//
//

import SwiftUI

struct PushWindowContent: View {
    @Environment(AppModel.self) private var appModel
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
        Text("Nothing to see here")
            .opacity(0)
            .persistentSystemOverlays(.hidden)
            .onChange(of: scenePhase, initial: true) {
                switch scenePhase {
                case .inactive, .background:
                    appModel.pushWindowOpen = false
                case .active:
                    appModel.pushWindowOpen = true
                @unknown default:
                    appModel.pushWindowOpen = false
                }
            }
    }
}

#Preview {
    PushWindowContent()
        .environment(AppModel())
}
