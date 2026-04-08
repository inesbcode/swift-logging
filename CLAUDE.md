# swift-logging

Lightweight OSLog wrapper for Apple platforms. Provides a `struct Logging` that is
instantiated with a subsystem and vends category-scoped `Logger` instances for structured,
filterable logging across apps and Swift packages.

## Project structure

```
Sources/   – production code (Logging target)
Tests/     – unit tests (LoggingTests target)
```

## How it works

`Logging` is a `struct` instantiated with a subsystem string (defaults to
`"com.inesb.swift-logging"`). Each computed property returns a fresh
`Logger(subsystem:category:)` instance scoped to a predefined category.
All members are `nonisolated` so they are callable from any isolation context without `await`.
The subsystem is injected at init time and stored as a `private let`.

Typical usage — create one instance per app target and pass or store it where needed:

```swift
let log = Logging(subsystem: Bundle.main.bundleIdentifier ?? "com.mycompany.MyApp")
log.network.info("Request started")
```

## Swift 6 notes

- `swiftSettings` includes `.defaultIsolation(MainActor.self)`, so every declaration in the
  target is implicitly `@MainActor` unless marked otherwise.
- All `Logging` properties are `nonisolated` — they can be called from any isolation context
  without `await`. This is mandatory for a logging library.
- The `init` is also `nonisolated` so `Logging` can be created from any isolation context.

## Documentation

All public declarations must have a doc comment (`///`).
The top-level `struct Logging` doc comment must include:
- One-line summary
- Setup / instantiation example
- Basic usage example
- Privacy annotations guide
- Log levels table
- Console.app / terminal streaming examples

Individual category properties require only a one-line summary describing the kind of events
they cover.

## Test conventions

Each test file contains exactly one `@Suite` and the suite name must match the
production type under test (e.g. `Logging` → `LoggingTests`).

Test files live flat inside `Tests/LoggingTests/` and mirror the source files
in `Sources/Logging/`:

```
Sources/Logging/Logging.swift  → Tests/LoggingTests/LoggingTests.swift
```

Never put multiple suites in one file, and never group tests for different types
into the same suite even if they exercise related concerns — merge those into the
single suite for that type instead.

## Adding a category

Add a `public nonisolated var` computed property in the appropriate `MARK` section,
following the existing pattern:

```swift
/// Logger for <description of events>.
public nonisolated var myCategory: Logger {
    Logger(subsystem: subsystem, category: "MyCategory")
}
```

Then add `_ = logging.myCategory` to the `predefinedCategories` test in `LoggingTests.swift`
(where `logging` is the `Logging()` instance created at the top of the test).

## Key decisions (do not reverse without discussion)

- **Single file.** All public API lives in `Sources/Logging/Logging.swift`.
- **`struct` with init.** `Logging` is instantiated with a subsystem. Do not convert it back
  to an enum or make members static.
- **Computed `var`, not `let`.** Properties are computed so the subsystem stored at init time
  is always used. Do not convert to stored `let` properties.
- **No dependencies.** The package must remain dependency-free.

## Commands

```bash
swift build
swift test

# Format (uses Xcode-bundled swift-format via active toolchain)
xcrun swift-format format --in-place --recursive --configuration swift-format.json Sources/ Tests/
```
