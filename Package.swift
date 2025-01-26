// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ApiStocks",
    platforms: [
        .iOS(.v13),.macOS(.v12), .watchOS(.v8)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "ApiStocks",
            targets: ["ApiStocks"]),
        .executable(name: "ApiStocksExec", targets: ["ApiStocksExec"])
    ],
    dependencies: [
            .package(url: "https://github.com/swiftpackages/DotEnv.git", from: "3.0.0"),
        ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        
        .target(
            name: "ApiStocks",
            dependencies: [
                            .product(name: "DotEnv", package: "DotEnv"),
                        ]
            ),
        
        .executableTarget(name: "ApiStocksExec", dependencies: ["ApiStocks"]),
        .testTarget(
            name: "ApiStocksTests",
            dependencies: ["ApiStocks"]),
    ]
)
