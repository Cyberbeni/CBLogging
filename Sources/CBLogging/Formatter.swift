#if !LocalizedTimestamp && canImport(FoundationEssentials)
	import FoundationEssentials
#else
	import Foundation
#endif

enum Formatter {
	static func format(date: Date) -> String {
		#if LocalizedTimestamp
			if let dateFormatter {
				dateFormatter.string(from: date)
			} else {
				date.ISO8601Format(.init(
					dateSeparator: .dash,
					dateTimeSeparator: .space,
					timeSeparator: .colon,
					timeZone: .current,
				))
			}
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
		static let userLocale: Locale? = if let localeId = ProcessInfo.processInfo.environment["LANG"] {
			.init(identifier: localeId)
		} else if Locale.current.identifier != "en_001" {
			.current
		} else {
			nil
		}

		static let dateFormatter: DateFormatter? = {
			if let userLocale {
				let formatter = DateFormatter()
				formatter.locale = userLocale
				formatter.dateStyle = .short
				formatter.timeStyle = .medium
				return formatter
			} else {
				return nil
			}
		}()
	}
#endif
