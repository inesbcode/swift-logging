# swift-logging

Lightweight OSLog wrapper for Apple platforms. Provides a single `enum Logging` namespace
with category-scoped `Logger` instances for structured, filterable logging across apps and
Swift packages.

## Project structure

```
Sources/   – production code (Logging target)
Tests/     – unit tests (LoggingTests target)
```

## How it works

`Logging` is an uninitializable enum used as a namespace. Each static computed property
returns a fresh `Logger(subsystem:category:)` instance scoped to a predefined category.
All members are `nonisolated` so they are callable from any isolation context without `await`.
`Logging.subsystem` is set once at app launch and picked up by every logger on first use.

## Swift 6 notes

- `swiftSettings` includes `.defaultIsolation(MainActor.self)`, so every declaration in the
  target is implicitly `@MainActor` unless marked otherwise.
- All `Logging` properties are `nonisolated` — they can be called from any isolation context
  without `await`. This is mandatory for a logging library.
- `Logging.subsystem` uses `nonisolated(unsafe)` because it is set once before any concurrent
  logging begins. Swift 6 cannot verify this statically, but the usage pattern is safe.

## Documentation

All public declarations must have a doc comment (`///`).
The top-level `enum Logging` doc comment must include:
- One-line summary
- Setup example
- Basic usage example
- Privacy annotations guide
- Log levels table
- Console.app / terminal streaming examples

Individual category properties require only a one-line summary describing the kind of events
they cover.

## Adding a category

Add a `public nonisolated static var` computed property in the appropriate `MARK` section,
following the existing pattern:

```swift
/// Logger for <description of events>.
public nonisolated static var myCategory: Logger {
    Logger(subsystem: subsystem, category: "MyCategory")
}
```

Then add `_ = Logging.myCategory` to the `predefinedCategories` test in `LoggingTests.swift`.

## Key decisions (do not reverse without discussion)

- **Single file.** All public API lives in `Sources/Logging/Logging.swift`.
- **`enum` namespace.** `Logging` is uninitializable. Do not convert it to a struct, class, or actor.
- **Computed `static var`, not `static let`.** Ensures `subsystem` changes before first use are
  reflected in every logger. Do not convert to `static let`.
- **No dependencies.** The package must remain dependency-free.

## Commands

```bash
swift build
swift test

# Format (uses Xcode-bundled swift-format via active toolchain)
xcrun swift-format format --in-place --recursive --configuration swift-format.json Sources/ Tests/
```
