//
//  MoneyParser.swift
//
//
//  Created by jocmp on 6/24/22.
//

import Foundation

public struct MoneyParser {
    public static func parse(_ value: String, localeCode: String = Locale.current.identifier) -> Decimal? {
        let cleanedValue = value.replacingOccurrences(of: " ", with: "")
        let formatter = makeInputFormatter(localeCode: localeCode)
        return formatter.number(from: cleanedValue)?.decimalValue
    }

    public static func format(stringLiteral: String, localeCode: String, currencyCode: String) -> String {
        guard let parsed = parse(stringLiteral, localeCode: localeCode) else { return "" }

        return format(
            parsed,
            localeCode: localeCode,
            currencyCode: currencyCode
        )
    }

    public static func format(_ value: Decimal, localeCode: String, currencyCode: String) -> String {
        let formatter = makeCurrencyFormatter(localeCode: localeCode, currencyCode: currencyCode)
        return formatter.string(from: value as NSNumber) ?? ""
    }
}

func makeInputFormatter(localeCode: String) -> NumberFormatter {
    let formatter = NumberFormatter()
    let locale = Locale.init(identifier: localeCode)
    formatter.locale = locale
    formatter.numberStyle = .decimal
    return formatter
}

func makeCurrencyFormatter(localeCode: String, currencyCode: String) -> NumberFormatter {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.currencyCode = currencyCode
    formatter.locale = Locale.init(identifier: localeCode)
    formatter.alwaysShowsDecimalSeparator = true
    formatter.usesGroupingSeparator = true
    return formatter
}
