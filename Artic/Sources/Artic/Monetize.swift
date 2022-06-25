//
//  Monetize.swift
//  
//
//  Created by jocmp on 6/25/22.
//

import Foundation
import Money

enum Monetize {
    static func from(minorUnits: Int, currencyCode: String) -> AnyMoney? {
        switch currencyCode {
        case "EUR":
            return Money<EUR>(minorUnits: minorUnits)
        case "CAD":
            return Money<CAD>(minorUnits: minorUnits)
        case "GBP":
            return Money<GBP>(minorUnits: minorUnits)
        case "USD":
            return Money<USD>(minorUnits: minorUnits)
        default:
            return nil
        }
    }
}
