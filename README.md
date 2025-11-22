**F1-Inspired Reaction Time Trainer for Apple Vision Pro**

A visionOS application that tests and trains reaction time using Formula 1 starting light sequences. Built with SwiftUI, RealityKit, and visionOS 26.

## Screenshots

<p align="center">
  <img src="https://raw.githubusercontent.com/JBalladares/F1_Reaction_Time_Game/main/gameplay.png" width="45%" alt="Gameplay - F1 Light Sequence">
  <img src="https://raw.githubusercontent.com/JBalladares/F1_Reaction_Time_Game/main/results.png" width="45%" alt="Results Screen">
</p>
---

## Features

- **F1-Style Light Sequence** — 10 red lights illuminate in columns, mimicking Formula 1 starting procedures
- **Reaction Time Measurement** — Measures user reaction time from green light to tap
- **Immersive Spatial Experience** — Lights and controls positioned in 3D space for comfortable viewing
- **Performance Feedback** — Categorized results from "F1 Driver Level" to practice recommendations
- **Early Start Detection** — Validates proper timing and penalizes premature taps
- **Instant Replay** — Quick restart functionality to practice multiple rounds

---

## Technical Highlights

- **Spatial Computing** — Uses `AnchorEntity` with `.once` tracking mode for stable world-space positioning
- **Window Management** — Implements `pushWindow` pattern to hide main window during gameplay
- **SwiftUI + RealityKit Integration** — Seamless coordination between 2D UI and 3D content
- **Observable Architecture** — Clean state management using `@Observable` macro
- **Human Interface Guidelines** — Follows Apple's visionOS design principles for comfort and accessibility

---

## Requirements

- Xcode 15.2 or later
- visionOS 1.0 or later
- Apple Vision Pro

---

##  Project Structure

```
QuickTap/
├── QuickTapApp.swift                    # App entry point and scene configuration
├── AppModel.swift                       # Centralized app state management
├── ContentView.swift                    # Main menu interface
├── ImmersiveGameOne.swift              # Core game logic and 3D scene
├── ResultsWindowView.swift             # Results display and replay options
└── PushWindowContent.swift             # Window management helper
```

---

## How It Works

1. **Setup** — Game creates 10 lights in a 2×5 grid and a gray GO button in 3D space
2. **Lighting Sequence** — Lights illuminate column by column over 2.5 seconds
3. **Random Delay** — System waits 5-8 seconds to prevent anticipation
4. **GO Signal** — All lights extinguish and button turns green
5. **Measurement** — Precise timing from green light to user tap
6. **Results** — Performance categorization and replay option

---

## Implementation Details

### Spatial Positioning
- Head-anchored content with `.once` tracking for stable world placement
- Positioned 1.5m forward, 0.15m below eye level for ergonomic viewing
- Entity-based architecture for efficient 3D scene management

### State Management
- Centralized `AppModel` using `@Observable` for reactive updates
- Immersive space state tracking (closed, inTransition, open)
- Cross-window communication for results and replay functionality

### User Interaction
- `SpatialTapGesture` for 3D button interaction
- `InputTargetComponent` for selective entity targeting
- Early tap detection with visual feedback

---

## Performance Benchmarks

| Reaction Time | Rating |
|--------------|--------|
| < 200ms | F1 Driver Level |
| 200-300ms | Excellent |
| 300-400ms | Good |
| > 400ms | Keep Practicing |

---

## License

MIT License — feel free to use this project as a learning resource or starting point for your own visionOS applications.

---

*Built as a demonstration of visionOS spatial computing capabilities and Apple Vision Pro development best practices.*
