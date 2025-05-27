//
//  LocationFormattingTests.swift
//  cpd_to_xcode_formatter
//
//  Created by Andreas Günther on 26.05.25.
//

import Testing

@testable import XCFormatter

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
}


