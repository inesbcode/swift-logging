import OSLog

/// A protocol for types that carry their own `Logger`.
///
/// Conform to `Loggable` to get a logger automatically scoped to
/// the type's name as the category.
///
/// ```swift
/// // In your app or package
/// final class NetworkService: Loggable {
///     static let logSubsystem = "com.mycompany.MyApp"
///     // logCategory defaults to "NetworkService"
///     // logger    defaults to Logger(subsystem: "com.mycompany.MyApp", category: "NetworkService")
///
///     func fetch(_ url: URL) async throws -> Data {
///         Self.logger.info("Fetching \(url, privacy: .public)")
///         // ...
///     }
/// }
/// ```
///
/// Override `logCategory` when you want a custom category name:
/// ```swift
/// final class LegacyAdapter: Loggable {
///     static let logSubsystem = "com.mycompany.MyApp"
///     static let logCategory  = "Adapter"
/// }
/// ```
public protocol Loggable {
    /// The OSLog subsystem — typically a reverse-DNS app or framework identifier.
    static var logSubsystem: String { get }

    /// The OSLog category — defaults to the type name.
    static var logCategory: String { get }

    /// The `Logger` instance for this type.
    static var logger: Logger { get }
}

public extension Loggable {
    static var logCategory: String { String(describing: Self.self) }
    static var logger: Logger { Logger(subsystem: logSubsystem, category: logCategory) }
}
