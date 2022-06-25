//
//  MoneyParserTests.swift
//  Artic (iOS)
//
//  Created by jocmp on 6/24/22.
//

import XCTest
@testable import Artic

class MoneyParserTests: XCTestCase {
    func testParsingLocaleInputToNumericValue() throws {
        [
            (localeCode: "en_US", input: "3,000.01"),
            (localeCode: "en_CA", input: "3,000.01"),
            (localeCode: "en_US", input: "3000.01"),
            (localeCode: "en_GB", input: "3,000.01"),
            (localeCode: "de_DE", input: "3.000,01"),
            (localeCode: "fr_FR", input: "3 000,01")
        ].forEach { testCase in
            let expected = Decimal(3000.01)
            let (localeCode, input) = testCase

            let result = MoneyParser.parse(input, localeCode: localeCode)!

            XCTAssertEqual(result, expected, "\(result) is not equal to \(expected) for locale code \(localeCode)")
        }
    }

    func testFormattingToLocalizedUSDValue() throws {
        [
            (localeCode: "en_US", expected: "$3,000.01"),
            (localeCode: "en_GB", expected: "US$3,000.01"),
            (localeCode: "en_CA", expected: "US$3,000.01"),
            (localeCode: "de_DE", expected: "3.000,01 $"),
            (localeCode: "fr_FR", expected: "3 000,01 $US")
        ].forEach { testCase in
            let input = Decimal(3000.01)
            let (localeCode, expected) = testCase

            let result = MoneyParser.format(input, localeCode: localeCode, currencyCode: "USD")

            XCTAssertEqual(result, expected, "for locale code \(localeCode)")
        }
    }

    func testFormattingInputToLocalizedUSDValue() throws {
        let inputWithErronousWhitespace = "3, 0  00.01"
        let localeCode = "en_US"
        let expected = "$3,000.01"

        let result = MoneyParser.format(
            stringLiteral: inputWithErronousWhitespace,
            localeCode: localeCode,
            currencyCode: "USD"
        )

        XCTAssertEqual(result, expected)
    }
}
