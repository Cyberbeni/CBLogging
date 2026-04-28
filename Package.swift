// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "CBLogging",
	platforms: [.macOS(.v12)],
	products: [
		.library(
			name: "CBLogging",
			targets: ["CBLogging"],
		),
	],
	traits: [
		.init(
			name: "LocalizedTimestamp",
			description: "Import Foundation and use current Locale to format the timestamp.",
		),
	],
	dependencies: [
		.package(url: "https://github.com/apple/swift-log", from: "1.12.0"),
		// Plugins:
		.package(url: "https://codeberg.org/Cyberbeni/SwiftFormat-mirror", from: "0.60.1"),
	],
	targets: [
		.target(
			name: "CBLogging",
			dependencies: [
				.product(name: "Logging", package: "swift-log"),
			],
			swiftSettings: [
				.treatAllWarnings(as: .error, .when(configuration: .release)),
				.enableUpcomingFeature("NonisolatedNonsendingByDefault"),
			],
		),
		.testTarget(
			name: "FormatterTests",
			dependencies: [
				"CBLogging",
			],
		),
	],
)
