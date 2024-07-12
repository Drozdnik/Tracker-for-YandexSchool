// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Tracker-for-YandexSchool",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Tracker-for-YandexSchool",
            targets: ["Tracker-for-YandexSchool"]),
    ],
    dependencies: [
        .package(url: "https://github.com/CocoaLumberjack/CocoaLumberjack.git", from: "3.7.0"),
        .package(path: "./FileCache")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Tracker-for-YandexSchool",
            dependencies: [
                "CocoaLumberjack",
                "FileCache"
            ]),
        .testTarget(
            name: "Tracker-for-YandexSchoolTests",
            dependencies: ["Tracker-for-YandexSchool"]),
    ]
)
