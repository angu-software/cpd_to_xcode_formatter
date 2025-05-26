// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "cpd_to_xcode_formatter",
    platforms: [.macOS(.v13)],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.5.0")
    ],
    targets: [
        .executableTarget(
            name: "cpd_xc_format",
            dependencies: [.target(name: "XCFormatter"),
                           .product(name: "ArgumentParser",
                                    package: "swift-argument-parser")]
        ),
        .target(
            name: "XCFormatter"
        ),
        .testTarget(
            name: "XCFormatterTests",
            dependencies: [.target(name: "XCFormatter")]
        ),
        .testTarget(
            name: "CLITests",
            dependencies: [.target(name: "cpd_xc_format")]
        )
    ]
)
