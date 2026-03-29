// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "swift-logger",
    platforms: [
        .iOS(.v16),
        .macOS(.v13),
        .tvOS(.v16),
        .watchOS(.v9),
        .visionOS(.v1),
    ],
    products: [
        .library(
            name: "SwiftLogger",
            targets: ["SwiftLogger"]
        ),
    ],
    targets: [
        .target(
            name: "SwiftLogger"
        ),
        .testTarget(
            name: "SwiftLoggerTests",
            dependencies: ["SwiftLogger"]
        ),
    ]
)
