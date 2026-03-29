import Testing
import OSLog
@testable import Logging

// MARK: - Logging enum

@Suite("Logging")
struct LoggingTests {

    @Test("all predefined category loggers are accessible without crashing")
    func predefinedCategories() {
        _ = Logging.general
        _ = Logging.network
        _ = Logging.api
        _ = Logging.auth
        _ = Logging.user
        _ = Logging.data
        _ = Logging.cache
        _ = Logging.ui
        _ = Logging.navigation
        _ = Logging.performance
        _ = Logging.lifecycle
    }

    @Test("subsystem can be changed before first log call")
    func subsystemIsConfigurable() {
        let previous = Logging.subsystem
        Logging.subsystem = "com.test.CustomSubsystem"
        _ = Logging.general  // picks up new subsystem
        Logging.subsystem = previous
    }

    @Test("all log levels execute without crashing")
    func logLevels() {
        Logging.general.debug("debug")
        Logging.general.info("info")
        Logging.general.notice("notice")
        Logging.general.warning("warning")
        Logging.general.error("error")
        Logging.general.fault("fault")
    }

    @Test("loggers are safe to call from concurrent tasks")
    func concurrencySafe() async {
        await withTaskGroup(of: Void.self) { group in
            group.addTask { Logging.network.info("concurrent network") }
            group.addTask { Logging.auth.info("concurrent auth") }
            group.addTask { Logging.data.info("concurrent data") }
        }
    }
}

// MARK: - Loggable

@Suite("Loggable")
struct LoggableTests {

    struct DefaultService: Loggable {
        static let logSubsystem = "com.test.Logging"
    }

    struct CustomCategoryService: Loggable {
        static let logSubsystem = "com.test.Logging"
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

    @Test("all log levels execute without crashing")
    func loggingMethods() {
        DefaultService.logger.debug("debug")
        DefaultService.logger.info("info")
        DefaultService.logger.notice("notice")
        DefaultService.logger.warning("warning")
        DefaultService.logger.error("error")
        DefaultService.logger.fault("fault")
    }
}

// MARK: - Logger+Convenience

@Suite("Logger+Convenience")
struct LoggerConvenienceTests {

    @Test("make(subsystem:category:) returns a Logger")
    func makeWithSubsystemAndCategory() {
        _ = Logger.make(subsystem: "com.test.Logging", category: "Test")
    }

    @Test("makeForApp(category:) falls back gracefully when no bundle ID")
    func makeForApp() {
        _ = Logger.makeForApp(category: "Test")
    }
}
