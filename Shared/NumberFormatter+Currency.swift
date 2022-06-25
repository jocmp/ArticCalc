//
//  NumbersOnly.swift
//  Artic
//
//  Created by jocmp on 6/19/22.
//

import Foundation

extension NumberFormatter {
    static var currency: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }
}
