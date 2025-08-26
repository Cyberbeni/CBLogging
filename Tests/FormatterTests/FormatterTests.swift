@testable import CBLogging
import Testing
import Foundation

struct FormatterTests {
	init() {
		setenv("LANG", "hu", 1)
	}

	@Test
	func specificDate() throws {
		let date = try #require(Calendar.current.date(from: .init(year: 2025, month: 1, day: 2, hour: 13, minute: 45, second: 56)))
		#if LocalizedTimestamp
			#expect(Formatter.format(date: date) == "2025. 01. 02. 13:45:56")
		#else
			#expect(Formatter.format(date: date).hasPrefix("2025-01-02 13:45:56"))
		#endif
	}
}

