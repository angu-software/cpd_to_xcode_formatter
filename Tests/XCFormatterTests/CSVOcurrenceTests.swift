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
        let source = "/Users/angu/Repos/pandocsios/Pandocs/Controller/DashboardController/DashboardViewController.swift,217"

        let entry = Occurance(string: source)

        #expect(entry == Occurance(lineStart: 217,
                                   filePath: "/Users/angu/Repos/pandocsios/Pandocs/Controller/DashboardController/DashboardViewController.swift"))
    }
}
