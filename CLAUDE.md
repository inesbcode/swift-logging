# CLAUDE.md — swift-logging

Guidelines for Claude Code when working in this repository.

## Package overview

`swift-logging` is a minimal OSLog utility wrapper for Apple platforms.
Public API surface: a single `enum Logging` in `Sources/Logging/Logging.swift`.

## Key decisions (do not reverse without discussion)

- **Single file.** All public API lives in `Sources/Logging/Logging.swift`. Do not add extra source files unless the user explicitly asks.
- **`enum` namespace.** `Logging` is an uninitializable enum used as a namespace. Do not convert it to a struct, class, or actor.
- **`nonisolated(unsafe) static var subsystem`** is intentional. The value is set once at app launch before any concurrent access. Do not replace it with an actor, a `Mutex`, or a `@MainActor` property — that would force callers to `await` a logging call.
- **Computed `static var` for loggers** (not `static let`). This ensures that changing `subsystem` before first use is reflected in every logger. Do not convert them to `static let`.
- **No dependencies.** The package must remain dependency-free. Do not add any `.package` entries to `Package.swift`.
- **Swift 6 language mode** is enforced via `swiftSettings` on both targets.

## Platforms & deployment targets

| Platform  | Minimum |
|-----------|---------|
| iOS       | 16      |
| macOS     | 13      |
| tvOS      | 16      |
| watchOS   | 9       |
| visionOS  | 1       |

These are the lowest versions that support `OSLog.Logger`. Do not raise them without a concrete reason.

## Concurrency rules

- `Logging` and all its members must be callable from **any isolation context** (main actor, background actor, nonisolated). Never add `@MainActor` to the enum or its properties.
- `Logger` (OSLog) is `Sendable` — no extra annotations needed on the computed properties.

## Adding / removing categories

To add a category, add a `public static var` computed property in the appropriate `MARK` section following the existing pattern:

```swift
public static var myCategory: Logger { Logger(subsystem: subsystem, category: "MyCategory") }
```

Then add a corresponding `_ = Logging.myCategory` line in the `predefinedCategories` test.

## Tests

- Framework: **Swift Testing** (`import Testing`). Do not use XCTest.
- Tests live in `Tests/LoggingTests/LoggingTests.swift`.
- All tests must pass with `swift test` before committing.
- The `subsystemIsConfigurable` test mutates `Logging.subsystem` and restores it — keep this pattern if adding similar tests.

## Commit style

Concise subject line (imperative, ≤ 72 chars), body only when the *why* is non-obvious.

## What not to do

- Do not add `@discardableResult` to logging calls (they return `Void`).
- Do not add convenience wrappers around `Logger` methods — callers use OSLog's native string-interpolation API directly.
- Do not generate a `LoggerHub`, `LoggingService`, or protocol layer unless the user explicitly asks.
