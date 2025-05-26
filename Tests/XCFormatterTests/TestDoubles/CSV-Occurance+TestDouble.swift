//
//  CSV-Occurance+TestDouble.swift
//  cpd_to_xcode_formatter
//
//  Created by Andreas Günther on 26.05.25.
//

@testable import XCFormatter

extension CSV.Occurance {

    static func fixture(lineStart: UInt = 1,
                        filePath: String = "/path/file.swift") -> Self {
        return Self(lineStart: lineStart,
                    filePath: filePath)
    }
}
