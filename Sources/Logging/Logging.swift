import OSLog

/// A namespace of category-scoped `Logger` instances backed by Apple's unified logging system.
///
/// `Logging` provides a single, zero-configuration entry point for structured logging across
/// an app or Swift package. Each static property vends a `Logger` tied to a predefined OSLog
/// category, enabling fine-grained filtering in Console.app and `log stream`.
///
/// ## Setup
///
/// Set ``subsystem`` once at app launch before any logging call. For app targets the default
/// value (`Bundle.main.bundleIdentifier`) is usually sufficient and no explicit setup is needed.
///
/// ```swift
/// // AppDelegate or @main — optional for app targets, required for framework targets
/// Logging.subsystem = "com.mycompany.MyApp"
/// ```
///
/// ## Basic usage
///
/// ```swift
/// Logging.network.info("Request started: \(url, privacy: .public)")
/// Logging.auth.debug("Login attempt: \(email, privacy: .private)")
/// Logging.data.error("Save failed: \(error)")
/// Logging.lifecycle.notice("App moved to background")
/// ```
///
/// ## Privacy annotations
///
/// OSLog redacts interpolated values in release builds by default. Annotate explicitly:
///
/// ```swift
/// Logging.auth.info("User: \(name, privacy: .private)")           // redacted in release
/// Logging.network.info("Status: \(code, privacy: .public)")       // always visible
/// Logging.auth.debug("Token: \(token, privacy: .sensitive)")      // always redacted
/// Logging.auth.info("ID: \(id, privacy: .private(mask: .hash))") // hashed
/// ```
///
/// ## Log levels
///
/// | Level      | Description                             | Persisted |
/// |------------|-----------------------------------------|-----------|
/// | `.debug`   | Development only — compiled out Release | No        |
/// | `.info`    | General information                     | No        |
/// | `.notice`  | Important milestones                    | Yes       |
/// | `.warning` | Recoverable unexpected conditions       | Yes       |
/// | `.error`   | Errors that affect functionality        | Yes       |
/// | `.fault`   | Critical failures (highlighted)         | Yes       |
///
/// ## Console.app and terminal streaming
///
/// ```bash
/// log stream --predicate 'subsystem == "com.mycompany.MyApp"' --level debug
/// log stream --predicate 'subsystem == "com.mycompany.MyApp" AND category == "Network"'
/// ```
///
/// - Note: All members are `nonisolated` so they can be called from any isolation context
///   without `await`, regardless of the module's default `@MainActor` isolation.
public struct Logging {

    // MARK: - Subsystem

    /// The OSLog subsystem shared by every category logger in this namespace.
    ///
    /// Set this property **once**, before any logging call — typically in `AppDelegate` or
    /// the `@main` struct. Changing it after loggers have been used has no effect on
    /// previously created `Logger` instances held by callers.
    ///
    /// Defaults to `Bundle.main.bundleIdentifier` when running inside an app target.
    /// Falls back to `"com.inesb.swift-logging"` in contexts without a host bundle
    /// (e.g. plain Swift package test runners).
    ///
    /// - Note: Marked `nonisolated(unsafe)` because it is intentionally written once at
    ///   launch before any concurrent logging begins. Swift 6 strict concurrency cannot
    ///   verify this statically, but the usage pattern makes it safe by convention.
    private let subsystem: String
    
    public nonisolated init(subsystem: String = "com.inesb.swift-logging") {
        self.subsystem = subsystem
    }

    // MARK: - Core

    /// General-purpose logger for events that do not belong to a more specific category.
    ///
    /// Use this as a catch-all during early development, then migrate call sites to a
    /// dedicated category as the codebase grows.
    public nonisolated var general: Logger {
        Logger(subsystem: subsystem, category: "General")
    }

    // MARK: - Networking

    /// Logger for network-layer events: requests, responses, retries, and connectivity changes.
    public nonisolated var network: Logger {
        Logger(subsystem: subsystem, category: "Network")
    }

    /// Logger for API-layer events: endpoint calls, JSON serialisation, and response mapping.
    public nonisolated var api: Logger {
        Logger(subsystem: subsystem, category: "API")
    }

    // MARK: - User

    /// Logger for authentication and authorisation events: login, logout, and session management.
    public nonisolated var auth: Logger {
        Logger(subsystem: subsystem, category: "Auth")
    }

    /// Logger for user-account events: profile changes, preferences, and account state.
    public nonisolated var user: Logger {
        Logger(subsystem: subsystem, category: "User")
    }

    // MARK: - Data

    /// Logger for persistence events: database reads and writes, migrations, and sync.
    public nonisolated var data: Logger {
        Logger(subsystem: subsystem, category: "Data")
    }

    /// Logger for cache events: hits, misses, evictions, and invalidations.
    public nonisolated var cache: Logger {
        Logger(subsystem: subsystem, category: "Cache")
    }

    // MARK: - UI

    /// Logger for UI events: view rendering, user interactions, and state changes.
    public nonisolated var ui: Logger {
        Logger(subsystem: subsystem, category: "UI")
    }

    /// Logger for navigation events: push, pop, sheet presentation, and deep-link routing.
    public nonisolated var navigation: Logger {
        Logger(subsystem: subsystem, category: "Navigation")
    }

    // MARK: - System

    /// Logger for performance measurements: timing, memory, and profiling markers.
    public nonisolated var performance: Logger {
        Logger(subsystem: subsystem, category: "Performance")
    }

    /// Logger for app and scene lifecycle events: foreground, background, and termination.
    public nonisolated var lifecycle: Logger {
        Logger(subsystem: subsystem, category: "Lifecycle")
    }
}
