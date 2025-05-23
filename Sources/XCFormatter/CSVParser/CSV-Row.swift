//
//  CSVRow.swift
//  cpd_to_xcode_formatter
//
//  Created by Andreas Günther on 23.05.25.
//

enum CSV {
    struct Row: Equatable {
        var lineCount: UInt
        var tokenCount: UInt
        var occurancesCount: UInt
        var occurances: [Occurance]
    }
}
