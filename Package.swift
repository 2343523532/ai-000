// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "CosmicMind",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .executable(name: "CosmicMindCLI", targets: ["CosmicMindCLI"]),
        .library(name: "CosmicMindCore", targets: ["CosmicMindCore"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
    ],
    targets: [
        .target(
            name: "CosmicMindCore",
            dependencies: []),
        .executableTarget(
            name: "CosmicMindCLI",
            dependencies: ["CosmicMindCore"]),
        .testTarget(
            name: "CosmicMindCoreTests",
            dependencies: ["CosmicMindCore"]),
    ]
)
