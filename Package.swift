// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "BottomSheet",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "BottomSheet",
            targets: ["BottomSheet"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "BottomSheet",
            dependencies: [],
            path: "Sources/BottomSheet",
            resources: []
        )
    ]
)
