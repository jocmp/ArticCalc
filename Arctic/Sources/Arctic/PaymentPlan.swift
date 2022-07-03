//
//  PaymentPlan.swift
//  
//
//  Created by jocmp on 6/26/22.
//

import Foundation


public enum PayoffStrategy {
    case Snowball
    case Avalanche
}

public struct PaymentPlan {
    private var mapping: [LoanID : LoanAccountBalance]
    private var loans: [Loan]
    private var monthlyPaymentAmount: Decimal
    private var remainingPaymentAmount: Decimal
    private let strategy: PayoffStrategy
    
    init(loans: [Loan], monthlyPaymentAmount: Decimal, strategy: PayoffStrategy = .Avalanche) {
        self.mapping = makeLoanPaymentMapping(loans)
        self.loans = loans
        self.monthlyPaymentAmount = monthlyPaymentAmount
        self.remainingPaymentAmount = monthlyPaymentAmount
        self.strategy = strategy
    }
    
    public var principalPaidAmount: Decimal {
        return mapping.values.reduce(Decimal(0), { accumulator, sheet in
            accumulator + sheet.loan.startingBalance.amount
        })
    }
    
    public var interestPaidAmount: Decimal {
        return mapping.values.reduce(Decimal(0), { accumulator, value in
            return accumulator + value.rows.last!.totalInterestPaid
        })
    }
    
    public var minimumPaymentsAmount: Decimal {
        return mapping.values.reduce(Decimal(0), { accumulator, value in
            return accumulator + value.loan.minimumPayment.amount
        })
    }
    
    mutating func makeMonthlyPayments(date: Date) {
        self.remainingPaymentAmount = monthlyPaymentAmount
        
        withMonthlyEntries(date) {
            applyInterest()
            makeMininumPayments()
            makeExtraPayments()
        }
    }
    
    func withMonthlyEntries(_ date: Date, onCurrentEntries: () -> ()) {
        let openBalances = loans.map { loan in
            let balanceSheet = findBalanceSheet(id: loan.id)
            balanceSheet.startEntry(date: date)
            return balanceSheet
        }
        onCurrentEntries()
        openBalances.forEach { balance in
            balance.finishEntry()
        }
    }
    
    private mutating func makeMininumPayments() {
        sortedLoans.forEach { loan in
            let balanceSheet = findBalanceSheet(id: loan.id)
            self.remainingPaymentAmount -= balanceSheet.makeMinimumPayment()
        }
        removePaidOffLoans()
    }
    
    private mutating func makeExtraPayments() {
        sortedLoans.forEach { loan in
            let balanceSheet = findBalanceSheet(id: loan.id)
            self.remainingPaymentAmount -= balanceSheet.makeExtraPayment(extraPayment: remainingPaymentAmount)
        }
        removePaidOffLoans()
    }
    
    private mutating func applyInterest() {
        loans.forEach { loan in
            let balanceSheet = findBalanceSheet(id: loan.id)
            balanceSheet.applyInterest()
        }
    }
    
    func payoffStrategySort(lhs: Loan, rhs: Loan) -> Bool {
        switch strategy {
        case .Snowball:
            let lhsBalances = mapping[lhs.id]!
            let rhsBalances = mapping[rhs.id]!
            
            return lhsBalances.currentTotalBalance < rhsBalances.currentTotalBalance
        case .Avalanche:
            return lhs.interestRate > rhs.interestRate
        }
    }
    
    private mutating func removePaidOffLoans() {
        mapping.forEach { (loanID, balanceSheet) in
            if (balanceSheet.isPaidOff) {
                loans.removeAll(where: { $0.id == loanID })
            }
        }
    }
    
    func findBalanceSheet(id: LoanID) -> LoanAccountBalance {
        return mapping[id]!
    }
    
    var hasRemainingLoans: Bool {
        return !loans.isEmpty
    }
    
    var sortedLoans: [Loan] {
        return loans.sorted(by: payoffStrategySort)
    }
}

fileprivate func makeLoanPaymentMapping(_ loans: [Loan]) -> [LoanID : LoanAccountBalance] {
    var mapping = [LoanID : LoanAccountBalance]()
    loans.forEach { loan in
        mapping.updateValue(LoanAccountBalance(loan: loan, rows: []), forKey: loan.id)
    }
    return mapping
}
