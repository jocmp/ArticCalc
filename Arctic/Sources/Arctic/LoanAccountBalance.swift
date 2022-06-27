//
//  LoanAccountBalance.swift
//  
//
//  Created by jocmp on 6/27/22.
//

import Foundation

class LoanAccountBalance {
    let loan: Loan
    var rows: [LoanAccountBalanceRow]
    var currentEntry: MonthlyLoanEntry? = nil
    
    init(loan: Loan, rows: [LoanAccountBalanceRow]) {
        self.loan = loan
        self.rows = rows
    }

    func startEntry(date: Date) {
        currentEntry = MonthlyLoanEntry(
            loan: loan,
            date: date,
            interestBalance: lastInterestBalance,
            principalBalance: lastPrincipalBalance,
            totalInterestPaid: lastTotalInterestPaid
        )
    }
    
    func makeMinimumPayment() -> Decimal {
        return currentEntry!.makeMinimumPayment()
    }
    
    func makeExtraPayment(extraPayment: Decimal) -> Decimal {
        return currentEntry!.makePrincipalPayment(amount: extraPayment)
    }
    
    func applyInterest() {
        currentEntry!.applyInterest()
    }
    
    func finishEntry() {
        guard let safeEntry = currentEntry else { return }

        rows.append(
            LoanAccountBalanceRow(
                date: safeEntry.date,
                loanID: loan.id,
                interestBalance: safeEntry.interestBalance,
                principalBalance: safeEntry.principalBalance,
                totalInterestPaid: safeEntry.totalInterestPaid,
                paymentAmount: safeEntry.paymentAmount
            )
        )
    }
    
    var isPaidOff: Bool {
        return currentTotalBalance == 0
    }

    var currentTotalBalance: Decimal {
        return currentEntry!.interestBalance +  currentEntry!.principalBalance
    }
    
    private var lastTotalInterestPaid: Decimal {
        return lastEntry?.totalInterestPaid ?? 0
    }

    private var lastInterestBalance: Decimal {
        return lastEntry?.interestBalance ?? 0
    }
    
    private var lastPrincipalBalance: Decimal {
        return lastEntry?.principalBalance ?? loan.startingBalance.amount
    }
    
    private var lastEntry: LoanAccountBalanceRow? {
        return rows.last
    }
}

struct LoanAccountBalanceRow {
    let date: Date
    let loanID: String
    let interestBalance: Decimal
    let principalBalance: Decimal
    let totalInterestPaid: Decimal
    let paymentAmount: Decimal
}
