//
//  CodeDuplication.swift
//  cpd_to_xcode_formatter
//
//  Created by Andreas Günther on 23.05.25.
//

import Foundation

struct CodeDuplication: Equatable {

    struct FileLocation: Equatable {
        var filePath: String
        var begin: Int
        var end: Int
    }

    var lenght: Int
    var tokenCount: Int
    var locations: [FileLocation]
}
