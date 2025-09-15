// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "ComoSdk",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "ComoSdk",
            targets: ["ComoSdk"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/revosystems/RevoHttp", .upToNextMinor(from: "0.3.9")),
        .package(url: "https://github.com/revosystems/RevoUIComponents.git", .upToNextMinor(from: "0.1.0")),
        .package(url: "https://github.com/revosystems/DejavuSwift.git", .upToNextMinor(from: "0.1.0")),
        .package(url: "https://github.com/marmelroy/PhoneNumberKit.git", .upToNextMinor(from: "4.1.4"))
    ],
    targets: [
        .target(
            name: "ComoSdk",
            dependencies: [
                "RevoHttp",
                "RevoUIComponents",
                "DejavuSwift",
                "PhoneNumberKit"
            ],
            path: "ComoSdk/src",
            resources: [
                .process("resources")
            ]
        ),
    ],
    swiftLanguageVersions: [.v5]
)
