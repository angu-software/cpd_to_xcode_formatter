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

        #expect(row == Row(lineCount: 125,
                           tokenCount: 844,
                           occurancesCount: 2,
                           occurances: [
                            .init(lineStart: 955,
                                  filePath: "/Users/angu/Repos/pandocsios/Pandocs/Controller/DashboardController/DashboardViewController.swift"),
                            .init(lineStart: 217,
                                  filePath: "/Users/angu/Repos/pandocsios/Pandocs/Controller/ProfileController/ProfileViewController.swift")
                           ]))
    }

    @Test
    func sould_not_parse_first_rwo_from_csv_string() {
        let source = "lines,tokens,occurrences"

        let row = Row(string: source)

        #expect(row == nil)
    }
}
