//
//  Projection+Calculation.swift
//  
//
//  Created by jocmp on 6/27/22.
//

import Foundation

extension PaymentPlan {
    public static func calculate(loans: [Loan], monthlyPaymentAmount: Decimal, strategy: PayoffStrategy = .Avalanche) -> PaymentPlan {
        let oldestPersonEverAgeInYears = 122
        let reasonablePayoffInMonths = oldestPersonEverAgeInYears * 12

        let startDate = Date()
        let calendar = Calendar.current
        var paymentPlan = PaymentPlan(loans: loans, monthlyPaymentAmount: monthlyPaymentAmount, strategy: strategy)
        var monthCounter = 0
        
        while (paymentPlan.hasRemainingLoans) {
            if (monthCounter > reasonablePayoffInMonths) {
                break
            }
            let date = calendar.date(byAdding: .month, value: monthCounter, to: startDate)!
            paymentPlan.makeMonthlyPayments(date: date)

            monthCounter += 1
        }

        return paymentPlan
    }
}
