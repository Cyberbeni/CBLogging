// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "CBLogging",
	products: [
		.library(
			name: "CBLogging",
			targets: ["CBLogging"]
		),
	],
	dependencies: [
		.package(url: "https://github.com/apple/swift-log", from: "1.6.3"),
	],
	targets: [
		.target(
			name: "CBLogging",
			dependencies: [
				.product(name: "Logging", package: "swift-log"),
			],
		),
	]
)
