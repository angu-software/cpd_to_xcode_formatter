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

    func format(_ fileOccurance: CodeDuplication.FileOccurrance, otherFileLocation: String) -> String {
        return """
            \(fileOccurance.filePath):\(fileOccurance.begin):0: warning: 📑 Line equal with \(otherFileLocation)
            \(fileOccurance.filePath):\(fileOccurance.end):0: warning: 📑 Line equal with \(otherFileLocation)
            """
    }

    func format(_ duplication: CodeDuplication) -> String {
        let duplicateFileNames = duplication
            .fileOccurances
            .map({ URL(fileURLWithPath: $0.filePath).lastPathComponent })

        var fileFormats: [String] = []
        for fileOccurance in duplication.fileOccurances {
            let fileName = URL(fileURLWithPath: fileOccurance.filePath).lastPathComponent
            let otherFileNames = duplicateFileNames.filter({ $0 != fileName })

            fileFormats.append(format(fileOccurance, otherFileLocation: " with \(otherFileNames.joined(separator: ","))"))
        }

        return fileFormats.joined(separator: "\n")
    }
}
