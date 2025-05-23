//
//  Tests.swift
//  cpd_to_xcode_formatter
//
//  Created by Andreas Günther on 23.05.25.
//

import Foundation
import Testing

@testable import XCFormatter

struct OccuranceTests {

    private typealias Occurance = CSV.Occurance

    @Test
    func should_parse_from_string() {
        let source = "955,/Users/angu/Repos/pandocsios/Pandocs/Controller/DashboardController/DashboardViewController.swift"

        let entry = Occurance(string: source)

        #expect(entry == Occurance(lineStart: 955,
                                   filePath: "/Users/angu/Repos/pandocsios/Pandocs/Controller/DashboardController/DashboardViewController.swift"))
    }
}
