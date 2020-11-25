import XCTest
import Logging
import Foundation
@testable import ExtendedLogging

final class ExtendedLoggingTests: XCTestCase {
    func testFileLoggerShoulCreateFileWithSimpleLog() {
        // Arrange.
        LoggingSystem.bootstrap { label -> LogHandler in
            FileLogger(label: label, path: "tests01.log", level: .debug)
        }
        
        let logger = Logger(label: "mikroservices.mczachurski.dev")

        // Act.
        logger.info("Hello World!")
        sleep(5)
        
        // Assert.
        let filePath = getFilePathWithDateStamp(fileName: URL(string: "tests01.log")!)
        
        let fileHandle = try? FileHandle(forReadingFrom: filePath)
        XCTAssertNotNil(fileHandle, "Error during creating file hander (file: \(filePath.absoluteString))")
        
        let fileData = fileHandle!.readDataToEndOfFile()
        XCTAssertNotNil(fileData, "Error during reading content from file (file: \(filePath.absoluteString))")
        
        let content = String(data: fileData, encoding: .utf8)
        XCTAssertTrue(content!.contains("[INFO] (mikroservices.mczachurski.dev): Hello World!"))
    }
    
    func testFileLoggerRotateLogFiles() {
        // Arrange.  
        let fileManager = FileManager.default
        let filePath = getFilePathWithDateStamp(fileName: URL(string: "rotate.log")!)
        var filePath2 = URL(fileURLWithPath:filePath.path)
        
        // clean up...
        let pathExtension = filePath.pathExtension
        filePath2.deletePathExtension()
        filePath2.appendPathExtension("000." + pathExtension)

        try? fileManager.removeItem(at: filePath)
        try? fileManager.removeItem(at: filePath2)
        
        // Act.
        let logger = FileLogger(label: "mikroservices.mczachurski.dev", 
                                path: "rotate.log", 
                                level: .debug,
                                rollingInterval: .day,
                                fileSizeLimitBytes: 10000)
        

        for _ in 1...200 {
            logger.log(level: .info, message: "Hello World!", metadata:nil, file: #file, function: "testFileLoggerRotateLogFiles", line: #line)
        }
        
        // wait for async writes to complete
        logger.wait()
        
        // Assert.
        let fileHandle = try? FileHandle(forReadingFrom: filePath)
        XCTAssertNotNil(fileHandle, "Log file missing at (file: \(filePath.path))")
        
        
        let rotatedFileHandle = try? FileHandle(forReadingFrom: filePath2)
        XCTAssertNotNil(rotatedFileHandle, "Log file missing at (file: \(filePath2.path))")
    }

    private func getFilePathWithDateStamp(fileName: URL) -> URL {
        var filePath = fileName
        let pathExtension = filePath.pathExtension
        let timeStamp = getTimeStamp()
        
        filePath.deletePathExtension()
        filePath.appendPathExtension(timeStamp + "." + pathExtension)
        
        return filePath
    }
    
    private func getTimeStamp() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = RollingInteval.day.rawValue
        return dateFormatter.string(from: Date())
    }
}
