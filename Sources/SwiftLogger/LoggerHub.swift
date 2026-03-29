import OSLog

/// A hub that creates and vends category-specific `Logger` instances
/// within a single subsystem.
///
/// Create one `LoggerHub` per subsystem (typically one per app or framework),
/// then access category loggers as properties or via subscript.
///
/// ```swift
/// // Define once — e.g. in a dedicated Logger.swift file in your app/package
/// let Log = LoggerHub(subsystem: "com.mycompany.MyApp")
///
/// // Use anywhere
/// Log.network.info("Request started: \(url, privacy: .public)")
/// Log.auth.debug("Signing in: \(email, privacy: .private)")
/// Log.data.error("Save failed: \(error)")
/// Log["Import"].notice("Batch completed: \(count, privacy: .public) items")
/// ```
///
/// ## Log Levels
/// | Level    | Description                          | Persisted |
/// |----------|--------------------------------------|-----------|
/// | `.debug`  | Development only — compiled out in Release | No |
/// | `.info`   | General information                  | No        |
/// | `.notice` | Important events                     | Yes       |
/// | `.warning`| Potential issues                     | Yes       |
/// | `.error`  | Errors that need attention           | Yes       |
/// | `.fault`  | Critical failures (highlighted)      | Yes       |
///
/// ## Privacy Annotations
/// ```swift
/// logger.info("User: \(name, privacy: .private)")       // redacted in release
/// logger.info("Count: \(n, privacy: .public)")          // always visible
/// logger.info("Token: \(token, privacy: .sensitive)")   // always redacted
/// logger.info("ID: \(id, privacy: .private(mask: .hash))") // hashed
/// ```
///
/// ## Console.app / log stream
/// ```
/// log stream --predicate 'subsystem == "com.mycompany.MyApp"' --level debug
/// log stream --predicate 'subsystem == "com.mycompany.MyApp" AND category == "Network"'
/// ```
public struct LoggerHub: Sendable {

    // MARK: - Properties

    /// The OSLog subsystem, typically a reverse-DNS identifier.
    public let subsystem: String

    // MARK: - Init

    /// Creates a hub for the given subsystem.
    /// - Parameter subsystem: A reverse-DNS string identifying the subsystem,
    ///   e.g. `"com.mycompany.MyApp"` or `"com.mycompany.NetworkKit"`.
    public init(subsystem: String) {
        self.subsystem = subsystem
    }

    // MARK: - Factory

    /// Returns a `Logger` for an arbitrary category string.
    public func logger(for category: String) -> Logger {
        Logger(subsystem: subsystem, category: category)
    }

    /// Subscript shorthand for custom categories.
    ///
    /// ```swift
    /// Log["Migration"].notice("Schema v3 applied")
    /// ```
    public subscript(category: String) -> Logger {
        logger(for: category)
    }

    // MARK: - Predefined Categories

    /// General-purpose logging for events that don't fit a specific category.
    public var general: Logger { logger(for: "General") }

    /// Network requests, responses, and connectivity events.
    public var network: Logger { logger(for: "Network") }

    /// Authentication, sessions, and authorization flows.
    public var auth: Logger { logger(for: "Auth") }

    /// Data operations: persistence, caching, migrations.
    public var data: Logger { logger(for: "Data") }

    /// UI events, navigation, and view lifecycle.
    public var ui: Logger { logger(for: "UI") }

    /// Performance measurements and profiling markers.
    public var performance: Logger { logger(for: "Performance") }
}
