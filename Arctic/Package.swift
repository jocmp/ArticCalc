// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Arctic",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Arctic",
            targets: ["Arctic"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/Flight-School/Money",
            from: "1.3.0"
        ),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Arctic",
            dependencies: ["Money"]),
        .testTarget(
            name: "ArcticTests",
            dependencies: ["Arctic"]),
    ]
)
