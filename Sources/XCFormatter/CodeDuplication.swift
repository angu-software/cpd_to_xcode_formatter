//
//  CodeDuplication.swift
//  cpd_to_xcode_formatter
//
//  Created by Andreas Günther on 23.05.25.
//

import Foundation

struct CodeDuplication: Equatable {

    struct Location: Equatable {
        var filePath: String
        var begin: Int
    }

    var length: Int
    var tokenCount: Int
    var locations: [Location]
}

extension CodeDuplication {

    init(csvRow: CSV.Row) {
        self.init(length: Int(csvRow.lineCount),
                  tokenCount: Int(csvRow.tokenCount),
                  locations: csvRow.occurances.map({ CodeDuplication.Location(csvOccurance: $0) }))
    }
}

extension CodeDuplication.Location {

    init(csvOccurance: CSV.Occurance) {
        self.init(filePath: csvOccurance.filePath,
                  begin: Int(csvOccurance.lineStart))
    }
}
