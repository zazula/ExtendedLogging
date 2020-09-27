# :blue_book: ExtendedLogging

![Build Status](https://github.com/Mikroservices/ExtendedLogging/workflows/Build/badge.svg)
[![Swift 5.3](https://img.shields.io/badge/Swift-5.3-orange.svg?style=flat)](ttps://developer.apple.com/swift/)
[![Swift Package Manager](https://img.shields.io/badge/SPM-compatible-4BC51D.svg?style=flat)](https://swift.org/package-manager/)
[![Platforms OS X | Linux](https://img.shields.io/badge/Platforms-OS%20X%20%7C%20Linux%20-lightgray.svg?style=flat)](https://developer.apple.com/swift/)

Library provides additional LogHandlers for Swift Loggig system. Log hander can write information into file.
You can chose one of following formatters:
 - SingleLineFormatter - writes each log as single plain line in file,
 - JsonFormatter - writes each log as JSON data.

## Getting started

You need to add library to `Package.swift` file:

 - add package to dependencies:
```swift
.package(url: "https://github.com/Mikroservices/ExtendedLogging.git", from: "1.0.0")
```

- and add product to your target:
```swift
.target(name: "App", dependencies: [
    .product(name: "Vapor", package: "vapor"),
    .product(name: "ExtendedLogging", package: "ExtendedLogging")
])
```

Then you can add log hander to Logging system:

```swift
LoggingSystem.bootstrap { label -> LogHandler in
    FileLogger(label: label, path: "tests01.log", level: .debug)
}
```

Also you can combine multiple LogHandlers:

```swift
LoggingSystem.bootstrap { label -> LogHandler in
    MultiplexLogHandler([
        ConsoleLogger(label: label, console: Terminal(), level: .debug),
        FileLogger(label: label,
                   path: "Logs/emails.log",
                   level: .debug,
                   logFormatter: JsonFormatter(),
                   rollingInterval: .month, 
                   fileSizeLimitBytes: 10485760
        )
    ])
}
```

And now you can use stadard logging system to log information:

```swift
let logger = Logger(label: "mikroservices.mczachurski.dev")
logger.info("Hello World!")
```

Some frameworks creates `Logger` for you. For example in `Vapor` you should initialize `LoggingSystem` at the top of `main.swift` file and use it in your application like this:

```swift
request.logger.info("Hello World!")
```

## Developing

Download the source code and run in command line:

```bash
$ git clone https://github.com/Mikroservices/ExtendedLogging.git
$ swift package update
$ swift build
```

Run the following command if you want to open project in Xcode:

```bash
$ open Package.swift
```

## Contributing

You can fork and clone repository. Do your changes and pull a request.
