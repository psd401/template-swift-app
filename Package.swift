// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "TemplateApp",
    platforms: [.macOS(.v14)],
    products: [
        // Logic lives in the library so `swift test` can reach it.
        .library(name: "TemplateAppKit", targets: ["TemplateAppKit"]),
        // The app executable is a thin SwiftUI shell over the library.
        .executable(name: "TemplateApp", targets: ["TemplateApp"]),
    ],
    targets: [
        .target(name: "TemplateAppKit"),
        .executableTarget(
            name: "TemplateApp",
            dependencies: ["TemplateAppKit"]
        ),
        .testTarget(
            name: "TemplateAppKitTests",
            dependencies: ["TemplateAppKit"]
        ),
    ]
)
