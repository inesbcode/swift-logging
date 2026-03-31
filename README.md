# Logging

Structured OSLog wrapper for Apple platforms.

`print()` is invisible in production, unfiltered, and always evaluates its arguments. `swift-logging` replaces it with Apple's unified logging system: debug messages are compiled out in release builds, every log line is filterable by category in Console.app, and sensitive values are automatically redacted.

## Requirements

| Platform | Minimum version |
|----------|----------------|
| iOS      | 16             |
| macOS    | 13             |
| watchOS  | 9              |
| tvOS     | 16             |
| visionOS | 1              |

Swift 6 · Swift Package Manager

## Installation

### Xcode

**File → Add Package Dependencies…**, paste the repository URL, then add `Logging` to your app target.

### Package.swift

```swift
dependencies: [
    .package(url: "https://github.com/inesbcode/swift-logging.git", from: "1.0.0"),
],
targets: [
    .target(
        name: "MyApp",
        dependencies: [
            .product(name: "Logging", package: "swift-logging"),
        ]
    ),
]
```

## Usage

### Setup

Create one `Logging` instance per target, passing your subsystem, then store or pass it where needed:

```swift
// AppDelegate, @main struct, or dependency container
let log = Logging(subsystem: "com.mycompany.MyApp")
```

For quick prototyping the default init uses `"com.inesb.swift-logging"` as the subsystem:

```swift
let log = Logging()
```

### Basic logging

```swift
import Logging

let log = Logging(subsystem: "com.mycompany.MyApp")

log.network.info("Request started: \(url, privacy: .public)")
log.auth.debug("Login attempt: \(email, privacy: .private)")
log.data.error("Save failed: \(error)")
log.lifecycle.notice("App moved to background")
```

### Privacy annotations

OSLog redacts interpolated values in release builds by default. Annotate values explicitly to control what is visible in production logs:

```swift
log.auth.info("User: \(name, privacy: .private)")            // redacted in release
log.network.info("Status: \(code, privacy: .public)")        // always visible
log.auth.debug("Token: \(token, privacy: .sensitive)")       // always redacted
log.auth.info("ID: \(id, privacy: .private(mask: .hash))")  // hashed for correlation
```

## Log levels

| Level      | When to use                             | Persisted |
|------------|-----------------------------------------|-----------|
| `.debug`   | Verbose dev-only info (compiled out)    | No        |
| `.info`    | General flow information                | No        |
| `.notice`  | Important milestones                    | Yes       |
| `.warning` | Recoverable unexpected conditions       | Yes       |
| `.error`   | Errors that affect functionality        | Yes       |
| `.fault`   | Critical failures (highlighted red)     | Yes       |

## Categories

| Property          | Intended use                              |
|-------------------|-------------------------------------------|
| `.general`        | Events that don't fit another category    |
| `.network`        | Requests, responses, connectivity         |
| `.api`            | Endpoint calls, serialisation             |
| `.auth`           | Login, logout, session management         |
| `.user`           | Profile, preferences, account events      |
| `.data`           | Persistence, migrations                   |
| `.cache`          | In-memory and on-disk cache operations    |
| `.ui`             | View rendering, user interactions         |
| `.navigation`     | Push/pop, sheets, deep links              |
| `.performance`    | Measurements, profiling markers           |
| `.lifecycle`      | App and scene lifecycle events            |

## Viewing logs

**Console.app** — open Console.app, select your device or simulator, then filter by subsystem:

```
subsystem:com.mycompany.MyApp
```

Add a category to narrow results further:

```
subsystem:com.mycompany.MyApp category:Network
```

**Terminal**

```bash
log stream --predicate 'subsystem == "com.mycompany.MyApp"' --level debug
log stream --predicate 'subsystem == "com.mycompany.MyApp" AND category == "Network"'
```

## License

MIT — see [LICENSE](LICENSE).
