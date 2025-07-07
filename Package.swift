// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "SoireesUI",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "SoireesUI",
            targets: ["SoireesUI"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-snapshot-testing", from: "1.12.0"),
        .package(url: "https://github.com/realm/SwiftLint", from: "0.50.0")
    ],
    targets: [
        .target(
            name: "SoireesUI",
            dependencies: [],
            path: "Sources/SoireesUI",
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "SoireesUITests",
            dependencies: [
                "SoireesUI",
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing")
            ],
            path: "Tests/SoireesUITests"
        ),
    ]
) 