// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SampleWebviewPackage",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "SampleWebviewPackage",
            targets: ["SampleWebviewPackage"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "SampleWebviewPackage",
            dependencies: [])
    ]
)
