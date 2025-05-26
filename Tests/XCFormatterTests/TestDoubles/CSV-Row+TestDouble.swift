//
//  CSV-Row+TestDouble.swift
//  cpd_to_xcode_formatter
//
//  Created by Andreas Günther on 26.05.25.
//

@testable import XCFormatter

extension CSV.Row {

    static func fixture(lineCount: UInt = 10,
                        tokenCount: UInt = 20,
                        occurances: [CSV.Occurance] = [.fixture(),
                                                       .fixture()]) -> Self {
                                                           return Self(lineCount: lineCount,
                                                                       tokenCount: tokenCount,
                                                                       occurancesCount: UInt(occurances.count),
                                                                       occurances: occurances)
                                                       }
}
