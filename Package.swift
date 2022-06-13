// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BraveSwiftKit",
    platforms: [
        .macOS(SupportedPlatform.MacOSVersion.v10_15),
        .iOS(SupportedPlatform.IOSVersion.v15)
    ],
    products: [
        .library(
            name: "BraveSwiftKit",
            targets: ["BraveSwiftKit"]),
    ],
    dependencies: [
        
    ],
    targets: [
        .target(
            name: "BraveSwiftKit",
            dependencies: []),
        
        .testTarget(
            name: "BraveSwiftKitTests",
            dependencies: ["BraveSwiftKit"]),
    ]
)
