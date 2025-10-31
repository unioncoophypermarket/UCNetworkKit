// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "UCNetworkKit",
    platforms: [
        .iOS(.v14),
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "UCNetworkKit",
            targets: ["UCNetworkKit"]
        )
    ],
    dependencies: [
        // Add dependencies here if needed, e.g.:
        // .package(url: "https://github.com/...", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "UCNetworkKit",
            dependencies: []
        ),
        .testTarget(
            name: "UCNetworkKitTests",
            dependencies: ["UCNetworkKit"]
        )
    ]
)
