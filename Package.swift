// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "KWStepper",
    platforms: [
        .iOS(.v10)
    ],
    products: [
        .library(name: "KWStepper", targets: ["KWStepper"]),
    ],
    targets: [
        .target(name: "KWStepper", path: "Sources")
    ]
