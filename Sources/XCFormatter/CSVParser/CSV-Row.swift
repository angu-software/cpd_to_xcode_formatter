//
//  CSVRow.swift
//  cpd_to_xcode_formatter
//
//  Created by Andreas Günther on 23.05.25.
//

import Foundation

enum CSV {
    struct Row: Equatable {
        var lineCount: UInt
        var tokenCount: UInt
        var occurancesCount: UInt
        var occurances: [Occurance]
    }
}

extension CSV.Row {

    init(string: String) {
        let lineComponents = string.components(separatedBy: ",")
        let rawLineCount = lineComponents[0]
        let rawTokenCount = lineComponents[1]
        let rawOccurancesCount = lineComponents[2]

        let rawOccurances = lineComponents.suffix(from: 3).map({ $0 })
        var groupedArrays: [[String]] = []

        for i in stride(from: 0, to: rawOccurances.count, by: 2) {
            if i + 1 < rawOccurances.count {
                groupedArrays.append([rawOccurances[i], rawOccurances[i + 1]])
            }
        }

        let occurances = groupedArrays.map { rawOccuranceComponents in
            let rawOccurance = rawOccuranceComponents.joined(separator: ",")
            return CSV.Occurance(string: rawOccurance)
        }

        self.init(lineCount: NumberParser.parse(rawLineCount),
                  tokenCount: NumberParser.parse(rawTokenCount),
                  occurancesCount: NumberParser.parse(rawOccurancesCount),
                  occurances: occurances)
    }

    private static func stringToNumber(_ source: String) -> UInt {
        return UInt(source)!
    }
}

struct NumberParser {

    static func parse(_ string: String) -> UInt {
        return UInt(string)!
    }
}
