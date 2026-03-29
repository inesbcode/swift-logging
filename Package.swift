// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "swift-logging",
    platforms: [
        .iOS(.v16),
        .macOS(.v13),
        .tvOS(.v16),
        .watchOS(.v9),
        .visionOS(.v1),
    ],
    products: [
        .library(
            name: "Logging",
            targets: ["Logging"]
        ),
    ],
    targets: [
        .target(
            name: "Logging",
            swiftSettings: [
                .swiftLanguageVersion(.v6),
            ]
        ),
        .testTarget(
            name: "LoggingTests",
            dependencies: ["Logging"],
            swiftSettings: [
                .swiftLanguageVersion(.v6),
            ]
        ),
    ]
)
