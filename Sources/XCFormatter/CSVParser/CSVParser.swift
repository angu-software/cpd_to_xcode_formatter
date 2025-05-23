//
//  CSVParser.swift
//  cpd_to_xcode_formatter
//
//  Created by Andreas Günther on 23.05.25.
//

import Foundation

extension CSV {

    struct Parser {
        func parse(_ source: String) -> [Row] {
            let rawRows = source.components(separatedBy: .newlines)
            return rawRows.compactMap({ Row(string: $0) })
        }
    }
}
