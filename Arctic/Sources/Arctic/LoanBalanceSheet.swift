//
//  LoanBalanceSheet.swift
//  
//
//  Created by jocmp on 6/27/22.
//

import Foundation

public class LoanBalanceSheet {
    public let loan: Loan
    public var rows: [LoanBalanceSheetRow]
    var currentEntry: MonthlyLoanEntry? = nil
    
    init(loan: Loan, rows: [LoanBalanceSheetRow]) {
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
            LoanBalanceSheetRow(
                date: safeEntry.date,
                loanID: loan.id,
                loanName: loan.name,
                principalBalance: safeEntry.principalBalance,
                totalInterestPaid: safeEntry.totalInterestPaid,
                paymentAmount: safeEntry.paymentAmount,
                interestBalance: safeEntry.interestBalance
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
    
    private var lastEntry: LoanBalanceSheetRow? {
        return rows.last
    }
}

public struct LoanBalanceSheetRow {
    public let date: Date
    public let loanID: String
    public let loanName: String
    public let principalBalance: Decimal
    public let totalInterestPaid: Decimal
    public let paymentAmount: Decimal
    let interestBalance: Decimal
}
