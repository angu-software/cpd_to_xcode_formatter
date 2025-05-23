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


extension CodeDuplication.FileLocation {

    var length: Int {
        return end - begin + 1
    }

    init(filePath: String, begin: Int, length: Int) {
        self.init(filePath: filePath,
                  begin: begin,
                  end: begin + length - 1)
    }
}
