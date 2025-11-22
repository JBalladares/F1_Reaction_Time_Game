//
//  AppModel.swift
//  QuickTap
//
//
//

import SwiftUI

@MainActor
@Observable
class AppModel {
    let immersiveSpaceID = "ImmersiveSpace"
    
    enum ImmersiveSpaceState {
        case closed
        case inTransition
        case open
    }
    
    var immersiveSpaceState = ImmersiveSpaceState.closed
    var pushWindowOpen: Bool = false
    var reactionTime: TimeInterval = 0.0
    var shouldRestartGame: Bool = false
}
