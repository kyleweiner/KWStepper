// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "KWStepper",
    platforms: [
        .iOS(.v8)
    ],
    products: [
        .library(name: "KWStepper", targets: ["KWStepper"]),
    ],
    targets: [
        .target(name: "KWStepper", path: "Source"),
        .testTarget(
            name: "KWStepperTests",
            dependencies: ["KWStepper"],
            path: "KWStepper/KWStepperTests"
        ),
    ]
)
