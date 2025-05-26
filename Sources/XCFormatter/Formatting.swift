//
//  Formatting.swift
//  cpd_to_xcode_formatter
//
//  Created by Andreas Günther on 26.05.25.
//

import Foundation

typealias FileLocation = CodeDuplication.Location

extension FileLocation {
    struct FormatOptions: OptionSet {
        let rawValue: Int

        static let fileNameOnly = Self(rawValue: 1 << 0)
    }
}

func format(_ location: FileLocation, offset: Int, options: FileLocation.FormatOptions = []) -> String {
    var file = location.filePath
    if options.contains(.fileNameOnly) {
        file = URL(filePath: location.filePath).lastPathComponent
    }

    return "\(file):\(location.begin + offset):0"
}

func format(_ location1: FileLocation, occuringIn location2: FileLocation, offset: Int) -> String {
    return "\(format(location1, offset: offset)): warning: 📑 Line equal with \(format(location2, offset: offset, options: .fileNameOnly))"
}

func format(_ location1: FileLocation, occuringIn location2: FileLocation, length: Int) -> String {
    var formattedLines: [String] = []
    for offset in 0..<length {
        formattedLines.append(format(location1, occuringIn: location2, offset: offset))
    }
    return formattedLines.joined(separator: "\n")
}

func format(_ codeDuplication: CodeDuplication) -> String {
    var formattedLocations: [String] = []
    let locations = codeDuplication.locations
    let duplicationLength = codeDuplication.length
    for location in locations {
        let otherOtherLocations = locations.filter({ $0 != location })
        for otherOtherLocation in otherOtherLocations {
            formattedLocations.append(format(location, occuringIn: otherOtherLocation, length: duplicationLength))
        }
    }

    return formattedLocations.joined(separator: "\n")
}

func format(_ codeDuplications: [CodeDuplication]) -> String {
    var formattedOutput: [String] = []
    for (index, codeDuplication) in codeDuplications.enumerated() {
        formattedOutput.append("""
            ### Duplication #\(index + 1)
            ### \(codeDuplication.length) lines with \(codeDuplication.tokenCount) tokens in \(codeDuplication.locations.count) files
            \(format(codeDuplication))
            """)
    }
    return formattedOutput.joined(separator: "\n")
}

func format(_ source: String) -> String {

    let lines = source.components(separatedBy: "\n")
    let rows = lines.compactMap({ CSV.Row(string: $0) })
    let duplications = rows.map({ CodeDuplication(csvRow: $0) })
    let formatedDuplications = format(duplications)
    let summary = formatedSummary(for: duplications)

    return """
        \(formatedDuplications)
        \(summary)
        """
}

func formatedSummary(for duplications: [CodeDuplication]) -> String {
    let locations = duplications.flatMap({ $0.locations })
    let fileNames = locations.map({ $0.filePath })
    let filesCount = Set(fileNames).count

    return """
        ### Summary
        ### \(duplications.count) duplications in \(filesCount) files
        """
}
