//
//  Projection.swift
//  
//
//  Created by jocmp on 6/26/22.
//

import Foundation

typealias LoanID = String

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

struct Projection {
    private var mapping: [LoanID : LoanBalanceSheet]
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
        for loan in sortedLoans {
            let balanceSheet = findBalanceSheet(id: loan.id)
            self.remainingPaymentAmount -= balanceSheet.makeMinimumPayment()
        }
        removePaidOffLoans()
    }
    
    private mutating func makeExtraPayments() {
        for loan in sortedLoans {
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

    func findBalanceSheet(id: LoanID) -> LoanBalanceSheet {
        return mapping[id]!
    }

    var hasRemainingLoans: Bool {
        return !loans.isEmpty
    }
    
    var sortedLoans: [Loan] {
        return loans.sorted(by: payoffStrategySort)
    }

    var principalPaidAmount: Decimal {
        return mapping.values.reduce(Decimal(0), { accumulator, sheet in
            accumulator + sheet.loan.startingBalance.amount
        })
    }

    var interestPaidAmount: Decimal {
        return mapping.values.reduce(Decimal(0), { accumulator, value in
            return accumulator + value.rows.last!.totalInterestPaid
        })
    }
}

class LoanBalanceSheet {
    let loan: Loan
    var rows: [BalanceSheetRow]
    var currentEntry: MonthlyLoanEntry? = nil
    
    init(loan: Loan, rows: [BalanceSheetRow]) {
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
            BalanceSheetRow(
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
    
    private var lastEntry: BalanceSheetRow? {
        return rows.last
    }
}

func makeLoanPaymentMapping(_ loans: [Loan]) -> [LoanID : LoanBalanceSheet] {
    var mapping = [LoanID : LoanBalanceSheet]()
    loans.forEach { loan in
        mapping.updateValue(LoanBalanceSheet(loan: loan, rows: []), forKey: loan.id)
    }
    return mapping
}

struct BalanceSheetRow {
    let date: Date
    let loanID: String
    let interestBalance: Decimal
    let principalBalance: Decimal
    let totalInterestPaid: Decimal
    let paymentAmount: Decimal
}

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

enum PayoffStrategy {
    case Snowball
    case Avalanche
}

extension Decimal {
    func rounded(_ scale: Int = 1) -> Decimal {
        var decimal = self
        var rounded = Decimal()
        NSDecimalRound(&rounded, &decimal, scale, .plain)
        return rounded
    }
}
