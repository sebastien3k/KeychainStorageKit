// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "KeychainStorageKit",
    platforms: [
        .iOS(.v12),
        .macOS(.v10_13),
        .watchOS(.v4),
        .tvOS(.v12)
    ],
    products: [
        .library(
            name: "KeychainStorageKit",
            targets: ["KeychainStorageKit"]
        )
    ],
    targets: [
        .target(
            name: "KeychainStorageKit",
            path: "KeychainStorageKit"
        )
    ]
)
