//
//  CSVParserTests.swift
//  cpd_to_xcode_formatter
//
//  Created by Andreas Günther on 23.05.25.
//

import Foundation
import Testing

@testable import XCFormatter

struct CSVParserTests {

    typealias Parser = CSV.Parser
    typealias Row = CSV.Row
    typealias Occurance = CSV.Occurance

    @Test
    func should_prase_cpd_csv() {
        let source = """
            lines,tokens,occurrences
            125,844,2,955,/Users/angu/Repos/pandocsios/Pandocs/Controller/DashboardController/DashboardViewController.swift,217,/Users/angu/Repos/pandocsios/Pandocs/Controller/ProfileController/ProfileViewController.swift
            100,668,2,304,/Users/angu/Repos/pandocsios/Classes/ChallengeModal.swift,78,/Users/angu/Repos/pandocsios/Classes/Challenges/RecipeChallenge.swift
            """

        let rows = Parser().parse(source)

        #expect(
            rows == [
                Row(
                    lineCount: 125,
                    tokenCount: 844,
                    occurancesCount: 2,
                    occurances: [
                        Occurance(
                            lineStart: 955,
                            filePath: "/Users/angu/Repos/pandocsios/Pandocs/Controller/DashboardController/DashboardViewController.swift"
                        ),
                        Occurance(
                            lineStart: 217,
                            filePath: "/Users/angu/Repos/pandocsios/Pandocs/Controller/ProfileController/ProfileViewController.swift"
                        ),
                    ]
                ),
                Row(
                    lineCount: 100,
                    tokenCount: 668,
                    occurancesCount: 2,
                    occurances: [
                        Occurance(
                            lineStart: 304,
                            filePath: "/Users/angu/Repos/pandocsios/Classes/ChallengeModal.swift"
                        ),
                        Occurance(
                            lineStart: 78,
                            filePath: "/Users/angu/Repos/pandocsios/Classes/Challenges/RecipeChallenge.swift"
                        ),
                    ]
                )
            ]
        )
    }
}
