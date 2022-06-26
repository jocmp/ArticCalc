//
//  Monetize.swift
//  
//
//  Created by jocmp on 6/25/22.
//

import Foundation
import Money

enum Monetize {
    static func from(_ value: Decimal, currencyCode: String) -> AnyMoney? {
        switch currencyCode {
        case "EUR":
            return Money<EUR>(value)
        case "CAD":
            return Money<CAD>(value)
        case "GBP":
            return Money<GBP>(value)
        case "USD":
            return Money<USD>(value)
        default:
            return nil
        }
    }
}
