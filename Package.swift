// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "cpd_to_xcode_formatter",
    platforms: [.macOS(.v13)],
    targets: [
        .executableTarget(
            name: "cpd_xc_format",
            dependencies: [.target(name: "XCFormatter")]
        ),
        .target(
            name: "XCFormatter"
        ),
        .testTarget(
            name: "XCFormatterTests",
            dependencies: [.target(name: "XCFormatter")]
        )
    ]
)
