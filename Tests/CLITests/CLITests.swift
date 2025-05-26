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
        self.executable = TestExecutable("cpd-xc-format")
    }

    @Test
    func should_print_usage() async throws {
        try executable.run(arguments: "--help")

        #expect(executable.runResult?.stdOut == """
            USAGE: cpd-xc-format <file-path>

            ARGUMENTS:
              <file-path>             The path to the file containing the cpd csv output

            OPTIONS:
              -h, --help              Show help information.
            """)
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
    let launchPath = Bundle(for: TestExecutable.self).bundlePath

    var executableURL: URL {
        return URL(filePath: launchPath,
                   directoryHint: .isDirectory)
        .deletingLastPathComponent()
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
        process.waitUntilExit()

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
