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

    @Test
    func shoult_print_duplications_in_xcode_format() throws {
        let filePath = try #require(Bundle.module.path(forResource: "duplicates", ofType: "csv"))
        try executable.run(arguments: filePath)

        #expect(executable.runResult?.stdOut == """
                ### Duplication #1
                ### 3 lines with 844 tokens in 2 files
                /path/file1.swift:955:0: warning: 📑 Line equal with file2.swift:217:0
                /path/file1.swift:956:0: warning: 📑 Line equal with file2.swift:218:0
                /path/file1.swift:957:0: warning: 📑 Line equal with file2.swift:219:0
                /path/file2.swift:217:0: warning: 📑 Line equal with file1.swift:955:0
                /path/file2.swift:218:0: warning: 📑 Line equal with file1.swift:956:0
                /path/file2.swift:219:0: warning: 📑 Line equal with file1.swift:957:0
                ### Summary
                ### 1 duplications in 2 files
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
