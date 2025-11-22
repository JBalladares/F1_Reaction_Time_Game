//
//  QuickTapApp.swift
//  QuickTap
//
//
//

import SwiftUI

@main
struct QuickTapApp: App {

    @State private var appModel = AppModel()

    var body: some Scene {
        WindowGroup(id: "MainWindow") {
            ContentView()
                .environment(appModel)
        }
        .windowStyle(.plain)

        WindowGroup(id: "PushWindow") {
            PushWindowContent()
                .environment(appModel)
        }
        .defaultSize(CGSize(width: 300, height: 300))
        .windowStyle(.plain)

        WindowGroup(id: "ResultsWindow") {
            ResultsWindowView()
                .environment(appModel)
        }
        .windowStyle(.plain)
        .defaultSize(CGSize(width: 500, height: 450))
        
        ImmersiveSpace(id: "GameOne") {
            ImmersiveGameOne()
                .environment(appModel)
                .onAppear {
                    appModel.immersiveSpaceState = .open
                }
                .onDisappear {
                    appModel.immersiveSpaceState = .closed
                }
        }
        .immersionStyle(selection: .constant(.mixed), in: .mixed)

        ImmersiveSpace(id: appModel.immersiveSpaceID) {
            ImmersiveView()
                .environment(appModel)
                .onAppear {
                    appModel.immersiveSpaceState = .open
                }
                .onDisappear {
                    appModel.immersiveSpaceState = .closed
                }
        }
        .immersionStyle(selection: .constant(.mixed), in: .mixed)
    }
}
