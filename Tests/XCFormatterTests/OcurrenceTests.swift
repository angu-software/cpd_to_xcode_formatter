//
//  Tests.swift
//  cpd_to_xcode_formatter
//
//  Created by Andreas Günther on 23.05.25.
//

import Foundation

import Testing

enum CSV {
    struct OccuranceEntry: Equatable {
        var filePath: String
        var lineStart: UInt
    }
}

extension CSV.OccuranceEntry {

    init(string: String) {
        self.init(filePath: string.components(separatedBy: ",")[0],
                  lineStart: UInt(string.components(separatedBy: ",")[1])!)
    }
}

@Test
func should_parse_csv_occurance_from_string() {
    let source = "/Users/angu/Repos/pandocsios/Pandocs/Controller/DashboardController/DashboardViewController.swift,217"

    let entry = CSV.OccuranceEntry(string: source)

    #expect(entry == CSV.OccuranceEntry(filePath: "/Users/angu/Repos/pandocsios/Pandocs/Controller/DashboardController/DashboardViewController.swift",
                                        lineStart: 217))
}
