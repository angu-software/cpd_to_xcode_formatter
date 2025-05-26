//
//  CodeDuplicationConversionTests.swift
//  cpd_to_xcode_formatter
//
//  Created by Andreas Günther on 26.05.25.
//

import Testing

@testable import XCFormatter

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
