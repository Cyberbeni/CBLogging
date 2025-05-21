public extension Logger {
	func error(
		_ error: Error, 
		file: String = #fileID,
		function: String = #function,
		line: UInt = #line
	) {
		self.log(level: .error, "\(error)", file: file, function: function, line: line)
	}
}
