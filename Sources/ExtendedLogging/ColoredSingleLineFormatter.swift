//
//  File.swift
//  
//
//  Created by Ralph Zazula on 11/8/20.
//

import Foundation
import Logging

public class ColoredSingleLineFormatter: LogFormatter {
    public var metadata = Logger.Metadata() {
        didSet {
            self.prettyMetadata = self.prettify(self.metadata)
        }
    }
    
    private var prettyMetadata: String?
    
    public init() {
    }
    
    public func format(label: String,
                       level: Logger.Level,
                       message: Logger.Message,
                       metadata: Logger.Metadata?,
                       file: String, function: String, line: UInt) -> Data? {
        
        let prettyMetadata = metadata?.isEmpty ?? true
            ? self.prettyMetadata
            : self.prettify(self.metadata.merging(metadata!, uniquingKeysWith: { _, new in new }))
        
        var message = "\(self.timestamp()) [\(level.name)] (\(label)\(prettyMetadata.map { ", \($0)" } ?? "")): \(message)\n"
        
        switch level {
            case .critical:
                message = message.brightYellow.bgRed.blink
            case .error:
                message = message.brightRed
            case .debug:
                message = message.blue
            case .info:
                message = message.green
            case .trace:
                message = message.gray
            case .warning:
                message = message.yellow
            case .notice:
                message = message.bgGreen
            
        }
        return message.data(using: .utf8)
    }
    
    private func prettify(_ metadata: Logger.Metadata) -> String? {
        return !metadata.isEmpty ? metadata.map { "\($0)=\($1)" }.joined(separator: " ") : nil
    }
    
    private func timestamp() -> String {
        var buffer = [Int8](repeating: 0, count: 255)
        var timestamp = time(nil)
        let localTime = localtime(&timestamp)
        strftime(&buffer, buffer.count, "%Y-%m-%dT%H:%M:%S%z", localTime)
        return buffer.withUnsafeBufferPointer {
            $0.withMemoryRebound(to: CChar.self) {
                String(cString: $0.baseAddress!)
            }
        }
    }
}

// colored text

enum ANSIColor: String {
    
    typealias This = ANSIColor
    
    case black = "\u{001B}[30m"
    case red = "\u{001B}[31m"
    case green = "\u{001B}[32m"
    case yellow = "\u{001B}[33m"
    case blue = "\u{001B}[34m"
    case magenta = "\u{001B}[35m"
    case cyan = "\u{001B}[36m"
    case white = "\u{001B}[37m"
    case gray = "\u{001B}[2m" // low intensity
    
    case brightBlack = "\u{001B}[30;1m"
    case brightRed = "\u{001B}[31;1m"
    case brightGreen = "\u{001B}[32;1m"
    case brightYellow = "\u{001B}[33;1m"
    case brightBlue = "\u{001B}[34;1m"
    case brightMagenta = "\u{001B}[35;1m"
    case brightCyan = "\u{001B}[36;1m"
    case brightWhite = "\u{001B}[37;1m"
    
    case bgBlack = "\u{001B}[40m"
    case bgRed = "\u{001B}[41m"
    case bgGreen = "\u{001B}[42m"
    case bgYellow = "\u{001B}[43m"
    case bgBlue = "\u{001B}[44m"
    case bgMagenta = "\u{001B}[45m"
    case bgCyan = "\u{001B}[46m"
    case bgWhite = "\u{001B}[47m"
    
    case bgBrightBlack = "\u{001B}[40;1m"
    case bgBrightRed = "\u{001B}[41;1m"
    case bgBrightGreen = "\u{001B}[42;1m"
    case bgBrightYellow = "\u{001B}[43;1m"
    case bgBrightBlue = "\u{001B}[44;1m"
    case bgBrightMagenta = "\u{001B}[45;1m"
    case bgBrightCyan = "\u{001B}[46;1m"
    case bgBrightWhite = "\u{001B}[47;1m"
    
    case `default` = "\u{001B}[0;0m"
    
    case blink = "\u{001B}[5m" // !!!
    case rapidBlink = "\u{001B}[6m"
    
    
    static func + (lhs: This, rhs: String) -> String {
        return lhs.rawValue + rhs
    }
    
    static func + (lhs: String, rhs: This) -> String {
        return lhs + rhs.rawValue
    }
    
}

extension String {
    
    func colored(_ color: ANSIColor) -> String {
        return color + self + ANSIColor.default
    }
    
    var black: String {
        return colored(.black)
    }
    
    var red: String {
        return colored(.red)
    }
    
    var green: String {
        return colored(.green)
    }
    
    var yellow: String {
        return colored(.yellow)
    }
    
    var blue: String {
        return colored(.blue)
    }
    
    var magenta: String {
        return colored(.magenta)
    }
    
    var cyan: String {
        return colored(.cyan)
    }
    
    var white: String {
        return colored(.white)
    }
    
    var brightBlack: String {
        return colored(.brightBlack)
    }
    
    var brightRed: String {
        return colored(.brightRed)
    }
    
    var brightGreen: String {
        return colored(.brightGreen)
    }
    
    var brightYellow: String {
        return colored(.brightYellow)
    }
    
    var brightBlue: String {
        return colored(.brightBlue)
    }
    
    var brightMagenta: String {
        return colored(.brightMagenta)
    }
    
    var brightCyan: String {
        return colored(.brightCyan)
    }
    
    var brightWhite: String {
        return colored(.white)
    }
    
    var gray: String {
        return colored(.gray)
    }
    
    var bgBlack: String {
        return colored(.bgBlack)
    }
    
    var bgRed: String {
        return colored(.bgRed)
    }
    
    var bgGreen: String {
        return colored(.bgGreen)
    }
    
    var bgYellow: String {
        return colored(.bgYellow)
    }
    
    var bgBlue: String {
        return colored(.bgBlue)
    }
    
    var bgMagenta: String {
        return colored(.bgMagenta)
    }
    
    var bgCyan: String {
        return colored(.bgCyan)
    }
    
    var bgWhite: String {
        return colored(.bgWhite)
    }
    
    var blink: String {
        return colored(.blink)
    }
    
    var rapidBlink:String {
        return colored(.rapidBlink)
    }
}

