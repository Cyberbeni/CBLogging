Example usage:

```swift
import CBLogging

var Log: Logger { CBLogHandler.appLogger }

#if DEBUG
	CBLogHandler.bootstrap(defaultLogLevel: .info, appLogLevel: .debug)
#else
	CBLogHandler.bootstrap(defaultLogLevel: .notice, appLogLevel: .info)
#endif
```
