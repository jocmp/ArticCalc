//
//  MonetizeTests.swift
//
//
//  Created by jocmp on 6/25/22.
//

import XCTest
@testable import Arctic

class MonetizeTests: XCTestCase {
    func testSupportedCurrencies() throws {
        [
            "CAD",
            "EUR",
            "GBP",
            "USD"
        ].forEach { supportedCurrencyCode in
            let money = Monetize.from(10.01, currencyCode: supportedCurrencyCode)!
            XCTAssertEqual(money.amount, 10.01)
            XCTAssertEqual(money.currency.code, supportedCurrencyCode)
        }
    }

    func testUnsupportedCurrency() {
        let unsupportedCode = "bogus"
        XCTAssertNil(Monetize.from(10.00, currencyCode: unsupportedCode))
    }
}
