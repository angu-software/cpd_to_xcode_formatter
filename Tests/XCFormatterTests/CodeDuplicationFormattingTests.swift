//
//  CodeDuplicationFormattingTests.swift
//  cpd_to_xcode_formatter
//
//  Created by Andreas Günther on 26.05.25.
//

import Testing

@testable import XCFormatter

struct CodeDuplicationFormattingTests {

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
