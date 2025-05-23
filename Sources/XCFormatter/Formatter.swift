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

    func format(_ fileOccurance: Duplication.FileOccurrance) -> String {
        return """
            \(fileOccurance.filePath):\(fileOccurance.begin):0: warning: <<< Begin of duplication
            \(fileOccurance.filePath):\(fileOccurance.end):0: warning: <<< End of duplication
            """
    }
}
