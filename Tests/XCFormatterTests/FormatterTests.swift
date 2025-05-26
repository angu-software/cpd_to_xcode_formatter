//
//  FormatterTests.swift
//  cpd_to_xcode_formatter
//
//  Created by Andreas Günther on 23.05.25.
//

import Testing

@testable import XCFormatter

struct FormatterTests {

    @Test
    func should_format_cpd_csv_to_xcode() async throws {
        let source = """
                lines,tokens,occurrences
                3,844,2,955,/path/file1.swift,217,/path/file2.swift
                """

        let output = format(source)
        #expect(output == """
                ### Duplication #1
                ### 3 lines with 844 tokens in 2 files
                /path/file1.swift:955:0: warning: 📑 Line equal with file2.swift:217:0
                /path/file1.swift:956:0: warning: 📑 Line equal with file2.swift:218:0
                /path/file1.swift:957:0: warning: 📑 Line equal with file2.swift:219:0
                /path/file2.swift:217:0: warning: 📑 Line equal with file1.swift:955:0
                /path/file2.swift:218:0: warning: 📑 Line equal with file1.swift:956:0
                /path/file2.swift:219:0: warning: 📑 Line equal with file1.swift:957:0
                """)
    }
}

struct LocationFormattingTests {

    @Test
    func should_format_to_path_with_line_and_column() async throws {
        let location = CodeDuplication.Location(filePath: "/path/file.swift", begin: 3)

        let output = format(location, offset: 1)

        #expect(output == "/path/file.swift:4:0")
    }

    @Test
    func should_format_equal_code_locations_with_offset() {
        let location1 = CodeDuplication.Location(filePath: "/path/file1.swift", begin: 1)
        let location2 = CodeDuplication.Location(filePath: "/path/file2.swift", begin: 3)

        let output = format(location1, occuringIn: location2, offset: 1)

        #expect(output == "/path/file1.swift:2:0: warning: 📑 Line equal with file2.swift:4:0")
    }

    @Test
    func should_format_equal_code_locations_for_each_occurring_line() async throws {
        let location1 = CodeDuplication.Location(filePath: "/path/file1.swift", begin: 1)
        let location2 = CodeDuplication.Location(filePath: "/path/file2.swift", begin: 3)

        let output = format(location1, occuringIn: location2, length: 3)

        #expect(output == """
            /path/file1.swift:1:0: warning: 📑 Line equal with file2.swift:3:0
            /path/file1.swift:2:0: warning: 📑 Line equal with file2.swift:4:0
            /path/file1.swift:3:0: warning: 📑 Line equal with file2.swift:5:0
            """)
    }

    @Test
    func should_format_code_duplication() async throws {
        let duplication = CodeDuplication(length: 3,
                                          tokenCount: 0,
                                          locations: [
                                            CodeDuplication.Location(filePath: "/path/file1.swift", begin: 1),
                                            CodeDuplication.Location(filePath: "/path/file2.swift", begin: 3)
                                          ])

        let output = format(duplication)

        #expect(output == """
            /path/file1.swift:1:0: warning: 📑 Line equal with file2.swift:3:0
            /path/file1.swift:2:0: warning: 📑 Line equal with file2.swift:4:0
            /path/file1.swift:3:0: warning: 📑 Line equal with file2.swift:5:0
            /path/file2.swift:3:0: warning: 📑 Line equal with file1.swift:1:0
            /path/file2.swift:4:0: warning: 📑 Line equal with file1.swift:2:0
            /path/file2.swift:5:0: warning: 📑 Line equal with file1.swift:3:0
            """)
    }

    @Test
    func should_format_duplication_summary() async throws {
        let duplications = [CodeDuplication(length: 3,
                                            tokenCount: 0,
                                            locations: [
                                                CodeDuplication.Location(filePath: "/path/file1.swift", begin: 1),
                                                CodeDuplication.Location(filePath: "/path/file2.swift", begin: 3)
                                            ]),
                            CodeDuplication(length: 5,
                                            tokenCount: 0,
                                            locations: [
                                                CodeDuplication.Location(filePath: "/path/file1.swift", begin: 1),
                                                CodeDuplication.Location(filePath: "/path/file3.swift", begin: 3)
                                            ])]

        let output = formatedSummary(for: duplications)

        #expect(output == """
            ### Summary
            ### 2 duplications in 3 files
            """)
    }
}

struct CodeDuplicationConversionTests {

    @Test
    func should_init_from_Row() async throws {
        let row = CSV.Row.fixture()

        let duplication = CodeDuplication(csvRow: row)

        #expect(duplication == CodeDuplication(length: 10,
                                               tokenCount: 20,
                                               locations: [
                                                .init(filePath: "/path/file.swift",
                                                      begin: 1),
                                                .init(filePath: "/path/file.swift",
                                                      begin: 1)
                                               ]))
    }
}

import Foundation

typealias FileLocation = CodeDuplication.Location

extension FileLocation {
    struct FormatOptions: OptionSet {
        let rawValue: Int

        static let fileNameOnly = Self(rawValue: 1 << 0)
    }
}

func format(_ location: FileLocation, offset: Int, options: FileLocation.FormatOptions = []) -> String {
    var file = location.filePath
    if options.contains(.fileNameOnly) {
        file = URL(filePath: location.filePath).lastPathComponent
    }

    return "\(file):\(location.begin + offset):0"
}

func format(_ location1: FileLocation, occuringIn location2: FileLocation, offset: Int) -> String {
    return "\(format(location1, offset: offset)): warning: 📑 Line equal with \(format(location2, offset: offset, options: .fileNameOnly))"
}

func format(_ location1: FileLocation, occuringIn location2: FileLocation, length: Int) -> String {
    var formattedLines: [String] = []
    for offset in 0..<length {
        formattedLines.append(format(location1, occuringIn: location2, offset: offset))
    }
    return formattedLines.joined(separator: "\n")
}

func format(_ codeDuplication: CodeDuplication) -> String {
    var formattedLocations: [String] = []
    let locations = codeDuplication.locations
    let duplicationLength = codeDuplication.length
    for location in locations {
        let otherOtherLocations = locations.filter({ $0 != location })
        for otherOtherLocation in otherOtherLocations {
            formattedLocations.append(format(location, occuringIn: otherOtherLocation, length: duplicationLength))
        }
    }

    return formattedLocations.joined(separator: "\n")
}

func format(_ codeDuplications: [CodeDuplication]) -> String {
    var formattedOutput: [String] = []
    for (index, codeDuplication) in codeDuplications.enumerated() {
        formattedOutput.append("""
            ### Duplication #\(index + 1)
            ### \(codeDuplication.length) lines with \(codeDuplication.tokenCount) tokens in \(codeDuplication.locations.count) files
            \(format(codeDuplication))
            """)
    }
    return formattedOutput.joined(separator: "\n")
}

func format(_ source: String) -> String {

    let lines = source.components(separatedBy: "\n")
    let rows = lines.compactMap({ CSV.Row(string: $0) })
    let duplications = rows.map({ CodeDuplication(csvRow: $0) })
    return format(duplications)
}

func formatedSummary(for duplications: [CodeDuplication]) -> String {
    let locations = duplications.flatMap({ $0.locations })
    let fileNames = locations.map({ $0.filePath })
    let filesCount = Set(fileNames).count

    return """
        ### Summary
        ### \(duplications.count) duplications in \(filesCount) files
        """
}

extension CodeDuplication {

    init(csvRow: CSV.Row) {
        self.init(length: Int(csvRow.lineCount),
                  tokenCount: Int(csvRow.tokenCount),
                  locations: csvRow.occurances.map({ CodeDuplication.Location(csvOccurance: $0) }))
    }
}

extension CodeDuplication.Location {

    init(csvOccurance: CSV.Occurance) {
        self.init(filePath: csvOccurance.filePath,
                  begin: Int(csvOccurance.lineStart))
    }
}
