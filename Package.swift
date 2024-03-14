// swift-tools-version: 5.8

// WARNING:
// This file is automatically generated.
// Do not edit it by hand because the contents will be replaced.

import PackageDescription
import AppleProductTypes

let package = Package(
    name: "Calendar",
    platforms: [
        .iOS("16.0")
    ],
    products: [
        .iOSApplication(
            name: "Calendar",
            targets: ["AppModule"],
            bundleIdentifier: "rodionrostovshchikov.Calendar",
            teamIdentifier: "AL4JP2496S",
            displayVersion: "1.0",
            bundleVersion: "1",
            appIcon: .placeholder(icon: .coffee),
            accentColor: .presetColor(.pink),
            supportedDeviceFamilies: [
                .pad,
                .phone
            ],
            supportedInterfaceOrientations: [
                .portrait,
                .landscapeRight,
                .landscapeLeft,
                .portraitUpsideDown(.when(deviceFamilies: [.pad]))
            ]
        )
    ],
    targets: [
        .executableTarget(
            name: "AppModule",
            path: "."
        )
    ]
)