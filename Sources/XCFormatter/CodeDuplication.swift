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
