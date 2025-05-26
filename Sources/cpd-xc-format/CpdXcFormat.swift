// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

import ArgumentParser

import XCFormatter

@main
struct CpdXcFormat: ParsableCommand {

    @Argument(help: "The path to the file containing the cpd csv output")
    var filePath: String

    mutating func run() throws {
        let fileURL = URL(filePath: filePath, directoryHint: .notDirectory)
        let fileContent = try String(contentsOf: fileURL,
                                     encoding: .utf8)
        let xcFormat = format(fileContent)

        print(xcFormat)
    }
}
