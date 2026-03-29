# swift-logging

A lightweight OSLog wrapper for Apple platforms. Drop it into any app or Swift package to get structured, category-scoped logging with zero configuration.

## Requirements

- Swift 6.0+
- iOS 16 / macOS 13 / tvOS 16 / watchOS 9 / visionOS 1

## Installation

### Swift Package Manager

```swift
// Package.swift
.package(url: "https://github.com/inesb/swift-logging", from: "1.0.0"),

// In your target:
.product(name: "Logging", package: "swift-logging"),
```

Or add it directly in Xcode: **File › Add Package Dependencies…**

## Usage

### 1. Configure the subsystem (once, at app launch)

```swift
// AppDelegate or @main struct — before any log call
import Logging

Logging.subsystem = Bundle.main.bundleIdentifier!  // "com.mycompany.MyApp"
```

If you skip this step the subsystem falls back to `Bundle.main.bundleIdentifier` automatically, so it is optional for app targets.

### 2. Log from anywhere

```swift
import Logging

Logging.network.info("Request started: \(url, privacy: .public)")
Logging.auth.debug("Login attempt: \(email, privacy: .private)")
Logging.data.error("Save failed: \(error)")
Logging.lifecycle.notice("App moved to background")
```

## Log levels

| Level      | When to use                          | Persisted in release |
|------------|--------------------------------------|----------------------|
| `.debug`   | Verbose dev-only info (compiled out) | No                   |
| `.info`    | General flow information             | No                   |
| `.notice`  | Important milestones                 | Yes                  |
| `.warning` | Recoverable unexpected conditions    | Yes                  |
| `.error`   | Errors that affect functionality     | Yes                  |
| `.fault`   | Critical failures (highlighted red)  | Yes                  |

## Privacy annotations

OSLog redacts interpolated values in release builds by default. Opt in to visibility explicitly:

```swift
Logging.auth.info("User: \(name, privacy: .private)")          // redacted in release
Logging.network.info("Status: \(code, privacy: .public)")      // always visible
Logging.auth.debug("Token: \(token, privacy: .sensitive)")     // always redacted
Logging.auth.info("ID: \(id, privacy: .private(mask: .hash))") // hashed for correlation
```

## Available categories

| Property          | Category       | Intended use                              |
|-------------------|----------------|-------------------------------------------|
| `Logging.general` | General        | Events that don't fit another category   |
| `Logging.network` | Network        | Requests, responses, connectivity         |
| `Logging.api`     | API            | Endpoint calls, serialisation             |
| `Logging.auth`    | Auth           | Login, logout, session management         |
| `Logging.user`    | User           | Profile, preferences, account events     |
| `Logging.data`    | Data           | Persistence, migrations                   |
| `Logging.cache`   | Cache          | In-memory and on-disk cache operations   |
| `Logging.ui`      | UI             | View rendering, user interactions         |
| `Logging.navigation` | Navigation  | Push/pop, sheets, deep links              |
| `Logging.performance` | Performance | Measurements, profiling markers          |
| `Logging.lifecycle` | Lifecycle    | App and scene lifecycle events            |

## Viewing logs

**Console.app**
1. Open Console.app and select your device or simulator
2. Filter by subsystem: type `subsystem:com.mycompany.MyApp` in the search field
3. Optionally add a category filter: `category:Network`

**Terminal**
```bash
# Stream all logs for your app at debug level
log stream --predicate 'subsystem == "com.mycompany.MyApp"' --level debug

# Filter to a single category
log stream --predicate 'subsystem == "com.mycompany.MyApp" AND category == "Network"' --level debug
```

## Design

- **No dependencies** — only `OSLog` from the system SDK
- **Swift 6 strict concurrency** — safe to call from any isolation context
- **Enum namespace** — `Logging` is uninitializable; no instances, no overhead
- **Computed properties** — loggers pick up `Logging.subsystem` changes before first use

## License

MIT. See [LICENSE](LICENSE).
