//
//  Projection+Calculation.swift
//  
//
//  Created by jocmp on 6/27/22.
//

import Foundation

extension Projection {
    static func calculate(loans: [Loan], monthlyPaymentAmount: Decimal, strategy: PayoffStrategy = .Avalanche) -> Projection {
        let oldestPersonEverAgeInYears = 122
        let reasonablePayoffInMonths = oldestPersonEverAgeInYears * 12

        let startDate = Date()
        let calendar = Calendar.current
        var projection = Projection(loans: loans, monthlyPaymentAmount: monthlyPaymentAmount, strategy: strategy)
        var monthCounter = 0
        
        while (projection.hasRemainingLoans) {
            if (monthCounter > reasonablePayoffInMonths) {
                break
            }
            let date = calendar.date(byAdding: .month, value: monthCounter, to: startDate)!
            projection.makeMonthlyPayments(date: date)

            monthCounter += 1
        }

        return projection
    }
}
