//
//  FormatterTests.swift
//  cpd_to_xcode_formatter
//
//  Created by Andreas Günther on 23.05.25.
//

import Testing

@testable import XCFormatter

struct FormatterTests {

    private let formatter = XCFormatter.Formatter()

    @Test
    func should_format_cpd_csv_to_xcode() async throws {
        withKnownIssue("Under development") {
            let source = """
                lines,tokens,occurrences
                125,844,2,955,/Users/angu/Repos/pandocsios/Pandocs/Controller/DashboardController/DashboardViewController.swift,217,/Users/angu/Repos/pandocsios/Pandocs/Controller/ProfileController/ProfileViewController.swift
                """

            let output = Formatter().format(source)
            #expect(output == """
                ==== #1 ====
                /Users/angu/Repos/pandocsios/Pandocs/Controller/DashboardController/DashboardViewController.swift:955:0: warning: <<< Begin of duplication with ProfileViewController.swift
                /Users/angu/Repos/pandocsios/Pandocs/Controller/DashboardController/DashboardViewController.swift:1080:0: warning: <<< End of duplication with ProfileViewController.swift
                /Users/angu/Repos/pandocsios/Pandocs/Controller/ProfileController/ProfileViewController.swift:217:0: warning: <<< Begin of duplication with DashboardViewController.swift
                /Users/angu/Repos/pandocsios/Pandocs/Controller/ProfileController/ProfileViewController.swift:342:0: warning: <<< End of duplication with DashboardViewController.swift
                """)
        }
    }
}

struct FileLocationFormattingTests {

    @Test
    func should_format_to_path_with_line_and_column() async throws {
        let location = CodeDuplication.FileLocation(filePath: "/path/file.swift", begin: 3)

        let output = format(location, offset: 1)

        #expect(output == "/path/file.swift:4:0")
    }

    @Test
    func should_format_equal_code_location_lines() {
        let location1 = CodeDuplication.FileLocation(filePath: "/path/file1.swift", begin: 1)
        let location2 = CodeDuplication.FileLocation(filePath: "/path/file2.swift", begin: 3)

        let output = format(location1, occuringIn: location2, offset: 1)

        #expect(output == "/path/file1.swift:2:0: warning: 📑 Line equal with file2.swift:4:0")
    }

    @Test
    func should_format_equal_code_locations() async throws {
        let location1 = CodeDuplication.FileLocation(filePath: "/path/file1.swift", begin: 1)
        let location2 = CodeDuplication.FileLocation(filePath: "/path/file2.swift", begin: 3)

        let output = format(location1, occuringIn: location2, length: 3)

        #expect(output == """
            /path/file1.swift:1:0: warning: 📑 Line equal with file2.swift:3:0
            /path/file1.swift:2:0: warning: 📑 Line equal with file2.swift:4:0
            /path/file1.swift:3:0: warning: 📑 Line equal with file2.swift:5:0
            """)
    }
}

import Foundation

typealias FileLocation = CodeDuplication.FileLocation

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
