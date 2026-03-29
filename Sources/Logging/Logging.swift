import OSLog

/// Centralised logging namespace backed by Apple's unified logging system.
///
/// Set `Logging.subsystem` once at app launch — before any log call —
/// then use the category loggers anywhere in your app or package:
///
/// ```swift
/// // AppDelegate / @main
/// Logging.subsystem = Bundle.main.bundleIdentifier!   // "com.mycompany.MyApp"
///
/// // Anywhere
/// Logging.network.info("Request: \(url, privacy: .public)")
/// Logging.auth.debug("Login attempt: \(email, privacy: .private)")
/// Logging.data.error("Save failed: \(error)")
/// ```
///
/// ## Log Levels
/// | Level      | Description                             | Persisted |
/// |------------|-----------------------------------------|-----------|
/// | `.debug`   | Development only — compiled out Release | No        |
/// | `.info`    | General information                     | No        |
/// | `.notice`  | Important events                        | Yes       |
/// | `.warning` | Potential issues                        | Yes       |
/// | `.error`   | Errors that need attention              | Yes       |
/// | `.fault`   | Critical failures (highlighted)         | Yes       |
///
/// ## Privacy Annotations
/// ```swift
/// Logging.auth.info("User: \(name, privacy: .private)")         // redacted in release
/// Logging.network.info("Status: \(code, privacy: .public)")     // always visible
/// Logging.auth.debug("Token: \(token, privacy: .sensitive)")    // always redacted
/// Logging.auth.info("ID: \(id, privacy: .private(mask: .hash))") // hashed
/// ```
///
/// ## Console.app / Terminal streaming
/// ```
/// log stream --predicate 'subsystem == "com.mycompany.MyApp"' --level debug
/// log stream --predicate 'subsystem == "com.mycompany.MyApp" AND category == "Network"'
/// ```
public enum Logging {

    /// The OSLog subsystem shared by all category loggers.
    ///
    /// Set this once before any logging call, typically in `AppDelegate` or
    /// the `@main` struct. Defaults to `Bundle.main.bundleIdentifier` when
    /// running inside an app target; falls back to `"com.unknown"` otherwise
    /// (e.g. in pure Swift package tests without a host app).
    public static var subsystem: String = Bundle.main.bundleIdentifier ?? "com.unknown"

    // MARK: - Core

    /// General-purpose logger for events that don't fit a specific category.
    public static var general: Logger    { Logger(subsystem: subsystem, category: "General") }

    // MARK: - Networking

    /// Network requests, responses, and connectivity events.
    public static var network: Logger    { Logger(subsystem: subsystem, category: "Network") }

    /// API layer: endpoint calls, serialisation, response mapping.
    public static var api: Logger        { Logger(subsystem: subsystem, category: "API") }

    // MARK: - User

    /// Authentication, sessions, and authorisation flows.
    public static var auth: Logger       { Logger(subsystem: subsystem, category: "Auth") }

    /// User profile, preferences, and account events.
    public static var user: Logger       { Logger(subsystem: subsystem, category: "User") }

    // MARK: - Data

    /// Persistence, database reads/writes, and migrations.
    public static var data: Logger       { Logger(subsystem: subsystem, category: "Data") }

    /// In-memory and on-disk cache operations.
    public static var cache: Logger      { Logger(subsystem: subsystem, category: "Cache") }

    // MARK: - UI

    /// UI events, view rendering, and user interactions.
    public static var ui: Logger         { Logger(subsystem: subsystem, category: "UI") }

    /// Navigation: push/pop, sheet presentation, deep links.
    public static var navigation: Logger { Logger(subsystem: subsystem, category: "Navigation") }

    // MARK: - System

    /// Performance measurements and profiling markers.
    public static var performance: Logger { Logger(subsystem: subsystem, category: "Performance") }

    /// App and scene lifecycle events.
    public static var lifecycle: Logger  { Logger(subsystem: subsystem, category: "Lifecycle") }
}
