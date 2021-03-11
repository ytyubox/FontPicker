// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "FontPicker",
    products: [
        .library(
            name: "FontPicker",
            targets: ["FontPicker"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ytyubox/LoadingSystem", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "FontPicker",
            dependencies: []),
        .testTarget(
            name: "FontPickerTests",
            dependencies: ["FontPicker", "LoadingSystem"]
        ),
        .testTarget(
            name: "FontPickerIntegrationTests",
            dependencies: ["FontPicker", "LoadingSystem"],
            resources: [.process("Resources")]
        ),
    ]
)
