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

    init?(string: String) {
        let lineComponents = string.components(separatedBy: ",")
        let rawLineCount = lineComponents[0]
        let rawTokenCount = lineComponents[1]
        let rawOccurancesCount = lineComponents[2]

        guard let lineCount = NumberParser.parse(rawLineCount),
              let tokenCount = NumberParser.parse(rawTokenCount),
              let occurancesCount = NumberParser.parse(rawOccurancesCount) else {
            return nil
        }

        let occurancesComponents = lineComponents.suffix(from: 3).map({ $0 })
        var groupedComponents: [[String]] = []

        for i in stride(from: 0, to: occurancesComponents.count, by: 2) {
            if i + 1 < occurancesComponents.count {
                groupedComponents.append([occurancesComponents[i], occurancesComponents[i + 1]])
            }
        }

        let occurances = groupedComponents.map { rawOccuranceComponents in
            let rawOccurance = rawOccuranceComponents.joined(separator: ",")
            return CSV.Occurance(string: rawOccurance)
        }

        self.init(lineCount: lineCount,
                  tokenCount: tokenCount,
                  occurancesCount: occurancesCount,
                  occurances: occurances)
    }

    private static func stringToNumber(_ source: String) -> UInt {
        return UInt(source)!
    }
}

struct NumberParser {

    static func parse(_ string: String) -> UInt? {
        return UInt(string)
    }
}
