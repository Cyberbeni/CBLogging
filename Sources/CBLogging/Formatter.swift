#if LocalizedTimestamp || !canImport(FoundationEssentials)
	import Foundation
#else
	import FoundationEssentials
	#if canImport(Musl)
		import Musl
	#elseif canImport(Glibc)
		import Glibc
	#endif
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
			#if canImport(FoundationEssentials)
				// https://forums.swift.org/t/is-timezone-current-expected-to-work-with-import-foundationessentials/86270
				var timeZone = TimeZone.current
				if timeZone.identifier == "GMT",
				   case var time = time_t(date.timeIntervalSince1970),
				   case var timeinfo = tm(),
				   case _ = localtime_r(&time, &timeinfo),
				   let actualTimeZone = TimeZone(secondsFromGMT: timeinfo.tm_gmtoff)
				{
					timeZone = actualTimeZone
				}
			#else
				let timeZone = TimeZone.current
			#endif
			return date.ISO8601Format(.init(
				dateSeparator: .dash,
				dateTimeSeparator: .space,
				timeSeparator: .colon,
				timeZone: timeZone,
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
