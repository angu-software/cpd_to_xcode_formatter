// The Swift Programming Language
// https://docs.swift.org/swift-book

import ArgumentParser

@main
struct CpdXcFormat: ParsableCommand {

    @Argument var inputFormat: String

    mutating func run() throws {
        print("Hello, world!")
    }
}
