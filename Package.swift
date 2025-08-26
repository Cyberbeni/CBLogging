// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "CBLogging",
	platforms: [.macOS(.v12)],
	products: [
		.library(
			name: "CBLogging",
			targets: ["CBLogging"]
		),
	],
	traits: [
		.init(
			name: "LocalizedTimestamp",
			description: "Import Foundation and use current Locale to format the timestamp."
		),
		.default(enabledTraits: ["LocalizedTimestamp"]),
	],
	dependencies: [
		.package(url: "https://github.com/apple/swift-log", from: "1.6.4"),
	],
	targets: [
		.target(
			name: "CBLogging",
			dependencies: [
				.product(name: "Logging", package: "swift-log"),
			],
		),
		.testTarget(
			name: "FormatterTests",
			dependencies: [
				"CBLogging"
			],
		)
	]
)
