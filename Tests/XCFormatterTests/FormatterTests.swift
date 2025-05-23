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
    func should_format_to_xcode() async throws {
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
