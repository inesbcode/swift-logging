import Testing
import OSLog
@testable import Logging

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
        Logging.subsystem = "com.test.custom"
        _ = Logging.general
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
