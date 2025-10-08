#if !LocalizedTimestamp && canImport(FoundationEssentials)
	import FoundationEssentials
#else
	import Foundation
#endif

enum Formatter {
	static func format(date: Date) -> String {
		#if LocalizedTimestamp
			dateFormatter.string(from: date)
		#else
			date.ISO8601Format(.init(
				dateSeparator: .dash,
				dateTimeSeparator: .space,
				timeSeparator: .colon,
				timeZone: .current,
			))
		#endif
	}
}

#if LocalizedTimestamp
	private extension Formatter {
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
	}
#endif
