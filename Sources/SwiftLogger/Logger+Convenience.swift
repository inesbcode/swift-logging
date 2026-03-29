import OSLog

public extension Logger {

    // MARK: - Factory helpers

    /// Creates a `Logger` with an explicit subsystem and category.
    ///
    /// Equivalent to `Logger(subsystem:category:)` but reads more naturally
    /// at the call site:
    /// ```swift
    /// static let log = Logger.make(subsystem: "com.mycompany.MyApp", category: "Auth")
    /// ```
    static func make(subsystem: String, category: String) -> Logger {
        Logger(subsystem: subsystem, category: category)
    }

    /// Creates a `Logger` using `Bundle.main.bundleIdentifier` as the subsystem.
    ///
    /// Convenient for **app targets** where the bundle identifier is available at runtime.
    /// Do **not** call this from a Swift package that has no `Bundle.main`
    /// (e.g. a library target running in tests outside a host app).
    ///
    /// ```swift
    /// // In an app target:
    /// static let log = Logger.makeForApp(category: "Onboarding")
    /// ```
    static func makeForApp(category: String) -> Logger {
        let subsystem = Bundle.main.bundleIdentifier ?? "com.unknown"
        return Logger(subsystem: subsystem, category: category)
    }

    // MARK: - OSSignpost helpers

    /// Emits a point-of-interest signpost visible in Instruments.
    ///
    /// ```swift
    /// Logger.make(subsystem: "com.myapp", category: "perf")
    ///     .poi("Heavy computation finished")
    /// ```
    func poi(_ message: StaticString) {
        let log = OSLog(subsystem: "com.apple.dt.instruments", category: .pointsOfInterest)
        os_signpost(.event, log: log, name: message)
    }
}
