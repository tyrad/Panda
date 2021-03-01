// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Panda",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Panda",
            targets: ["Panda"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/tristanhimmelman/ObjectMapper.git", .upToNextMajor(from: "4.1.0")),
        .package(url: "https://github.com/Moya/Moya.git", Package.Dependency.Requirement.exact("13.0.1")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Panda",
            dependencies: [
                "ObjectMapper", "Moya",
            ]),
        .testTarget(
            name: "PandaTests",
            dependencies: ["Panda"]),
    ])
