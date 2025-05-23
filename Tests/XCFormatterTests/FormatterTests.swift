//
//  FormatterTests.swift
//  cpd_to_xcode_formatter
//
//  Created by Andreas Günther on 23.05.25.
//

import Testing

@testable import XCFormatter

struct FormatterTests {

    private let formatter = Formatter()

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

    @Test
    func should_format_FileOccurrance_to_xcode() async throws {
        let file = Duplication.FileOccurrance(filePath: "/some/path/source.swift", begin: 1, end: 2)

        let output = formatter.format(file, otherFileLocation: "otherFileLocation")

        #expect(output == """
            /some/path/source.swift:1:0: warning: 📑 Line equal with otherFileLocation
            /some/path/source.swift:2:0: warning: 📑 Line equal with otherFileLocation
            """)
    }

    // MARK: - DuplicationFormatter

    @Test
    func should_format_eachLine() async throws {
        let duplication = Duplication(lenght: 2, tokenCount: 3, fileOccurances: [
            Duplication.FileOccurrance(filePath: "/some/path/source_1.swift", begin: 1, end: 3),
            Duplication.FileOccurrance(filePath: "/some/path/source_2.swift", begin: 3, end: 5)
        ])

        let output = formatter.format(duplication)

        #expect(output == """
            /some/path/source_1.swift:1:0: warning: 📑 Line equal with source_2.swift:3:0
            /some/path/source_1.swift:2:0: warning: 📑 Line equal with source_2.swift:4:0
            /some/path/source_1.swift:3:0: warning: 📑 Line equal with source_2.swift:5:0
            /some/path/source_2.swift:3:0: warning: 📑 Line equal with source_1.swift:1:0
            /some/path/source_2.swift:4:0: warning: 📑 Line equal with source_1.swift:2:0
            /some/path/source_2.swift:5:0: warning: 📑 Line equal with source_1.swift:3:0
            """
        )
    }
}

// TODO: modes, start/end marker, warning for each line and each duplicate file
