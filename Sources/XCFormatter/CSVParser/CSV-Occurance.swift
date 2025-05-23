//
//  CSV-Occurance.swift
//  cpd_to_xcode_formatter
//
//  Created by Andreas Günther on 23.05.25.
//

import Foundation

extension CSV.Row {
    struct Occurance: Equatable {
        var lineStart: UInt
        var filePath: String
    }
}

extension CSV.Row.Occurance {

    init(string: String) {
        self.init(lineStart: UInt(string.components(separatedBy: ",")[1])!,
                  filePath: string.components(separatedBy: ",")[0])
    }
}
