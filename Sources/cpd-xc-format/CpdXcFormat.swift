// The Swift Programming Language
// https://docs.swift.org/swift-book

import ArgumentParser

@main
struct CpdXcFormat: ParsableCommand {

    @Argument(help: "The path to the file containing the cpd csv output")
    var filePath: String

    mutating func run() throws {
        print("Hello, world!")
    }
}
