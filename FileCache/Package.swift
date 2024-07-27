// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "FileCache",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "FileCache",
            targets: ["FileCache"]),
    ],
    dependencies: [
        .package(url: "https://github.com/CocoaLumberjack/CocoaLumberjack.git", from: "3.7.0")
    ],
    targets: [
        .target(
            name: "FileCache",
            dependencies: [
                .product(name: "CocoaLumberjackSwift", package: "CocoaLumberjack")
            ]),
        .testTarget(
            name: "FileCacheTests",
            dependencies: ["FileCache"]),
    ]
)
