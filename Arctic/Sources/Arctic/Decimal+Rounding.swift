//
//  Decimal+Rounding.swift
//  
//
//  Created by jocmp on 6/27/22.
//

import Foundation

extension Decimal {
    func rounded(_ scale: Int = 1) -> Decimal {
        var decimal = self
        var rounded = Decimal()
        NSDecimalRound(&rounded, &decimal, scale, .plain)
        return rounded
    }
}
