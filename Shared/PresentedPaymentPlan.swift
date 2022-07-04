//
//  PaymentPlan.swift
//  ArcticApp
//
//  Created by jocmp on 7/3/22.
//

import Foundation
import CoreData
import Arctic

class PresentedPaymentPlan: ObservableObject {
    private let loans: [Loan]
    private var paymentPlan: PaymentPlan
    let minimumPayment: Double
    @Published var monthlyPayment: Double {
        didSet {
            calculate()
        }
    }

    init(viewContext: NSManagedObjectContext) {
        self.loans = try! viewContext.fetch(Loan.findAll())
        let arcticLoans = loans.map { $0.asArcticLoan() }
        
        minimumPayment = arcticLoans
            .reduce(0, { $0 + $1.minimumPayment.amount })
            .toDouble()
        monthlyPayment = minimumPayment

        paymentPlan = PaymentPlan.calculate(
            loans: arcticLoans,
            monthlyPaymentAmount: Decimal(minimumPayment)
        )
    }
    
    func calculate() {
        paymentPlan = PaymentPlan.calculate(
            loans: loans.map { $0.asArcticLoan()},
            monthlyPaymentAmount: Decimal(monthlyPayment)
        )
    }
    
    var interestPaid: String {
        return paymentPlan.interestPaidAmount.formatted()
    }
    
    var principalPaid: String {
        return paymentPlan.principalPaidAmount.formatted()
    }
    
    public var monthlyBalanceSheets: [LoanBalanceSheet] {
        return paymentPlan.monthlyBalanceSheets.sorted()
    }
}

extension LoanBalanceSheet: Identifiable, Comparable {
    public static func < (lhs: Arctic.LoanBalanceSheet, rhs: Arctic.LoanBalanceSheet) -> Bool {
        return lhs.name < rhs.name
    }
    
    public var name: String {
        return loan.name
    }
    
    public var id: String {
        return name
    }
    
    public static func == (lhs: Arctic.LoanBalanceSheet, rhs: Arctic.LoanBalanceSheet) -> Bool {
        return lhs.name == rhs.name
    }
}

extension Decimal {
    func toDouble() -> Double {
        return (self as NSDecimalNumber).doubleValue
    }
}
