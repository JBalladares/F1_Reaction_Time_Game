//
//  ImmersiveGameOne.swift
//  QuickTap
//
//
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveGameOne: View {
    @Environment(AppModel.self) private var appModel
    @Environment(\.openWindow) private var openWindow
    @State private var gameState: GameState = .idle
    @State private var startTime: Date?
    @State private var rootEntity: Entity?
    @State private var resultsWindowShown = false
    
    enum GameState {
        case idle
        case lightingUp
        case waitingForGo
        case go
        case finished
        case tooEarly
    }
    
    var body: some View {
        RealityView { content in
            let headAnchor = AnchorEntity(.head)
            headAnchor.anchoring.trackingMode = .once

            let root = Entity()

            root.position = [0, -0.15, -1.5]
            
            headAnchor.addChild(root)
            rootEntity = root

            content.add(headAnchor)

            setupGame(root: root)

            Task {
                await runGameSequence()
            }
        }
        .gesture(
            SpatialTapGesture()
                .targetedToEntity(where: .has(InputTargetComponent.self))
                .onEnded { value in
                    handleTap(on: value.entity)
                }
        )
        .onChange(of: gameState) { oldValue, newValue in
            if (newValue == .finished || newValue == .tooEarly) && !resultsWindowShown {
                resultsWindowShown = true
                openWindow(id: "ResultsWindow")
            }
        }
        .onChange(of: appModel.shouldRestartGame) { oldValue, newValue in
            if newValue == true {
                appModel.shouldRestartGame = false
                resultsWindowShown = false
                Task {
                    await restartGame()
                }
            }
        }
    }
    
    private func setupGame(root: Entity) {
        let lightPositions: [(x: Float, y: Float)] = [
            (-0.4, 0.2), (-0.2, 0.2), (0.0, 0.2), (0.2, 0.2), (0.4, 0.2),
            (-0.4, 0.0), (-0.2, 0.0), (0.0, 0.0), (0.2, 0.0), (0.4, 0.0)
        ]
        
        for (index, position) in lightPositions.enumerated() {
            let light = createLight(at: position, index: index)
            root.addChild(light)
        }

        let goButton = createGoButton()
        root.addChild(goButton)
    }
    
    private func createLight(at position: (x: Float, y: Float), index: Int) -> ModelEntity {
        let mesh = MeshResource.generateSphere(radius: 0.05)
        var material = SimpleMaterial(color: .black, isMetallic: false)
        material.roughness = 0.8
        let light = ModelEntity(mesh: mesh, materials: [material])

        light.position = [position.x, position.y, 0]
        light.name = "Light_\(index)"

        light.components.set(CollisionComponent(shapes: [.generateSphere(radius: 0.05)]))
        
        return light
    }
    
    private func createGoButton() -> ModelEntity {
        let mesh = MeshResource.generateSphere(radius: 0.15)
        var material = SimpleMaterial(color: .gray, isMetallic: false)
        material.roughness = 0.8
        let button = ModelEntity(mesh: mesh, materials: [material])

        button.position = [0, -0.3, 0]
        button.name = "GoButton"
        button.components.set(InputTargetComponent())
        button.components.set(CollisionComponent(shapes: [.generateSphere(radius: 0.15)]))
        return button
    }
    
    private func handleTap(on entity: Entity) {
        guard entity.name == "GoButton" else {
            return
        }
        
        if gameState != .go {
            appModel.reactionTime = -1.0
            gameState = .tooEarly
            if let button = entity as? ModelEntity {
                var material = SimpleMaterial(color: .red, isMetallic: false)
                material.roughness = 0.8
                button.model?.materials = [material]
            }
            return
        }
        
        guard let startTime = startTime else {
            return
        }

        let endTime = Date()
        let reactionTime = endTime.timeIntervalSince(startTime)
        appModel.reactionTime = reactionTime
        gameState = .finished
    }
    
    private func runGameSequence() async {
        guard let root = rootEntity else {
            return
        }

        try? await Task.sleep(for: .seconds(1))
        
        gameState = .lightingUp
        
        for col in 0..<5 {
            let topLightIndex = col
            let bottomLightIndex = col + 5

            await lightUpLight(index: topLightIndex, root: root)
            await lightUpLight(index: bottomLightIndex, root: root)
            
            try? await Task.sleep(for: .seconds(0.5))
        }

        gameState = .waitingForGo
        let randomDelay = Double.random(in: 5.0...8.0)
        try? await Task.sleep(for: .seconds(randomDelay))
        await showGoButton(root: root)
    }
    
    @MainActor
    private func lightUpLight(index: Int, root: Entity) async {
        guard let light = root.findEntity(named: "Light_\(index)") as? ModelEntity else {
            return
        }

        let material = UnlitMaterial(color: .red)
        light.model?.materials = [material]
    }
    
    @MainActor
    private func showGoButton(root: Entity) async {
        for index in 0..<10 {
            if let light = root.findEntity(named: "Light_\(index)") {
                var opacity = OpacityComponent()
                opacity.opacity = 0.0
                light.components[OpacityComponent.self] = opacity
            }
        }
        
        guard let goButton = root.findEntity(named: "GoButton") as? ModelEntity else {
            return
        }
        
        let material = UnlitMaterial(color: .green)
        goButton.model?.materials = [material]

        startTime = Date()
        gameState = .go
    }
    
    @MainActor
    private func restartGame() async {
        guard let root = rootEntity else { return }

        for index in 0..<10 {
            if let light = root.findEntity(named: "Light_\(index)") as? ModelEntity {
                var material = SimpleMaterial(color: .black, isMetallic: false)
                material.roughness = 0.8
                light.model?.materials = [material]
                
                var opacity = OpacityComponent()
                opacity.opacity = 1.0
                light.components[OpacityComponent.self] = opacity
            }
        }

        if let goButton = root.findEntity(named: "GoButton") as? ModelEntity {
            var material = SimpleMaterial(color: .gray, isMetallic: false)
            material.roughness = 0.8
            goButton.model?.materials = [material]
        }
        startTime = nil
        gameState = .idle
        await runGameSequence()
    }
}

#Preview {
    ImmersiveGameOne()
        .environment(AppModel())
}

