// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-dyna",
   
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        
        .library(
            name: "SwiftDyna",
            targets: ["SwiftDyna"]),
    ], 
    dependencies: [.package(url: "https://github.com/apple/swift-algorithms.git", from: "1.2.0"),
                   .package(url: "https://github.com/apple/swift-collections.git", .upToNextMajor(from: "1.0.6")),],
    
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SwiftDyna",
            dependencies: [.product(name: "Algorithms", package: "swift-algorithms"),
                           .product(name: "Collections", package: "swift-collections")]),
       
        .testTarget(
            name: "SwiftDynaTests",
            dependencies: ["SwiftDyna"]),
    ]
)
