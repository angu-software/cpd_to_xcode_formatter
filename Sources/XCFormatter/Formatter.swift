//
//  Formatter.swift
//  XCFormatter
//
//  Created by Andreas Günther on 23.05.25.
//

import Foundation

struct Formatter {

    func format(_ source: String) -> String {
        return ""
    }

    func format(_ fileOccurance: Duplication.FileOccurrance, lineSuffix: String = "") -> String {
        return """
            \(fileOccurance.filePath):\(fileOccurance.begin):0: warning: <<< Begin of duplication\(lineSuffix)
            \(fileOccurance.filePath):\(fileOccurance.end):0: warning: <<< End of duplication\(lineSuffix)
            """
    }

    func format(_ duplication: Duplication) -> String {
        let duplicateFileNames = duplication
            .fileOccurances
            .map({ URL(fileURLWithPath: $0.filePath).lastPathComponent })

        var fileFormats: [String] = []
        for fileOccurance in duplication.fileOccurances {
            let fileName = URL(fileURLWithPath: fileOccurance.filePath).lastPathComponent
            let otherFileNames = duplicateFileNames.filter({ $0 != fileName })

            fileFormats.append(format(fileOccurance, lineSuffix: " with \(otherFileNames.joined(separator: ","))"))
        }

        return fileFormats.joined(separator: "\n")
    }
}
