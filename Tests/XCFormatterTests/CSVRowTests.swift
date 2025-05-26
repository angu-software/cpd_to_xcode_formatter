//
//  CSVRowTests.swift
//  cpd_to_xcode_formatter
//
//  Created by Andreas Günther on 23.05.25.
//

import Foundation
import Testing

@testable import XCFormatter

struct CSVRowTests {

    private typealias Row = CSV.Row
    private typealias Occurance = CSV.Occurance

    @Test
    func sould_parse_from_string() {
        let source = "125,844,2,955,/Users/angu/Repos/pandocsios/Pandocs/Controller/DashboardController/DashboardViewController.swift,217,/Users/angu/Repos/pandocsios/Pandocs/Controller/ProfileController/ProfileViewController.swift"

        let row = Row(string: source)

        #expect(row == .fixture(lineCount: 125,
                                tokenCount: 844,
                                occurances: [
                                    .fixture(lineStart: 955,
                                             filePath: "/Users/angu/Repos/pandocsios/Pandocs/Controller/DashboardController/DashboardViewController.swift"),
                                    .fixture(lineStart: 217,
                                             filePath: "/Users/angu/Repos/pandocsios/Pandocs/Controller/ProfileController/ProfileViewController.swift")
                                ]))
    }

    @Test
    func sould_not_parse_first_row_from_csv_string() {
        let source = "lines,tokens,occurrences"

        let row = Row(string: source)

        #expect(row == nil)
    }

    @Test
    func should_not_parse_invalid_input() {
        let source = "asdfsadfsdf"

        let row = Row(string: source)

        #expect(row == nil)
    }
}
