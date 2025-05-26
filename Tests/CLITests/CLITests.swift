//
//  CLITests.swift
//  cpd_to_xcode_formatter
//
//  Created by Andreas Günther on 26.05.25.
//

import Foundation

import Testing

struct CLITests {

    private let executable: TestExecutable

    init() {
        self.executable = TestExecutable("cpd_xc_format")
    }

    @Test
    func should_print_usage() async throws {
        try executable.run()

        #expect(executable.runResult == TestExecutable.RunResult(stdOut: "Hello, world!",
                                                                 statusCode: 0))
    }

}

final class TestExecutable {

    typealias ReturnCode = Int32

    struct RunResult: Equatable {
        var stdOut: String = ""
        var errOut: String = ""
        var statusCode: ReturnCode = 0
    }

    let name: String
    let launchPath = ProcessInfo.processInfo.environment["PWD"]!

    var executableURL: URL {
        return URL(filePath: launchPath,
                   directoryHint: .isDirectory)
        .appending(component: name,
                   directoryHint: .notDirectory)

    }

    private(set) var runResult: RunResult?

    init(_ name: String) {
        self.name = name
    }

    @discardableResult
    func run(arguments: String = "") throws -> ReturnCode {
        let argumentComponents = arguments.split(separator: " ").map { String($0) }
        return try run(arguments: argumentComponents)
    }

    @discardableResult
    func run(arguments: String...) throws -> ReturnCode {
        return try run(arguments: arguments)
    }

    @discardableResult
    func run(arguments: [String]) throws -> ReturnCode {
        let process = Process()
        process.executableURL = executableURL
        process.arguments = arguments

        let stdPipe = Pipe()
        let errPipe = Pipe()
        process.standardOutput = stdPipe
        process.standardError = errPipe

        try process.run()

        let stdData = stdPipe.fileHandleForReading.readDataToEndOfFile()
        let errData = errPipe.fileHandleForReading.readDataToEndOfFile()

        let stdString = String(data: stdData, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let errString = String(data: errData, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let returnCode = process.terminationStatus

        runResult = RunResult(stdOut: stdString,
                              errOut: errString,
                              statusCode: returnCode)

        return returnCode
    }
}
