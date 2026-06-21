# AutoPilot iOS

iOS platform runner for the AutoPilot declarative GUI test framework.

Runs the same JSON plan format used by [`autopilot-macos`](https://github.com/jschwefel-CBB/autopilot-macos) and [`autopilot-android`](https://github.com/jschwefel-CBB/autopilot-android). Plans are human-readable JSON, but designed to be authored by AI agents — connect an agent to the AutoPilot MCP server, describe what you want tested, and it produces a ready-to-run plan.

## What's here

```
autopilot-ios/
  TestHostApp/             ← UIKit app exposing the full test surface
  TestHostAppSwiftUI/      ← SwiftUI equivalent of the same surface
  TestHostAppUITests/
    PlanModel.swift        ← data classes for the JSON plan
    AutoPilotRunner.swift  ← step executor (XCUITest)
    AutoPilotRunnerTests.swift  ← XCTestCase entry point
    test-all-capabilities.json  ← unified 78-step plan
  project.yml              ← XcodeGen project definition
```

## Prerequisites

- Xcode 15+
- XcodeGen: `brew install xcodegen`

## Setup

```bash
git clone https://github.com/jschwefel-CBB/autopilot-ios.git
cd autopilot-ios
xcodegen generate
open TestHostApp.xcodeproj
```

## Running the tests

1. Select the `TestHostApp` scheme in Xcode
2. Choose an iOS Simulator (iOS 16+)
3. Run via Product → Test (⌘U)

Or from the command line:

```bash
xcodebuild test \
  -project TestHostApp.xcodeproj \
  -scheme TestHostApp \
  -destination 'platform=iOS Simulator,name=iPhone 16'
```

## Results

The unified 78-step plan achieves **75 PASS + 3 SKIP** on iOS. The 3 skipped steps require pixel-level screen capture not available via XCUITest.

| Action | Status | Reason |
|---|---|---|
| `assertPixel` | SKIP | Pixel-level screen access not available via XCUITest |
| `assertRegion` | SKIP | Same |
| `snapshot` | SKIP | Same |

All other actions pass.

## Core dependency

This runner implements the AutoPilot plan format defined by [`autopilot-core`](https://github.com/jschwefel-CBB/autopilot-core). The plan model mirrors the core schema. Future versions will consume `autopilot-core` directly as a Swift package dependency.

## Cross-platform

The same JSON plan format runs across platforms:

| Platform | Repo | Result |
|---|---|---|
| macOS | [`autopilot-macos`](https://github.com/jschwefel-CBB/autopilot-macos) | Full support |
| iOS | this repo | 75 PASS + 3 SKIP |
| Android | [`autopilot-android`](https://github.com/jschwefel-CBB/autopilot-android) | 75 PASS + 3 SKIP |

## License

MIT
