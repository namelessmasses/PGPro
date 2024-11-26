// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PGPro",
    defaultLocalization: "en",
    dependencies: [
        .package(url: "https://github.com/miximka/MimeParser", revision: "07eb0fc2f4386767ef8a8204963f8122a0889663"),
        .package(url: "https://github.com/krzyzanowskim/ObjectivePGP.git", revision: "0dc7ca7ffe193095dc37456b0c75be167a2026f4"),
        .package(url: "https://github.com/ivanvorobei/SPAlert", revision: "5fd3e2923d26f0f0b40f0e6c10fca458a61a73c4"),
        .package(url: "https://github.com/seanparsons/SwiftTryCatch.git", revision: "6a177252cfa2ef649b0aa7b2d16ab221386ca51c"),
        .package(url: "https://github.com/vtourraine/ThirdPartyMailer", revision: "0d9a82956105dd60a19caf5c8628669e9af91a05"),
        .package(url: "https://github.com/Xiaoye220/EmptyDataSet-Swift", revision: "ffaa10404b3c7582532887adc7a0f8558f656673")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "PGPro",
            dependencies: [
                "MimeParser",
                "ObjectivePGP",
                "SPAlert",
                "SwiftTryCatch",
                "ThirdPartyMailer",
                "EmptyDataSet-Swift"
            ],
            path: "PGPro"
        )
    ]
)
