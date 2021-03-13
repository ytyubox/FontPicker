// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "FontPicker",
    platforms: [SupportedPlatform.macOS(.v10_15)],
    products: [
        .library(
            name: "FontPicker",
            targets: ["FontPicker"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/ytyubox/LoadingSystem", from: "1.0.0"),
        .package(url: "https://github.com/ytyubox/TestUtils", from: "1.0.0"),
        .package(name: "Difference", url: "https://github.com/krzysztofzablocki/Difference.git", .branch("master")),
    ],
    targets: [
        .target(
            name: "FontPicker",
            dependencies: [
                "LoadingSystem",
            ]
        ),
        .testTarget(
            name: "FontPickerTests",
            dependencies: ["FontPicker", "LoadingSystem", "TestUtils", "Difference"]
        ),
        .testTarget(
            name: "FontPickerIntegrationTests",
            dependencies: ["FontPicker", "LoadingSystem", "TestUtils"]
        ),
    ]
)
