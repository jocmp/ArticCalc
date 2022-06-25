//
//  AnyMoney.swift
//  
//
//  Created by jocmp on 6/25/22.
//

import Foundation
import Money

public protocol AnyMoney {
    var amount: Decimal { get }
    var currency: CurrencyType.Type { get }
}

extension Money: AnyMoney {}
