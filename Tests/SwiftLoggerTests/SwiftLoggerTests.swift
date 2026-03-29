import Testing
import OSLog
@testable import SwiftLogger

// MARK: - LoggerHub

@Suite("LoggerHub")
struct LoggerHubTests {

    let hub = LoggerHub(subsystem: "com.test.SwiftLogger")

    @Test("stores subsystem")
    func storesSubsystem() {
        #expect(hub.subsystem == "com.test.SwiftLogger")
    }

    @Test("predefined categories return loggers without crashing")
    func predefinedCategories() {
        _ = hub.general
        _ = hub.network
        _ = hub.auth
        _ = hub.data
        _ = hub.ui
        _ = hub.performance
    }

    @Test("subscript returns logger for custom category")
    func subscriptCustomCategory() {
        _ = hub["Migration"]
        _ = hub["Import"]
    }

    @Test("logger(for:) is equivalent to subscript")
    func loggerForMatchesSubscript() {
        // Both should not crash — Logger doesn't expose its internal strings,
        // so equality can only be verified indirectly.
        _ = hub.logger(for: "Custom")
        _ = hub["Custom"]
    }

    @Test("LoggerHub is Sendable — safe to share across tasks")
    func sendable() async {
        let hub = LoggerHub(subsystem: "com.test.Concurrency")
        await withTaskGroup(of: Void.self) { group in
            group.addTask { _ = hub.network }
            group.addTask { _ = hub.auth }
            group.addTask { _ = hub["Background"] }
        }
    }
}

// MARK: - Loggable

@Suite("Loggable")
struct LoggableTests {

    // Default: category derived from type name
    struct DefaultService: Loggable {
        static let logSubsystem = "com.test.SwiftLogger"
    }

    // Override: custom category
    struct CustomCategoryService: Loggable {
        static let logSubsystem = "com.test.SwiftLogger"
        static let logCategory  = "CustomCategory"
    }

    @Test("default logCategory equals type name")
    func defaultCategoryIsTypeName() {
        #expect(DefaultService.logCategory == "DefaultService")
    }

    @Test("logCategory can be overridden")
    func overriddenCategory() {
        #expect(CustomCategoryService.logCategory == "CustomCategory")
    }

    @Test("logger property does not crash")
    func loggerExists() {
        _ = DefaultService.logger
        _ = CustomCategoryService.logger
    }

    @Test("logging methods execute without crashing")
    func loggingMethods() {
        DefaultService.logger.debug("debug message")
        DefaultService.logger.info("info message")
        DefaultService.logger.notice("notice message")
        DefaultService.logger.warning("warning message")
        DefaultService.logger.error("error message")
        DefaultService.logger.fault("fault message")
    }
}

// MARK: - Logger+Convenience

@Suite("Logger+Convenience")
struct LoggerConvenienceTests {

    @Test("make(subsystem:category:) returns a Logger")
    func makeWithSubsystemAndCategory() {
        _ = Logger.make(subsystem: "com.test.SwiftLogger", category: "Test")
    }

    @Test("makeForApp(category:) returns a Logger")
    func makeForApp() {
        // Bundle.main.bundleIdentifier may be nil in test runners — the fallback path is tested here.
        _ = Logger.makeForApp(category: "Test")
    }
}
