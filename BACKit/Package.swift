// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "BACKit",
    platforms: [.iOS(.v17), .watchOS(.v10), .macOS(.v14)],
    products: [
        .library(name: "BACKit", targets: ["BACKit"])
    ],
    targets: [
        .target(name: "BACKit"),
        .testTarget(name: "BACKitTests", dependencies: ["BACKit"])
    ]
)
