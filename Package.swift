// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ApiStocks",
    platforms: [
        .iOS(.v13),.macOS(.v12), .macCatalyst(.v13), .tvOS(.v13), .watchOS(.v8)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "ApiStocks",
            targets: ["ApiStocks"]),
        .executable(name: "ApiStocksExec", targets: ["ApiStocksExec"])
    ],
   
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        
        .target(
            name: "ApiStocks"
            ),
        
        .executableTarget(name: "ApiStocksExec", dependencies: ["ApiStocks"]),
        .testTarget(
            name: "ApiStocksTests",
            dependencies: ["ApiStocks"]),
    ]
)
