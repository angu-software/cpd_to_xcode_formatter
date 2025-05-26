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
                ### Summary
                ### 1 duplications in 2 files
                """)
    }
}
