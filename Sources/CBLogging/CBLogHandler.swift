import Foundation
@_exported import Logging

public struct CBLogHandler: LogHandler {
	private var prettyMetadata: String?
	public var logLevel: Logger.Level
	public var metadata = Logger.Metadata() {
		didSet {
			prettyMetadata = prettify(metadata)
		}
	}

	init(logLevel: Logger.Level) {
		self.logLevel = logLevel
	}

	public subscript(metadataKey metadataKey: String) -> Logger.Metadata.Value? {
		get {
			metadata[metadataKey]
		}
		set {
			metadata[metadataKey] = newValue
		}
	}

	public func log(
		level: Logger.Level,
		message: Logger.Message,
		metadata explicitMetadata: Logger.Metadata?,
		source _: String,
		file: String,
		function _: String,
		line: UInt
	) {
		let effectiveMetadata = prepareMetadata(
			base: metadata,
			provider: metadataProvider,
			explicit: explicitMetadata
		)

		let prettyMetadata: String? = if let effectiveMetadata {
			prettify(effectiveMetadata)
		} else {
			self.prettyMetadata
		}

		let timestamp = Self.dateFormatter.string(from: .now)

		print("\(timestamp) [\(level)] [\(file):\(line)] - \(message)\(prettyMetadata.map { "\nMetadata: \($0)" } ?? "")")
	}
}

public extension CBLogHandler {
	static let appLogger = Logger(label: "_")

	static func bootstrap(defaultLogLevel: Logger.Level, appLogLevel: Logger.Level) {
		LoggingSystem.bootstrap { label in
			switch label {
			case "_":
				CBLogHandler(logLevel: appLogLevel)
			default:
				CBLogHandler(logLevel: defaultLogLevel)
			}
		}
	}
}

private extension CBLogHandler {
	static let userLocale: Locale = if let localeId = ProcessInfo.processInfo.environment["LANG"] {
		.init(identifier: localeId)
	} else {
		.current
	}

	static let dateFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.locale = userLocale
		formatter.dateStyle = .short
		formatter.timeStyle = .medium
		return formatter
	}()

	func prettify(_ metadata: Logger.Metadata) -> String? {
		if metadata.isEmpty {
			nil
		} else {
			metadata.lazy.sorted(by: { $0.key < $1.key }).map { "\($0)=\($1)" }.joined(separator: " ")
		}
	}

	func prepareMetadata(
		base: Logger.Metadata,
		provider: Logger.MetadataProvider?,
		explicit: Logger.Metadata?
	) -> Logger.Metadata? {
		var metadata = base

		let provided = provider?.get() ?? [:]

		guard !provided.isEmpty || !((explicit ?? [:]).isEmpty) else {
			// all per-log-statement values are empty
			return nil
		}

		if !provided.isEmpty {
			metadata.merge(provided, uniquingKeysWith: { _, provided in provided })
		}

		if let explicit, !explicit.isEmpty {
			metadata.merge(explicit, uniquingKeysWith: { _, explicit in explicit })
		}

		return metadata
	}
}
