// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TestbenchMoodleAPI",
    platforms: [.macOS(.v10_11)],
    dependencies: [
        .package(url: "https://github.com/scinfu/SwiftSoup.git", from: "2.3.2"),
        .package(url: "https://github.com/weichsel/ZIPFoundation.git", .upToNextMajor(from: "0.9.0"))
    ],
    targets: [
        .target(
            name: "TestbenchMoodleAPI",
            dependencies: ["SwiftSoup", "ZIPFoundation"]),
        .testTarget(
            name: "TestbenchMoodleAPITests",
            dependencies: ["TestbenchMoodleAPI"]),
    ]
)
