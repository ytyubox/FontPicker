// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "FontPicker",
    products: [
        .library(
            name: "FontPicker",
            targets: ["FontPicker"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "FontPicker",
            dependencies: []),
        .testTarget(
            name: "FontPickerTests",
            dependencies: ["FontPicker"]),
    ]
)
