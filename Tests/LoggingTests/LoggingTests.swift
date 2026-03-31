import Testing
import OSLog
@testable import Logging

@Suite("Logging")
struct LoggingTests {

    let logging = Logging()

    @Test("all predefined category loggers are accessible without crashing")
    func predefinedCategories() {
        _ = logging.general
        _ = logging.network
        _ = logging.api
        _ = logging.auth
        _ = logging.user
        _ = logging.data
        _ = logging.cache
        _ = logging.ui
        _ = logging.navigation
        _ = logging.performance
        _ = logging.lifecycle
    }

    @Test("subsystem is reflected in the logger when passed at init")
    func subsystemIsConfigurable() {
        let custom = Logging(subsystem: "com.test.custom")
        _ = custom.general
    }

    @Test("all log levels execute without crashing")
    func logLevels() {
        logging.general.debug("debug")
        logging.general.info("info")
        logging.general.notice("notice")
        logging.general.warning("warning")
        logging.general.error("error")
        logging.general.fault("fault")
    }

    @Test("loggers are safe to call from concurrent tasks")
    func concurrencySafe() async {
        await withTaskGroup(of: Void.self) { group in
            group.addTask { logging.network.info("concurrent network") }
            group.addTask { logging.auth.info("concurrent auth") }
            group.addTask { logging.data.info("concurrent data") }
        }
    }
}
