// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MoodleAPI",
    platforms: [.macOS(.v10_12)],
    products: [
        .library(name: "MoodleAPI", targets: ["MoodleAPI"])
    ],
    dependencies: [
        .package(url: "https://github.com/scinfu/SwiftSoup.git", from: "2.3.2"),
        .package(url: "https://github.com/weichsel/ZIPFoundation.git", .upToNextMajor(from: "0.9.0")),
        .package(url: "https://github.com/simon2204/FormData.git", branch: "main")
    ],
    targets: [
        .target(
            name: "MoodleAPI",
            dependencies: ["SwiftSoup", "ZIPFoundation", "FormData"]),
        .testTarget(
            name: "MoodleAPITests",
            dependencies: ["MoodleAPI"]),
    ]
)
