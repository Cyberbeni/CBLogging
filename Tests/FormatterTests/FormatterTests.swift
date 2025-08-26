@testable import CBLogging
import Testing
import Foundation

struct FormatterTests {
	init() {
		setenv("LANG", "hu", 1)
	}

	@Test
	func specificDate() throws {
		#if LocalizedTimestamp
			let date = try #require(Calendar.current.date(from: .init(year: 2025, month: 1, day: 2, hour: 13, minute: 45, second: 56)))
			#expect(Formatter.format(date: date) == "2025. 01. 02. 13:45:56")
		#else
			let date = Date.init(timeIntervalSince1970: 1735825556)
			#expect(Formatter.format(date: date) == "2025-01-02 13:45:56Z")
		#endif
	}
}

