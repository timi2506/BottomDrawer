// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "BottomDrawer",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "BottomDrawer",
            targets: ["BottomDrawer"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "BottomDrawer",
            dependencies: [],
            path: "Sources/BottomDrawer",
            resources: []
        )
    ]
)
