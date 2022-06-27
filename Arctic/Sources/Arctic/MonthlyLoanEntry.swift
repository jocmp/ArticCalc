//
//  MonthlyLoanEntry.swift
//  
//
//  Created by jocmp on 6/27/22.
//

import Foundation

struct MonthlyLoanEntry {
    let date: Date
    let loan: Loan
    var interestBalance: Decimal
    var principalBalance: Decimal
    var totalInterestPaid: Decimal
    var paymentAmount: Decimal = 0
    
    init(loan: Loan, date: Date, interestBalance: Decimal, principalBalance: Decimal, totalInterestPaid: Decimal) {
        self.loan = loan
        self.date = date
        self.interestBalance = interestBalance
        self.principalBalance = principalBalance
        self.totalInterestPaid = totalInterestPaid
    }
    
    mutating func makeMinimumPayment() -> Decimal {
        let payment = loan.minimumPayment.amount
    
        if (payment > interestBalance) {
            let paidDown = interestBalance
            let leftover = payment - paidDown
            paymentAmount += paidDown
            totalInterestPaid += paidDown
            interestBalance = 0
        
            return paidDown + makePrincipalPayment(amount: leftover)
        } else {
            interestBalance -= payment
            paymentAmount += payment
            return payment
        }
    }
    
    mutating func makePrincipalPayment(amount payment: Decimal) -> Decimal {
        if (payment > principalBalance) {
            let paidDown = principalBalance
            paymentAmount += paidDown
            principalBalance = 0
            return paidDown
        } else {
            principalBalance -= payment
            paymentAmount += payment
            return payment
        }
    }
    
    mutating func applyInterest() {
        interestBalance = (currentBalance * interestRatePercent).rounded(2)
    }
    
    var interestRatePercent: Decimal {
        return loan.interestRate / 100.0 / 12.0
    }
    
    var currentBalance: Decimal {
        return interestBalance + principalBalance
    }
}
