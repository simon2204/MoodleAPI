// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TestbenchMoodleAPI",
    dependencies: [
        .package(url: "https://github.com/scinfu/SwiftSoup.git", from: "2.3.2"),
    ],
    targets: [
        .target(
            name: "TestbenchMoodleAPI",
            dependencies: ["SwiftSoup"]),
        .testTarget(
            name: "TestbenchMoodleAPITests",
            dependencies: ["TestbenchMoodleAPI"]),
    ]
)
