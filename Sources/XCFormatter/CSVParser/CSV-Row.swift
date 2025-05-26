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
        self.init(string.components(separatedBy: ","))
    }

    private init?(_ lineComponents: [String]) {
        guard lineComponents.count >= 3 else {
            return nil
        }

        let rawLineCount = lineComponents[0]
        let rawTokenCount = lineComponents[1]
        let rawOccurancesCount = lineComponents[2]
        let occurancesComponents = lineComponents.suffix(from: 3).map({ $0 })

        self.init(rawLineCount: rawLineCount,
                  rawTokenCount: rawTokenCount,
                  rawOccurancesCount: rawOccurancesCount,
                  occurancesComponents: occurancesComponents)
    }
    
    private init?(rawLineCount: String,
                  rawTokenCount: String,
                  rawOccurancesCount: String,
                  occurancesComponents: [String]) {
        guard let lineCount = NumberParser.parse(rawLineCount),
              let tokenCount = NumberParser.parse(rawTokenCount),
              let occurancesCount = NumberParser.parse(rawOccurancesCount) else {
            return nil
        }

        let occurances = Self.occurances(from: occurancesComponents)

        self.init(lineCount: lineCount,
                  tokenCount: tokenCount,
                  occurancesCount: occurancesCount,
                  occurances: occurances)
    }

    private static func occurances(from occurancesComponents: [String]) -> [CSV.Occurance] {
        let groupedComponents = Self.groupedRawOccurances(occurancesComponents)

        return groupedComponents.map { rawOccuranceComponents in
            let rawOccurance = rawOccuranceComponents.joined(separator: ",")
            return CSV.Occurance(string: rawOccurance)
        }
    }

    private static func groupedRawOccurances(_ occurancesComponents: [String]) -> [[String]] {
        var groupedComponents: [[String]] = []
        for i in stride(from: 0, to: occurancesComponents.count, by: 2) {
            if i + 1 < occurancesComponents.count {
                groupedComponents.append([occurancesComponents[i], occurancesComponents[i + 1]])
            }
        }
        return groupedComponents
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
